import React, { useState } from "react"
import propTypes from "prop-types"
import Follow from "./Follow"
import AchieveCalendar from "./AchieveCalendar"

function UserIntroduction(props) {
  const [follow, setFollow] = useState(props.follow)
  const [activeFollowingCount, setActiveFollowingCount] = useState(props.active_following_count)
  const [activeFollowersCount, setActiveFollowersCount] = useState(props.active_followers_count)
  const [passiveFollowingCount, setPassiveFollowingCount] = useState(props.passive_following_count)
  const [passiveFollowersCount, setPassiveFollowersCount] = useState(props.passive_followers_count)

  function setFollowCount(activeFollowingCount, activeFollowersCount, passiveFollowingCount, passiveFollowersCount) {
    setActiveFollowingCount(activeFollowingCount)
    setActiveFollowersCount(activeFollowersCount)
    setPassiveFollowingCount(passiveFollowingCount)
    setPassiveFollowersCount(passiveFollowersCount)
  }

  return (
    <React.Fragment>
      <div className="describe">
        <div className="head">
          {follow ?
            <span className="alert alert-info">
              このユーザをフォローしています
              </span> : null}
          <div className="menu row">
            <div className="user-image col-sm-3">
              <img src={props.user_image} />
            </div>
            <div className="col-sm-4">
              <div className="list">
                <li><h3>{props.user_name}</h3></li>
                <li>フォロー：<a href={props.following_path}>{passiveFollowingCount}人</a></li>
                <li>フォロワー：<a href={props.followers_path}>{passiveFollowersCount}人</a></li>
                <li><span className="glyphicon glyphicon-heart" aria-hidden="true"></span>&nbsp;<a href={props.like_feeds_path}>いいねした投稿</a></li>
                <li><span className="glyphicon glyphicon-tower" aria-hidden="true"></span>&nbsp;<a href={props.owning_path}>主催コミュニティ</a></li>
                <li><span className="glyphicon glyphicon-globe" aria-hidden="true"></span>&nbsp;<a href={props.belonging_path}>参加コミュニティ</a></li><br />
              </div>
              <div className="follow">
                <Follow
                  path={props.relationship_path}
                  follow={follow}
                  token={props.token}
                  setFollow={setFollow}
                  setFollowCount={setFollowCount} /><br />
                <a href={props.message_path}><button className="send-message btn btn-default">メッセージを送る</button></a>
              </div>
              {props.admin ?
                <React.Fragment>
                  <li><span class="glyphicon glyphicon-edit" aria-hidden="true"></span>&nbsp;<a href={props.edit_user_path}>編集する</a></li>
                  <li><span class="glyphicon glyphicon-picture" aria-hidden="true"></span>&nbsp;<a href={props.edit_image_user_path}>画像変更する</a></li>
                  <li><span class="glyphicon glyphicon-remove" aria-hidden="true"></span>&nbsp;<a href={props.delete_user_path}>削除する</a></li>
                </React.Fragment> : null}
            </div>
            <div className="col-sm-5 calendar">
              <AchieveCalendar
                history={props.history}
                token={props.token} />
            </div>
          </div>
        </div>
        <div className="body">
          <h3>自己紹介</h3>
          <p>{props.user_introduction}</p>
        </div>
      </div>
    </React.Fragment >
  );
}

UserIntroduction.propTypes = {
  relationship_path: propTypes.string,
  follow: propTypes.bool,
  active_following_count: propTypes.number,
  active_followers_count: propTypes.number,
  passive_following_count: propTypes.number,
  passive_followers_count: propTypes.number,
  user_image: propTypes.string,
  user_name: propTypes.string,
  following_path: propTypes.string,
  followers_path: propTypes.string,
  owning_path: propTypes.string,
  belonging_path: propTypes.string,
  user_introduction: propTypes.string,
  token: propTypes.string,
  message_path: propTypes.string,
  admin: propTypes.bool,
  edit_image_user_path: propTypes.string,
  edit_user_path: propTypes.string,
  delete_user_path: propTypes.string,
  like_feeds_path: propTypes.string
};

export default UserIntroduction
