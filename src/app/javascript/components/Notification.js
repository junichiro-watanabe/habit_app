import React from "react"
import PropTypes from "prop-types"
import Modal from 'react-modal'
import Micropost from './Micropost'

const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: '-45%',
    bottom: '-30%',
    transform: 'translate(-50%, -50%)',
    overflow: 'auto',
    WebkitOverflowScrolling: 'touch',
    background: 'rgb(255, 243, 228)'
  }
};

class Notification extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      information: this.props.notification.information
    }
  }

  afterOpenModal = () => {
    this.close.style.float = 'right';
    this.close.style.fontSize = '30px';
    this.close.style.cursor = 'pointer';
  }

  closeModal = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          information: json.information,
          count: json.count
        })
        this.props.setCount(json.count)
        this.props.closeModal()
      }
    )
  }

  getNotification(item) {
    if (item.action === "follow") {
      return (
        <div className="notification">
          <div className="information">
            <a href={item.visitor_path}>{item.visitor}</a> が あなたをフォローしました。
            <div className="time">
              {item.time}
            </div>
          </div>
        </div>
      )
    } else if (item.action === "belong") {
      return (
        <div className="notification">
          <div className="information">
            <a href={item.visitor_path}>{item.visitor}</a> が
            あなたの主催する <a href={item.group_path}>{item.group}</a> に参加しました。
            <div className="time">
              {item.time}
            </div>
          </div>
        </div>
      )
    } else if (item.action === "like") {
      return (
        <div className="notification">
          <div className="information">
            <a href={item.visitor_path}>{item.visitor}</a> が あなたの投稿をいいねしました。
            <div className="time">
              {item.time}
            </div>
          </div>
          <Micropost
            user_image={item.user_image}
            user_name={item.user_name}
            user_path={item.user_path}
            group_name={item.group_name}
            group_path={item.group_path}
            content={item.content}
            time={item.time}
            history={item.history}
            encouragement={item.encouragement}
            like_path={item.like_path}
            like={item.like}
            like_count={item.like_count}
            token={this.props.token} />
        </div>
      )
    } else if (item.action === "message") {
      return (
        <div className="notification">
          <div className="information">
            <a href={item.visitor_path}>{item.visitor}</a> が
          あなたに <a href={item.message_path}>メッセージ</a> を送りました。<br />
            <div className="time">
              {item.time}
            </div>
          </div>
        </div>
      )
    }
  }

  render() {
    return (
      <React.Fragment>
        <Modal
          isOpen={this.props.modalIsOpen}
          onAfterOpen={this.afterOpenModal}
          onRequestClose={this.closeModal}
          style={customStyles}
          contentLabel="Notification Modal" >
          <span ref={close => this.close = close} onClick={this.closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
          <h3>お知らせ一覧</h3>
          {this.state.information.map((item) =>
            <React.Fragment>
              {this.getNotification(item)}
            </React.Fragment>)
          }
        </Modal>
      </React.Fragment>
    );
  }
}

Notification.proptypes = {
  path: PropTypes.string,
  token: PropTypes.string,
  modalIsOpen: PropTypes.bool,
  closeModal: PropTypes.func,
  setCount: PropTypes.func
};

export default Notification