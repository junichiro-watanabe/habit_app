import React from "react"
import PropTypes from "prop-types"
class Follow extends React.Component {
  constructor(props) {
    super(props)
  }

  follow = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.props.setFollow(json.follow)
        this.props.setFollowCount(
          json.active_following_count,
          json.active_followers_count,
          json.passive_following_count,
          json.passive_followers_count)
      }
    )
  }

  unfollow = () => {
    fetch(this.props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.props.setFollow(json.follow)
        this.props.setFollowCount(
          json.active_following_count,
          json.active_followers_count,
          json.passive_following_count,
          json.passive_followers_count)
      }
    )
  }

  getClass() {
    if (this.props.follow) {
      return "btn btn-warning";
    } else {
      return "btn btn-default";
    }
  }

  render() {
    return (
      <React.Fragment>
        <button className={this.getClass()} onClick={this.props.follow ? this.unfollow : this.follow}>
          {this.props.follow ? "フォローを外す" : "フォローする"}
        </button>
      </React.Fragment>
    );
  }
}

Follow.propTypes = {
  path: PropTypes.string,
  follow: PropTypes.bool,
  active_following_count: PropTypes.number,
  active_followers_count: PropTypes.number,
  passive_following_count: PropTypes.number,
  passive_followers_count: PropTypes.number,
  token: PropTypes.string,
  setFollow: PropTypes.func,
  setFollowCount: PropTypes.func
};

export default Follow
