import React from "react"
import propTypes from "prop-types"

function Achievement(props) {

  function toggleAchieve() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        props.setAchieved(json.achieved)
      }
    )
  }

  return (
    <React.Fragment>
      <button className="btn btn-primary" onClick={toggleAchieve}>
        達成状況の変更
      </button>
    </React.Fragment>
  );
}

Achievement.propTypes = {
  path: propTypes.string,
  token: propTypes.string,
  setAchieved: propTypes.func
};

export default Achievement
