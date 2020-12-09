import React, { useState } from "react"
import propTypes from "prop-types"
import Contact from "./Contact"

function Footer(props) {
  const [modalIsOpen, setModalIsOpen] = useState(false)

  function openModal() {
    setModalIsOpen(true);
  }

  function closeModal() {
    setModalIsOpen(false);
  }

  return (
    <React.Fragment>
      <footer className="footer">
        <div className="container">
          <a href="/">
            <img src="/assets/logo2.png" height="40px" />
          </a>
          <nav>
            <ul>
              <li><a id="contact" onClick={openModal}>お問い合わせ</a></li>
            </ul>
          </nav>
        </div>
        <Contact
          modalIsOpen={modalIsOpen}
          closeModal={closeModal}
          token={props.token} />
      </footer>
    </React.Fragment>
  );
}

Footer.propTypes = {
  token: propTypes.string
};

export default Footer
