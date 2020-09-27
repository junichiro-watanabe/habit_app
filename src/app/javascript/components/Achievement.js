import React from "react"
import PropTypes from "prop-types"
class Achievement extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      belong: this.props.achieve
    }
  }

  toggleAchieve = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          achieve: json.achieved
        })
      }
    )
  }

  render() {
    return (
      <React.Fragment>
        <button onClick={this.toggleAchieve}>
          {this.state.achieve ? "達成" : "未達"}
        </button>
      </React.Fragment>
    );
  }
}

Achievement.propTypes = {
  path: PropTypes.string
};

export default Achievement
