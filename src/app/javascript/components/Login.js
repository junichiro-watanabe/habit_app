import React, { useState, useEffect } from "react"
import PropTypes from "prop-types"
import Modal from 'react-modal'

const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: '-30%',
    bottom: '-40%',
    transform: 'translate(-50%, -50%)',
    overflow: 'auto',
    WebkitOverflowScrolling: 'touch',
    background: 'white',
    border: "1px solid #bbb"
  }
};

class Login extends React.Component {
  constructor(props) {
    super(props);
  }

  afterOpenModal = () => {
    this.close.style.float = 'right';
    this.close.style.fontSize = '30px';
    this.close.style.cursor = 'pointer';
    this.close.style.marginTop = '5px';
    this.submit.style.marginTop = '10px';
    this.guest.style.margin = '10px 0px 20px 0px';
  }

  render() {
    return (
      <React.Fragment>
        <Modal
          isOpen={this.props.modalIsOpen}
          onAfterOpen={this.afterOpenModal}
          onRequestClose={this.props.closeModal}
          style={customStyles}
          className="col-sm-4"
          contentLabel="Login Modal"
        >
          <div className="form">
            <form action="/login" accept-charset="UTF-8" method="post">
              <input type="hidden" name="authenticity_token" value={this.props.token} />
              <span ref={close => this.close = close} onClick={this.props.closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
              <div>
                <h2>ログイン</h2>

                <span className="glyphicon glyphicon-envelope" aria-hidden="true"></span>&nbsp;
              <label for="session_email">メールアドレス</label>
                <input className="form-controll" type="email" name="session[email]" id="session_email" />

                <span className="glyphicon glyphicon-eye-close" aria-hidden="true"></span>&nbsp;
              <label for="session_password">パスワード</label>
                <input className="form-controll" type="password" name="session[password]" id="session_password" />
              </div>

              <div className="col-sm-8 col-sm-offset-2 submit">
                <input ref={submit => this.submit = submit} type="submit" name="commit" value="ログイン" className="btn btn-primary" data-disable-with="ログイン" />
                <a href="/login_guest">
                  <button ref={guest => this.guest = guest} className="btn btn-secondaly">ゲストユーザとしてログイン</button>
                </a>
              </div>
            </form>
          </div>
        </Modal>
      </React.Fragment>
    );
  }
}

Login.PropTypes = {
  path: PropTypes.string,
  token: PropTypes.string,
  modalIsOpen: PropTypes.bool,
  closeModal: PropTypes.func
};

export default Login
