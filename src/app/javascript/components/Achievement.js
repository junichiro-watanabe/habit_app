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
        <h3>本日の目標は{this.state.achieve ? "達成です！" : "未達です！"}</h3>
        <button onClick={this.toggleAchieve}>
          達成状況の変更
        </button>
      </React.Fragment>
    );
  }
}

Achievement.propTypes = {
  path: PropTypes.string
};

export default Achievement
