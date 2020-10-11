import React from "react"
import PropTypes from "prop-types"
class Follow extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      follow: this.props.follow
    }
  }

  follow = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          follow: true
        })
        this.props.setFollow(this.state.follow)
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
      headers: new Headers({ "Content-type": "application/json" })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          follow: false
        })
        this.props.setFollow(this.state.follow)
        this.props.setFollowCount(
          json.active_following_count,
          json.active_followers_count,
          json.passive_following_count,
          json.passive_followers_count)
      }
    )
  }

  getClass() {
    if (this.state.follow) {
      return "btn btn-warning"
    } else {
      return "btn btn-default"
    }
  }

  render() {
    return (
      <React.Fragment>
        <button id={"follow_" + this.props.id} className={this.getClass()} onClick={this.state.follow ? this.unfollow : this.follow}>
          {this.state.follow ? "フォローを外す" : "フォローする"}
        </button>
      </React.Fragment>
    );
  }
}

Follow.propTypes = {
  id: PropTypes.number,
  path: PropTypes.string,
  follow: PropTypes.bool,
  active_following_count: PropTypes.number,
  active_followers_count: PropTypes.number,
  passive_following_count: PropTypes.number,
  passive_followers_count: PropTypes.number,
};

export default Follow
