import React from "react"
import propTypes from "prop-types"
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

function Login(props) {

  return (
    <React.Fragment>
      <Modal
        isOpen={props.modalIsOpen}
        onRequestClose={props.closeModal}
        style={customStyles}
        className="col-md-4"
        contentLabel="Login Modal"
      >
        <div className="form">
          <form action="/login" accept-charset="UTF-8" method="post">
            <input type="hidden" name="authenticity_token" value={props.token} />
            <span ref={close => close = close} onClick={props.closeModal} id="remove-login" className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            <div>
              <h2>ログイン</h2>

              <span className="glyphicon glyphicon-envelope" aria-hidden="true"></span>&nbsp;
              <label for="session_email">メールアドレス</label>
              <input className="form-controll" type="email" name="session[email]" id="session_email" />

              <span className="glyphicon glyphicon-eye-close" aria-hidden="true"></span>&nbsp;
              <label for="session_password">パスワード</label>
              <input className="form-controll" type="password" name="session[password]" id="session_password" />
            </div>

            <div className="col-md-8 col-md-offset-2 submit">
              <input type="submit" name="commit" value="ログイン" className="btn btn-primary" data-disable-with="ログイン" />
              <a href="/login_guest">
                <button className="btn btn-secondaly">ゲストユーザでログイン</button>
              </a>
            </div>
          </form>
        </div>
      </Modal>
    </React.Fragment>
  );
}

Login.propTypes = {
  path: propTypes.string,
  token: propTypes.string,
  modalIsOpen: propTypes.bool,
  closeModal: propTypes.func
};

export default Login
