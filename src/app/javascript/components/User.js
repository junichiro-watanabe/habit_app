import React from "react"
import PropTypes from "prop-types"
class User extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <React.Fragment>
        <div className="item-info">
          <img src={this.props.user_image} />
          <ol>
            <a href={this.props.user_path}><li><h3>{this.props.user_name}</h3></li></a>
          </ol>
        </div>
      </React.Fragment >
    );
  }
}

export default User
