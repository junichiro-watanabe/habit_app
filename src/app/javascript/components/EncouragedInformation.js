import React from "react";
import PropTypes from "prop-types";
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
    background: 'white'
  }
};

class EncouragedInformation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      encouraged: this.props.encouraged,
      modalIsOpen: false
    }
  }

  afterOpenModal = () => {
    this.close.style.float = 'right';
    this.close.style.fontSize = '30px';
    this.close.style.cursor = 'pointer';
  }

  openModal = () => {
    this.setState({ modalIsOpen: true });
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
          encouraged: json
        })
      }
    )
    this.setState({ modalIsOpen: false });
  }

  render() {
    return (
      <React.Fragment>
        <div class="timeline-information">
          {this.state.encouraged.length == 0 ?
            <React.Fragment>
              <div class="alert alert-success">
                <h3>煽っているユーザはいません</h3>
                <h4>先に目標を達成しましょう！</h4>
              </div>
            </React.Fragment> :
            <React.Fragment>
              <div class="alert alert-warning">
                <h3>
                  <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                  &nbsp;&nbsp;<b><a id="encouraged" onClick={this.openModal}>{this.state.encouraged.length}</a></b> 回煽られています
                  &nbsp;&nbsp;<span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                </h3>
                <h4>仲間に負けずに頑張りましょう！</h4>
              </div>
            </React.Fragment>}
          <Modal
            isOpen={this.state.modalIsOpen}
            onAfterOpen={this.afterOpenModal}
            onRequestClose={this.closeModal}
            style={customStyles}
            contentLabel="Encouraged Modal" >
            <span ref={close => this.close = close} onClick={this.closeModal} class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            <h3>仲間の投稿を見て頑張りましょう！</h3>
            {this.state.encouraged.map((item) =>
              <React.Fragment>
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
              </React.Fragment>
            )}
          </Modal>
        </div>
      </React.Fragment>
    );
  }
}

EncouragedInformation.PropTypes = {
  path: PropTypes.string,
  token: PropTypes.string
};

export default EncouragedInformation
