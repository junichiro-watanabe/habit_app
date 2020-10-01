import React from "react"
import PropTypes from "prop-types"
class Micropost extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <React.Fragment>
        <div className="micropost">
          <div className="micropost-user">
            <img src={this.props.user_image} />
            <div>
              <a href={this.props.user_path}><li><h4>{this.props.user_name}</h4></li></a>
              <p>{this.props.time}</p>
            </div>
          </div>
          <div className="micropost-content">
            {this.props.history === null ? <p>{this.props.content}</p> : <p dangerouslySetInnerHTML={{ __html: this.props.content }} />}
          </div>
        </div>
      </React.Fragment >
    );
  }
}

Micropost.proptypes = {
  user_image: PropTypes.string,
  user_path: PropTypes.string,
  user_name: PropTypes.string,
  content: PropTypes.string,
  time: PropTypes.string
};

export default Micropost
