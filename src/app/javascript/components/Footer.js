import React from "react"
import PropTypes from "prop-types"
class Footer extends React.Component {
  render() {
    return (
      <React.Fragment>
        <footer className="footer">
          <div className="container">
            <a href="/">
              <h2>
                Habit App
              </h2>
            </a>
            <nav>
              <ul>
                <li><a href="#">お問い合わせ</a></li>
              </ul>
            </nav>
          </div>
        </footer>
      </React.Fragment>
    );
  }
}

export default Footer
