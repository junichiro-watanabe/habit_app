import React from "react"
import PropTypes from "prop-types"
import Like from "./Like"
class Micropost extends React.Component {
  constructor(props) {
    super(props);
  }

  getClass() {
    if (this.props.encouragement) {
      return "micropost encouragement-micropost"
    } else {
      return "micropost"
    }
  }

  render() {
    return (
      <React.Fragment>
        <div className={this.getClass()}>
          <div className="micropost-user">
            <img src={this.props.user_image} />
            <div>
              {this.props.encouragement ?
                <React.Fragment>
                  <h4>
                    <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                    &nbsp;&nbsp;<a href={this.props.group_path}>{this.props.group_name}</a>
                    &nbsp;の&nbsp;<a href={this.props.user_path}>{this.props.user_name}</a>
                    &nbsp;さんが煽っています
                    &nbsp;&nbsp;<span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                  </h4>
                </React.Fragment> :
                <a href={this.props.user_path}><li><h4>{this.props.user_name}</h4></li></a>}
              <div className="micropost-time">
                <p>{this.props.time}</p>
                <Like
                  path={this.props.like_path}
                  like={this.props.like}
                  like_count={this.props.like_count}
                  token={this.props.token} />
              </div>
            </div>
          </div>
          <div className="micropost-content">
            {this.props.history && !this.props.encouragement ?
              <p dangerouslySetInnerHTML={{ __html: this.props.content }} /> :
              <p>{this.props.content}</p>}
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
  group_path: PropTypes.string,
  group_name: PropTypes.string,
  content: PropTypes.string,
  time: PropTypes.string,
  like_path: PropTypes.string,
  like: PropTypes.bool,
  like_count: PropTypes.number,
  token: PropTypes.string
};

export default Micropost
