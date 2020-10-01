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
        <button onClick={this.toggleAchieve}>
          達成状況の変更
        </button>
      </React.Fragment>
    );
  }
}

Achievement.propTypes = {
  path: PropTypes.string,
};

export default Achievement
