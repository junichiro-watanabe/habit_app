import React from "react"
import PropTypes from "prop-types"
class Header extends React.Component {
  render() {
    return (
      <React.Fragment>
        <header className="navbar navbar-inverse">
          <div className="container">
            <a href="/">
              <h2>Habit App</h2>
            </a>
            <nav>
              <ul className="nav nav-pills navbar-right">
                <li><a href="/">ホーム</a></li>
                <li><a href="#">ログイン</a></li>
                <li className="active"><a href="/signup">新規登録</a></li>
              </ul>
            </nav>
          </div>
        </header>
      </React.Fragment>
    );
  }
}

export default Header
