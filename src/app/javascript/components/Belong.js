import React from "react"
import propTypes from "prop-types"

function Belong(props) {

  function belong() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        props.setBelong(json.belong)
        props.setMemberCount(json.member_count)
        props.setAchieved(json.achieved)
      }
    )
  }

  function leave() {
    fetch(props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        props.setBelong(json.belong)
        props.setMemberCount(json.member_count)
        props.setAchieved(json.achieved)
      }
    )
  }

  function getClass() {
    if (props.belong) {
      return "btn btn-warning";
    } else {
      return "btn btn-default";
    }
  }

  return (
    <React.Fragment>
      <button className={getClass()} onClick={props.belong ? leave : belong}>
        {props.belong ? "脱退する" : "参加する"}
      </button>
    </React.Fragment >
  );
}

Belong.propTypes = {
  path: propTypes.string,
  belong: propTypes.bool,
  token: propTypes.string,
  setBelong: propTypes.func,
  setMemberCount: propTypes.func,
  setAchieved: propTypes.func
};

export default Belong
