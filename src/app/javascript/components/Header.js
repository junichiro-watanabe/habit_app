import React, { useState } from "react"
import propTypes from "prop-types"
import Modal from 'react-modal'
import Login from './Login'
import Notification from './Notification'

function Header(props) {
  const [modalIsOpen, setModalIsOpen] = useState(false)
  const [count, setCount] = useState(props.notification.count)

  function openModal() {
    setModalIsOpen(true)
  }

  function closeModal() {
    setModalIsOpen(false)
  }

  return (
    <React.Fragment>
      <header className="navbar navbar-fixed-top navbar-inverse">
        <div className="container">
          <nav>
            <div className="container-fluid">
              <div className="navbar-header">
                <a href={props.root_path}>
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
                  {props.logged_in ?
                    <React.Fragment>
                      <li><a href={props.user_path}><span className="glyphicon glyphicon-home" aria-hidden="true"></span> ホーム</a></li>
                      <li className="dropdown">
                        <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button">
                          <span className="glyphicon glyphicon-tower" aria-hidden="true"></span> コミュニティ<span className="caret"></span>
                        </a>
                        <ul className="dropdown-menu" role="menu">
                          <li><a href={props.users_path}><span className="glyphicon glyphicon-glass" aria-hidden="true"></span> 仲間を探す</a></li>
                          <li><a href={props.create_group_path}><span className="glyphicon glyphicon-flag" aria-hidden="true"></span> コミュニティを作る</a></li>
                          <li><a href={props.groups_path}><span className="glyphicon glyphicon-search" aria-hidden="true"></span> コミュニティを探す</a></li>
                          <li><a href={props.owning_path}><span className="glyphicon glyphicon-tower" aria-hidden="true"></span> 主催コミュニティ</a></li>
                          <li><a href={props.belonging_path}><span className="glyphicon glyphicon-globe" aria-hidden="true"></span> 参加コミュニティ</a></li>
                        </ul>
                      </li>
                      <li className="bell"><a onClick={openModal}><span className="glyphicon glyphicon-bell" aria-hidden="true"></span> <span>{count}</span></a></li>
                      <li className="dropdown user">
                        <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button">
                          <img src={props.user_image} height="30px" width="30px" /><span className="caret"></span>
                        </a>
                        <ul className="dropdown-menu" role="menu">
                          <li><a href={props.edit_user_path}><span className="glyphicon glyphicon-user" aria-hidden="true"></span> プロフィール</a></li>
                          <li><a rel="nofollow" data-method="delete" href="/login"><span className="glyphicon glyphicon-log-out" aria-hidden="true"></span> ログアウト</a></li>
                        </ul>
                      </li>
                      <Notification
                        modalIsOpen={modalIsOpen}
                        closeModal={closeModal}
                        setCount={setCount}
                        notification={props.notification}
                        path={props.notification_path}
                        token={props.token} />
                    </React.Fragment> :
                    <React.Fragment>
                      <li><a href="/"><span className="glyphicon glyphicon-home" aria-hidden="true"></span> ホーム</a></li>
                      <li><a onClick={openModal}><span className="glyphicon glyphicon-log-in" aria-hidden="true"></span> ログイン</a></li>
                      <li className="active"><a href="/signup"><span className="glyphicon glyphicon-plus" aria-hidden="true"></span> 新規登録</a></li>
                      <Login
                        modalIsOpen={modalIsOpen}
                        closeModal={closeModal}
                        token={props.token} />
                    </React.Fragment>}
                </ul>
              </div>
            </div>
          </nav>
        </div>
      </header>
    </React.Fragment>
  );
}

Header.propTypes = {
  logged_in: propTypes.bool,
  root_path: propTypes.string,
  user_name: propTypes.string,
  user_image: propTypes.string,
  user_path: propTypes.string,
  edit_user_path: propTypes.string,
  users_path: propTypes.string,
  groups_path: propTypes.string,
  owning_path: propTypes.string,
  belonging_path: propTypes.string,
  create_group_path: propTypes.string,
  notification_path: propTypes.string,
  token: propTypes.string
};

export default Header
