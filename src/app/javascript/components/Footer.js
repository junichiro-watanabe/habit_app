import React from "react"
import PropTypes from "prop-types"
import Contact from "./Contact"

class Footer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      modalIsOpen: false
    }
  }

  openModal = () => {
    this.setState({ modalIsOpen: open });
  }

  closeModal = () => {
    this.setState({ modalIsOpen: false });
  }

  render() {
    return (
      <React.Fragment>
        <footer className="footer">
          <div className="container">
            <a href="/">
              <img src="/assets/logo2.png" height="40px" />
            </a>
            <nav>
              <ul>
                <li><a id="contact" onClick={this.openModal}>お問い合わせ</a></li>
              </ul>
            </nav>
          </div>
          <Contact
            modalIsOpen={this.state.modalIsOpen}
            closeModal={this.closeModal}
            token={this.props.token} />
        </footer>
      </React.Fragment>
    );
  }
}

Footer.PropTypes = {
  token: PropTypes.string
};

export default Footer
