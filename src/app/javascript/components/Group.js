import React from "react"
import PropTypes from "prop-types"
class Group extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <React.Fragment>
        <div className="item-info">
          <img src={this.props.group_image} />

          <ol>
            <a href={this.props.group_path}><li><h3>{this.props.group_name}</h3></li></a>
            <li>習慣：{this.props.group_habit}</li>
            <li>概要：{this.props.group_overview}</li>
          </ol>
        </div>
      </React.Fragment>
    );
  }
}

export default Group
