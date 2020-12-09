import React, { useState } from "react"
import propTypes from "prop-types"
import Follow from "./Follow"

function User(props) {
  const [follow, setFollow] = useState(props.follow)

  return (
    <React.Fragment>
      <div className="item">
        {follow ?
          <span className="alert alert-info">
            このユーザをフォローしています
            </span> : null}
        <div className="item-info row">
          <div className="user-image col-sm-2">
            <img src={props.user_image} />
          </div>
          <div className="col-sm-offset-1 col-sm-6">
            <a href={props.user_path}><li><h3>{props.user_name}</h3></li></a>
            <div className="list">
              <li>{props.user_introduction}</li>
            </div>
          </div>
          <div className="col-sm-3 follow">
            {props.current_user ? "" :
              <Follow
                path={props.relationship_path}
                follow={follow}
                token={props.token}
                setFollow={setFollow} />}
          </div>
        </div>
      </div>
    </React.Fragment >
  );
}

User.propTypes = {
  user_image: propTypes.string,
  user_path: propTypes.string,
  user_name: propTypes.string,
  user_introduction: propTypes.string,
  relationship_path: propTypes.string,
  follow: propTypes.bool,
  current_user: propTypes.bool,
  token: propTypes.string
};

export default User
