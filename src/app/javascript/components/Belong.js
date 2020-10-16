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
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          belong: json.belong
        })
        this.props.setBelong(this.state.belong)
        this.props.setMemberCount(json.member_count)
        this.props.setAchieved(json.achieved)
      }
    )
  }

  leave = () => {
    fetch(this.props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          belong: json.belong
        })
        this.props.setBelong(this.state.belong)
        this.props.setMemberCount(json.member_count)
        this.props.setAchieved(json.achieved)
      }
    )
  }

  getClass() {
    if (this.state.belong) {
      return "btn btn-warning"
    } else {
      return "btn btn-default"
    }
  }

  render() {
    return (
      <React.Fragment>
        <button className={this.getClass()} onClick={this.state.belong ? this.leave : this.belong}>
          {this.state.belong ? "脱退する" : "参加する"}
        </button>
      </React.Fragment >
    );
  }
}

Belong.propTypes = {
  path: PropTypes.string,
  belong: PropTypes.bool,
  token: PropTypes.string,
  setBelong: PropTypes.func,
  setMemberCount: PropTypes.func,
  setAchieved: PropTypes.func
};

export default Belong
