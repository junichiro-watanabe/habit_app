import React from "react"
import PropTypes from "prop-types"
class Achievement extends React.Component {
  constructor(props) {
    super(props);
  }

  toggleAchieve = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" })
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
        <button id={"achieve_" + this.props.id} className="btn btn-primary" onClick={this.toggleAchieve}>
          達成状況の変更
        </button>
      </React.Fragment>
    );
  }
}

Achievement.propTypes = {
  id: PropTypes.number,
  path: PropTypes.string,
};

export default Achievement
