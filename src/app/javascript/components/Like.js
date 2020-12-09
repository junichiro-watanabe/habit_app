import React, { useState } from "react"
import PropTypes from "prop-types"

function Like(props) {
  const [liked, setLiked] = useState(props.like)
  const [likeCount, setLikeCount] = useState(props.like_count)

  function like() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setLiked(json.like)
        setLikeCount(json.like_count)
      }
    )
  }

  function unLike() {
    fetch(props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setLiked(json.like)
        setLikeCount(json.like_count)
      }
    )
  }

  function getClass(liked) {
    if (liked) {
      return "like";
    } else {
      return "unlike";
    }
  }

  return (
    <React.Fragment>
      <a className={getClass(liked)} onClick={liked ? unLike : like} >
        <span className="glyphicon glyphicon-heart" aria-hidden="true"></span>
      </a>&nbsp;
      <a href={props.path}>{likeCount}</a>
    </React.Fragment>
  );
}

Like.PropTypes = {
  path: PropTypes.string,
  like: PropTypes.bool,
  like_count: PropTypes.number,
  token: PropTypes.string
}

export default Like
