import React from "react"
import PropTypes from "prop-types"
class Belong extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      belong: this.props.belong
    }
  }

  belong = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" })
    }).then(
      (response) => {
        const isBelonging = response.belong !== null
        this.setState({
          belong: isBelonging
        })
      }
    )
  }

  leave = () => {
    fetch(this.props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" })
    }).then(
      (response) => {
        this.setState({
          belong: false
        })
      }
    )
  }

  render() {
    return (
      <React.Fragment>
        <button onClick={this.state.belong ? this.leave : this.belong}>
          {this.state.belong ? "脱退する" : "参加する"}
        </button>
      </React.Fragment >
    );
  }
}

Belong.propTypes = {
  path: PropTypes.string
};

export default Belong
