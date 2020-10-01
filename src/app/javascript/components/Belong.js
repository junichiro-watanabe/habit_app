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
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          belong: true
        })
        this.props.setBelong(this.state.belong)
        this.props.setMemberCount(json.member_count)
      }
    )
  }

  leave = () => {
    fetch(this.props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          belong: false
        })
        this.props.setBelong(this.state.belong)
        this.props.setMemberCount(json.member_count)
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
  path: PropTypes.string,
  belong: PropTypes.bool
};

export default Belong
