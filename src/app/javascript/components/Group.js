import React, { useState } from "react"
import PropTypes from "prop-types"
import Achievement from "./Achievement"

function Group(props) {
  const [belong, setBelong] = useState(props.belong)
  const [achieved, setAchieved] = useState(props.achieved)
  const [memberCount, setMenberCount] = useState(props.member_count)

  return (
    <React.Fragment>
      <div className="item">
        {belong ?
          <span className="alert alert-info">
            このコミュニティに参加しています
            </span> : null}
        <div className="item-info row">
          <div className="user-image col-sm-2">
            <img src={props.group_image} />
          </div>
          <div className="col-sm-7">
            <div className="list">
              <a href={props.group_path}><li><h3>{props.group_name}</h3></li></a>
              <li>オーナー：<a href={props.owner_path}>{props.owner_name}</a></li>
              <li>メンバー：<a href={props.member_path}>{memberCount}人が参加</a></li>
              <li>習慣：{props.group_habit}</li>
            </div>
          </div>
          <div className="achievement col-sm-3">
            {belong ?
              <React.Fragment>
                <h4>
                  {achieved ? <a className="alert alert-success">達成</a> : <a className="alert alert-danger">未達</a>}
                </h4>
                <Achievement
                  path={props.achievement_path}
                  achieved={achieved}
                  token={props.token}
                  setAchieved={setAchieved} />
              </React.Fragment> :
              null}
          </div>
        </div>
      </div>
    </React.Fragment>
  );
}

Group.PropTypes = {
  group_image: PropTypes.string,
  group_name: PropTypes.string,
  group_path: PropTypes.string,
  group_habit: PropTypes.string,
  achievement_path: PropTypes.string,
  owner_name: PropTypes.string,
  owner_path: PropTypes.string,
  member_path: PropTypes.string,
  member_count: PropTypes.number,
  belong: PropTypes.bool,
  achieved: PropTypes.bool,
  token: PropTypes.string
};

export default Group
