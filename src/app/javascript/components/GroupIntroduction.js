import React, { useState } from "react"
import propTypes from "prop-types"
import Belong from "./Belong"
import Achievement from "./Achievement"
import Encouragement from "./Encouragement"

function GroupIntroduction(props) {
  const [belong, setBelong] = useState(props.belong)
  const [achieved, setAchieved] = useState(props.achieved)
  const [memberCount, setMemberCount] = useState(props.member_count)

  return (
    <React.Fragment>
      <div className="describe">
        <div className="head">
          {belong ?
            <span className="alert alert-info">
              このコミュニティに参加しています
              </span> : null}
          <div className="menu row">
            <div className="user-image col-sm-3">
              <img src={props.group_image} />
            </div>
            <div className="col-sm-9 row">
              <div className="col-sm-8">
                <div className="list">
                  <li><h3>{props.group_name}</h3></li>
                  <li>オーナー：<a href={props.owner_path}>{props.owner_name}</a></li>
                  <li>メンバー：<a href={props.member_path}>{memberCount}人が参加</a></li><br />
                </div>
                <div className="belong">
                  <Belong
                    path={props.belong_path}
                    belong={belong}
                    memberCount={memberCount}
                    token={props.token}
                    setBelong={setBelong}
                    setMemberCount={setMemberCount}
                    setAchieved={setAchieved} />
                </div>
              </div>
              <div className="edit list col-sm-4">
                {props.owner ?
                  <React.Fragment>
                    <li><span className="glyphicon glyphicon-edit" aria-hidden="true"></span>&nbsp;<a href={props.edit_group_path}>編集する</a></li>
                    <li><span className="glyphicon glyphicon-picture" aria-hidden="true"></span>&nbsp;<a href={props.edit_image_group_path}>画像変更する</a></li>
                    <li><span className="glyphicon glyphicon-remove" aria-hidden="true"></span>&nbsp;<a href={props.delete_group_path}>削除する</a></li>
                  </React.Fragment> : null}
              </div>
            </div>
          </div>
        </div>
        <div className="achievement">
          {belong ?
            <React.Fragment>
              <h3>
                本日の目標は
                  {achieved ? <a className="alert alert-success">達成</a> : <a className="alert alert-danger">未達</a>}
                  です！
                </h3>
              <Achievement
                path={props.achievement_path}
                achieved={achieved}
                token={props.token}
                setAchieved={setAchieved} />
            </React.Fragment> :
            null}
        </div>
        <div className="encouragement">
          {achieved ?
            <React.Fragment>
              <Encouragement
                path={props.encouragement_path}
                token={props.token} />
            </React.Fragment> :
            null}
        </div>
        <div className="body">
          <div>
            <h3>習慣</h3>
            <p>{props.group_habit}</p>
          </div>
          <div>
            <h3>概要</h3>
            <p>{props.group_overview}</p>
          </div>
        </div>
      </div >
    </React.Fragment >
  );
}

GroupIntroduction.propTypes = {
  group_image: propTypes.string,
  group_name: propTypes.string,
  group_path: propTypes.string,
  owner_name: propTypes.string,
  owner_path: propTypes.string,
  member_path: propTypes.string,
  member_count: propTypes.number,
  group_habit: propTypes.string,
  group_overview: propTypes.string,
  belong_path: propTypes.string,
  achievement_path: propTypes.string,
  edit_group_path: propTypes.string,
  edit_image_group_path: propTypes.string,
  delete_group_path: propTypes.string,
  belong: propTypes.bool,
  achieved: propTypes.bool,
  owner: propTypes.bool,
  encouragement_path: propTypes.string,
  token: propTypes.string
};

export default GroupIntroduction
