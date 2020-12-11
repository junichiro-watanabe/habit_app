import React from "react"
import propTypes from "prop-types"

function Follow(props) {

  function follow() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        props.setFollow(json.follow)
        props.setFollowCount(
          json.active_following_count,
          json.active_followers_count,
          json.passive_following_count,
          json.passive_followers_count)
      }
    )
  }

  function unfollow() {
    fetch(props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        props.setFollow(json.follow)
        props.setFollowCount(
          json.active_following_count,
          json.active_followers_count,
          json.passive_following_count,
          json.passive_followers_count)
      }
    )
  }

  function getClass() {
    if (props.follow) {
      return "btn btn-warning";
    } else {
      return "btn btn-default";
    }
  }

  return (
    <React.Fragment>
      <button className={getClass()} onClick={props.follow ? unfollow : follow}>
        {props.follow ? "フォローを外す" : "フォローする"}
      </button>
    </React.Fragment>
  );
}

Follow.propTypes = {
  path: propTypes.string,
  follow: propTypes.bool,
  active_following_count: propTypes.number,
  active_followers_count: propTypes.number,
  passive_following_count: propTypes.number,
  passive_followers_count: propTypes.number,
  token: propTypes.string,
  setFollow: propTypes.func,
  setFollowCount: propTypes.func
};

export default Follow
