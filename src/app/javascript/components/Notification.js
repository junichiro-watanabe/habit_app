import React, { useState } from "react"
import propTypes from "prop-types"
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

function Notification(props) {
  const [information, setInformation] = useState(props.notification.information)

  function closeModal() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setInformation(json.information)
        props.setCount(json.count)
        props.closeModal()
      }
    )
  }

  function getNotification(item) {
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
            token={props.token} />
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

  return (
    <React.Fragment>
      <Modal
        isOpen={props.modalIsOpen}
        onRequestClose={closeModal}
        style={customStyles}
        contentLabel="Notification Modal" >
        <span onClick={closeModal} id="remove-notification" className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
        <h3>お知らせ一覧</h3>
        {information.map((item, index) =>
          <React.Fragment key={index}>
            {getNotification(item, index)}
          </React.Fragment>)
        }
      </Modal>
    </React.Fragment>
  );
}

Notification.propTypes = {
  path: propTypes.string,
  token: propTypes.string,
  modalIsOpen: propTypes.bool,
  closeModal: propTypes.func,
  setCount: propTypes.func
};

export default Notification
