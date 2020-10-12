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
            <a className="alert alert-info">
              このユーザをフォローしています
            </a> : null}
          <div className="item-info row">
            <img className="col-md-5" src={this.props.user_image} />
            <ol className="col-md-6">
              <a href={this.props.user_path}><li><h3>{this.props.user_name}</h3></li></a>
              <li>自己紹介：{this.props.user_introduction}</li>
            </ol>
            <div className="col-md-1 follow">
              {this.props.current_user ?
                "" :
                <Follow
                  path={this.props.relationship_path}
                  follow={this.state.follow}
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
  current_user: PropTypes.bool
};

export default User
