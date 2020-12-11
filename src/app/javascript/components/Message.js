import React, { useState } from "react"
import propTypes from "prop-types"
import { Link, Element, Events, animateScroll as scroll, scrollSpy, scroller } from 'react-scroll'

function Message(props) {
  const [value, setValue] = useState("")
  const [message, setMessage] = useState(props.message)

  function componentDidMount() {
    this.scrollToBottom();
  }

  function handleChange(event) {
    setValue(event.target.value)
  }

  function handleSubmit(event) {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "content": value, "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setMessage(json)
        setValue("")
        scrollToBottom();
      }
    )
    event.preventDefault();
  }

  function scrollToBottom() {
    scroll.scrollToBottom({ containerId: "message-history", duration: 0 });
  }

  return (
    <React.Fragment>
      <div className="message-history" id="message-history">
        {message.map((item, index) =>
          item.myself ?
            <React.Fragment key={index}>
              <div className="myself row">
                <div className="myself-message col-md-offset-4 col-md-6 col-xs-offset-1 col-xs-8">
                  <div className="user-info">
                    <a href={props.my_path}><li><p>{props.my_name}</p></li></a>
                    <p className="time">{item.time}</p>
                  </div>
                  <p>{item.content}</p>
                </div>
                <div className="user-image col-md-2 col-xs-3">
                  <a href={props.my_path}><img src={props.my_image} /></a>
                </div>
              </div>
            </React.Fragment> :
            <React.Fragment>
              <div className="yourself row" key={index}>
                <div className="user-image col-md-2 col-xs-3">
                  <a href={props.your_path}><img src={props.your_image} /></a>
                </div>
                <div className="yourself-message col-md-6 col-xs-8">
                  <div className="user-info">
                    <a href={props.your_path}><li><p>{props.your_name}</p></li></a>
                    <p className="time">{item.time}</p>
                  </div>
                  <p>{item.content}</p>
                </div>
              </div>
            </React.Fragment>
        )}
      </div>

      <form className="message-form" onSubmit={handleSubmit}>
        <div className="form-group">
          <textarea className="form-control" value={value} id="message" onChange={handleChange}></textarea>
        </div>
        <button type="submit" className="btn btn-warning" onClick={scrollToBottom}>送信</button>
      </form>
    </React.Fragment >
  );
}

Message.propTypes = {
  path: propTypes.string,
  token: propTypes.string,
  my_name: propTypes.string,
  your_name: propTypes.string,
  my_path: propTypes.string,
  your_path: propTypes.string,
  my_image: propTypes.string,
  your_image: propTypes.string
}

export default Message
