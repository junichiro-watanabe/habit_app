import React from "react"
import PropTypes from "prop-types"
class User extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <React.Fragment>
        <div className="item">
          <div className="item-info">
            <img src={this.props.user_image} />
            <ol>
              <a href={this.props.user_path}><li><h3>{this.props.user_name}</h3></li></a>
              <li>自己紹介：{this.props.user_introduction}</li>
            </ol>
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
  user_introduction: PropTypes.string
};

export default User
