import React from "react"
import PropTypes from "prop-types"
class Achievement extends React.Component {
  constructor(props) {
    super(props);
  }

  toggleAchieve = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.props.setAchieved(json.achieved)
      }
    )
  }

  render() {
    return (
      <React.Fragment>
        <button className="btn btn-primary" onClick={this.toggleAchieve}>
          達成状況の変更
        </button>
      </React.Fragment>
    );
  }
}

Achievement.propTypes = {
  path: PropTypes.string,
  token: PropTypes.string
};

export default Achievement
