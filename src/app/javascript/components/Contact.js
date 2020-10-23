import React from "react"
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

class Contact extends React.Component {
  constructor(props) {
    super(props);
  }

  afterOpenModal = () => {
    this.close.style.float = 'right';
    this.close.style.fontSize = '30px';
    this.close.style.cursor = 'pointer';
    this.close.style.marginTop = '5px';
    this.submit.style.margin = '10px 0px 20px 0px';
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
          contentLabel="Contact Modal"
        >
          <form action="/contacts" accept-charset="UTF-8" method="post">
            <input type="hidden" name="authenticity_token" value={this.props.token} />
            <span ref={close => this.close = close} onClick={this.props.closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            <div>
              <h2>お問い合わせ</h2>

              <span className="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;
              <label for="contact_name">お名前</label>
              <input className="form-controll" type="text" name="contact[name]" id="contact_name" />

              <span className="glyphicon glyphicon-envelope" aria-hidden="true"></span>&nbsp;
              <label for="contact_email">メールアドレス</label>
              <input className="form-controll" type="email" name="contact[email]" id="contact_email" />

              <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>&nbsp;
              <label for="session_subject">件名</label>
              <input className="form-controll" type="text" name="contact[subject]" id="contact_subject" />

              <span className="glyphicon glyphicon-list-alt" aria-hidden="true"></span>&nbsp;
              <label for="session_subject">お問い合わせ内容</label>
              <textarea className="form-controll" name="contact[text]" id="contact_text" />
            </div>

            <div className="col-xs-6 col-xs-offset-3 submit">
              <input ref={submit => this.submit = submit} type="submit" name="commit" value="送信" className="btn btn-primary" data-disable-with="ログイン" />
            </div>
          </form>
        </Modal>
      </React.Fragment>
    );
  }
}

Contact.PropTypes = {
  token: PropTypes.string,
  modalIsOpen: PropTypes.bool,
  closeModal: PropTypes.func
};

export default Contact