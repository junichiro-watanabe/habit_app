import React from "react"
import PropTypes from "prop-types"
import Modal from 'react-modal'
import Login from './Login'
class Header extends React.Component {
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
        <header className="navbar navbar-fixed-top navbar-inverse">
          <div className="container">
            <a href={this.props.root_path}>
              <h2>Habit App</h2>
            </a>
            <nav>
              <div className="container-fluid">
                <div className="navbar-header">
                  <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-menu">
                    <span className="sr-only">Toggle navigation</span>
                    <span className="icon-bar"></span>
                    <span className="icon-bar"></span>
                    <span className="icon-bar"></span>
                  </button>
                </div>

                <div className="collapse navbar-collapse" id="header-menu">
                  <ul className="nav nav-pills navbar-right">
                    {this.props.logged_in ?
                      <React.Fragment>
                        <li><a href={this.props.user_path}><span class="glyphicon glyphicon-home" aria-hidden="true"></span> マイページ</a></li>
                        <li><a href={this.props.edit_user_path}><span className="glyphicon glyphicon-user" aria-hidden="true"></span> プロフィール</a></li>
                        <li><a href={this.props.groups_path}><span className="glyphicon glyphicon-tower" aria-hidden="true"></span> コミュニティ</a></li>
                        <li><a rel="nofollow" data-method="delete" href="/login"><span className="glyphicon glyphicon-log-out" aria-hidden="true"></span> ログアウト</a></li>
                      </React.Fragment> :
                      <React.Fragment>
                        <li><a href="/"><span className="glyphicon glyphicon-home" aria-hidden="true"></span> ホーム</a></li>
                        <li><a onClick={this.openModal}><span className="glyphicon glyphicon-log-in" aria-hidden="true"></span> ログイン</a></li>
                        <li className="active"><a href="/signup"><span className="glyphicon glyphicon-plus" aria-hidden="true"></span> 新規登録</a></li>
                      </React.Fragment>}
                  </ul>
                </div>
              </div>
            </nav>
          </div>
          <Login
            modalIsOpen={this.state.modalIsOpen}
            closeModal={this.closeModal}
            token={this.props.token} />
        </header>
      </React.Fragment>
    );
  }
}

Header.PropTypes = {
  logged_in: PropTypes.bool,
  root_path: PropTypes.string,
  user_path: PropTypes.string,
  edit_user_path: PropTypes.string,
  token: PropTypes.string
};

export default Header
