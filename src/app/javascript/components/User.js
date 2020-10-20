import React from "react"
import PropTypes from "prop-types"
import Follow from "./Follow"
class User extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      follow: this.props.follow
    }
  }

  setFollow = (follow) => {
    this.setState({ follow: follow })
  }

  render() {
    return (
      <React.Fragment>
        <div className="item">
          {this.state.follow ?
            <span className="alert alert-info">
              このユーザをフォローしています
            </span> : null}
          <div className="item-info row">
            <div className="user-image col-sm-2">
              <img src={this.props.user_image} />
            </div>
            <div className="col-sm-offset-1 col-sm-6">
              <a href={this.props.user_path}><li><h3>{this.props.user_name}</h3></li></a>
              <div className="list">
                <li>{this.props.user_introduction}</li>
              </div>
            </div>
            <div className="col-sm-3 follow">
              {this.props.current_user ? "" :
                <Follow
                  path={this.props.relationship_path}
                  follow={this.state.follow}
                  token={this.props.token}
                  setFollow={this.setFollow} />}
            </div>
          </div>
        </div>
      </React.Fragment >
    );
  }
}

User.propTypes = {
  user_image: PropTypes.string,
  user_path: PropTypes.string,
  user_name: PropTypes.string,
  user_introduction: PropTypes.string,
  relationship_path: PropTypes.string,
  follow: PropTypes.bool,
  current_user: PropTypes.bool,
  token: PropTypes.string
};

export default User
