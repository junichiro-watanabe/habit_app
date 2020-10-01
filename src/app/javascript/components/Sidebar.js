import React from "react"
import PropTypes from "prop-types"
class Sidebar extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <React.Fragment>
        <aside className="profile">
          <div className="user-info">
            <img src={this.props.user_image} />
            <h4>{this.props.user_name}</h4>
          </div>

          <ul>
            {this.props.links.map((item, index) => <li key={index}><a href={item.href}>{item.link}</a></li>)}
          </ul>
        </aside>
      </React.Fragment >
    );
  }
}

export default Sidebar
