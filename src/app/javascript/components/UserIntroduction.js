import React from "react"
import PropTypes from "prop-types"
import Follow from "./Follow"
import AchieveCalendar from "./AchieveCalendar"
class UserIntroduction extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      follow: this.props.follow,
      activeFollowingCount: this.props.active_following_count,
      activeFollowersCount: this.props.active_followers_count,
      passiveFollowingCount: this.props.passive_following_count,
      passiveFollowersCount: this.props.passive_followers_count
    }
  }

  setFollow = (follow) => {
    this.setState({ follow: follow })
  }

  setFollowCount = (activeFollowingCount, activeFollowersCount, passiveFollowingCount, passiveFollowersCount) => {
    this.setState({
      activeFollowingCount: activeFollowingCount,
      activeFollowersCount: activeFollowersCount,
      passiveFollowingCount: passiveFollowingCount,
      passiveFollowersCount: passiveFollowersCount
    })
  }

  render() {
    return (
      <React.Fragment>
        <div className="describe">
          <div className="head">
            {this.state.follow ?
              <span className="alert alert-info">
                このユーザをフォローしています
              </span> : null}
            <div className="menu row">
              <div className="user-image col-sm-3">
                <img src={this.props.user_image} />
              </div>
              <div className="col-sm-4">
                <div className="list">
                  <li><h3>{this.props.user_name}</h3></li>
                  <li>フォロー：<a href={this.props.following_path}>{this.state.passiveFollowingCount}人</a></li>
                  <li>フォロワー：<a href={this.props.followers_path}>{this.state.passiveFollowersCount}人</a></li>
                  <li><a href={this.props.owning_path}>主催コミュニティ</a></li>
                  <li><a href={this.props.belonging_path}>参加コミュニティ</a></li><br />
                </div>
                <div className="follow">
                  <Follow
                    path={this.props.relationship_path}
                    follow={this.state.follow}
                    token={this.props.token}
                    setFollow={this.setFollow}
                    setFollowCount={this.setFollowCount} /><br />
                  <a href={this.props.message_path}><button className="send-message btn btn-default">メッセージを送る</button></a>
                </div>
              </div>
              <div className="col-sm-5 calendar">
                <AchieveCalendar
                  history={this.props.history}
                  token={this.props.token} />
              </div>
            </div>
          </div>
          <div className="body">
            <h3>自己紹介</h3>
            <p>{this.props.user_introduction}</p>
          </div>
        </div>
      </React.Fragment >
    );
  }
}

UserIntroduction.propTypes = {
  relationship_path: PropTypes.string,
  follow: PropTypes.bool,
  active_following_count: PropTypes.number,
  active_followers_count: PropTypes.number,
  passive_following_count: PropTypes.number,
  passive_followers_count: PropTypes.number,
  user_image: PropTypes.string,
  user_name: PropTypes.string,
  following_path: PropTypes.string,
  followers_path: PropTypes.string,
  owning_path: PropTypes.string,
  belonging_path: PropTypes.string,
  user_introduction: PropTypes.string,
  token: PropTypes.string,
  message_path: PropTypes.string
};

export default UserIntroduction
