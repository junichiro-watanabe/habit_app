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
            <nav>
              <div className="container-fluid">
                <div className="navbar-header">
                  <a href={this.props.root_path}>
                    <img src="/assets/logo.png" height="40px" />
                  </a>
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
                        <li><a href={this.props.user_path}><span className="glyphicon glyphicon-home" aria-hidden="true"></span> ホーム</a></li>
                        <li className="dropdown">
                          <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button">
                            <span className="glyphicon glyphicon-tower" aria-hidden="true"></span> コミュニティ<span className="caret"></span>
                          </a>
                          <ul className="dropdown-menu" role="menu">
                            <li><a href={this.props.users_path}><span className="glyphicon glyphicon-glass" aria-hidden="true"></span> 仲間を探す</a></li>
                            <li><a href={this.props.create_group_path}><span className="glyphicon glyphicon-flag" aria-hidden="true"></span> コミュニティを作る</a></li>
                            <li><a href={this.props.groups_path}><span className="glyphicon glyphicon-search" aria-hidden="true"></span> コミュニティを探す</a></li>
                            <li><a href={this.props.owning_path}><span className="glyphicon glyphicon-tower" aria-hidden="true"></span> 主催コミュニティ</a></li>
                            <li><a href={this.props.belonging_path}><span className="glyphicon glyphicon-globe" aria-hidden="true"></span> 参加コミュニティ</a></li>
                          </ul>
                        </li>
                        <li className="dropdown user">
                          <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button">
                            <img src={this.props.user_image} height="30px" width="30px" />
                            <span className="name">{this.props.user_name}</span><span className="caret"></span>
                          </a>
                          <ul className="dropdown-menu" role="menu">
                            <li><a href={this.props.edit_user_path}><span className="glyphicon glyphicon-user" aria-hidden="true"></span> プロフィール</a></li>
                            <li><a rel="nofollow" data-method="delete" href="/login"><span className="glyphicon glyphicon-log-out" aria-hidden="true"></span> ログアウト</a></li>
                          </ul>
                        </li>
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
  user_name: PropTypes.string,
  user_image: PropTypes.string,
  user_path: PropTypes.string,
  edit_user_path: PropTypes.string,
  users_path: PropTypes.string,
  groups_path: PropTypes.string,
  owning_path: PropTypes.string,
  belonging_path: PropTypes.string,
  create_group_path: PropTypes.string,
  token: PropTypes.string
};

export default Header
