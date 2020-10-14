import React from "react"
import PropTypes from "prop-types"
import * as Scroll from 'react-scroll';
import { Link, Element, Events, animateScroll as scroll, scrollSpy, scroller } from 'react-scroll'
class Message extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      path: this.props.path,
      value: "",
      message: this.props.message
    }
  }

  componentDidMount() {
    this.scrollToBottom();
  }

  handleChange = (event) => {
    this.setState({ value: event.target.value });
  }

  handleSubmit = (event) => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "content": this.state.value, "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          message: json,
          value: ""
        })
        this.scrollToBottom();
      }
    )
    event.preventDefault();
  }

  scrollToBottom = () => {
    scroll.scrollToBottom({ containerId: "message-history", duration: 0 });
  }

  render() {
    return (
      <React.Fragment>

        <div className="message-history" id="message-history">
          {this.state.message.map((item, index) =>
            item.myself ?
              <React.Fragment>
                <div className="myself" key={index}>
                  <div className="myself-message">
                    <div className="user-info">
                      <a href={this.props.my_path}><li><p>{this.props.my_name}</p></li></a>
                      <p className="time">{item.time}</p>
                    </div>
                    <p>{item.content}</p>
                  </div>
                  <a href={this.props.my_path}><img src={this.props.my_image} /></a>
                </div>
              </React.Fragment> :
              <React.Fragment>
                <div className="yourself" key={index}>
                  <a href={this.props.your_path}><img src={this.props.your_image} /></a>
                  <div className="yourself-message">
                    <div className="user-info">
                      <a href={this.props.your_path}><li><p>{this.props.your_name}</p></li></a>
                      <p className="time">{item.time}</p>
                    </div>
                    <p>{item.content}</p>
                  </div>
                </div>
              </React.Fragment>

          )}
        </div>

        <form className="message-form" onSubmit={this.handleSubmit}>
          <div className="form-group">
            <textarea className="form-control" value={this.state.value} onChange={this.handleChange}></textarea>
          </div>
          <button type="submit" className="btn btn-warning" onClick={this.scrollToBottom}>送る</button>
        </form>
      </React.Fragment >
    );
  }
}

Message.propTypes = {
  path: PropTypes.string,
  token: PropTypes.string,
  my_name: PropTypes.string,
  your_name: PropTypes.string,
  my_path: PropTypes.string,
  your_path: PropTypes.string,
  my_image: PropTypes.string,
  your_image: PropTypes.string
}

export default Message
