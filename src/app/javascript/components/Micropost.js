import React from "react"
import PropTypes from "prop-types"
import Like from "./Like"

function Micropost(props) {

  function getClass() {
    if (props.encouragement) {
      return "micropost encouragement-micropost";
    } else {
      return "micropost";
    }
  }

  return (
    <React.Fragment>
      <div className={getClass()}>
        <div className="micropost-user">
          <img src={props.user_image} />
          <div>
            {props.encouragement ?
              <React.Fragment>
                <h4>
                  <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                    &nbsp;&nbsp;<a href={props.group_path}>{props.group_name}</a>
                    &nbsp;の&nbsp;<a href={props.user_path}>{props.user_name}</a>
                    &nbsp;さんが煽っています
                    &nbsp;&nbsp;<span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                </h4>
              </React.Fragment> :
              <a href={props.user_path}><li><h4>{props.user_name}</h4></li></a>}
            <div className="micropost-time">
              <p>{props.time}</p>
              <Like
                path={props.like_path}
                like={props.like}
                like_count={props.like_count}
                token={props.token} />
            </div>
          </div>
          {props.poster ?
            <a className="remove" rel="nofollow" data-method="delete" href={props.micropost_path}>
              <span className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            </a> : null}
        </div>
        <div className="micropost-content">
          {props.history && !props.encouragement ?
            <p dangerouslySetInnerHTML={{ __html: props.content }} /> :
            <p>{props.content}</p>}
        </div>
      </div >
    </React.Fragment >
  );
}

Micropost.proptypes = {
  user_image: PropTypes.string,
  user_path: PropTypes.string,
  user_name: PropTypes.string,
  group_path: PropTypes.string,
  group_name: PropTypes.string,
  content: PropTypes.string,
  time: PropTypes.string,
  like_path: PropTypes.string,
  like: PropTypes.bool,
  like_count: PropTypes.number,
  token: PropTypes.string,
  poster: PropTypes.bool,
  micropost_path: PropTypes.string
};

export default Micropost
