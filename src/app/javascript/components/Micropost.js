import React from "react"
import PropTypes from "prop-types"
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
                  <h3>
                    <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                    &nbsp;&nbsp;<a href={this.props.group_path}>{this.props.group_name}</a>
                    &nbsp;の&nbsp;<a href={this.props.user_path}>{this.props.user_name}</a>
                    &nbsp;が煽っています
                    &nbsp;&nbsp;<span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                  </h3>
                </React.Fragment> :
                <a href={this.props.user_path}><li><h4>{this.props.user_name}</h4></li></a>}
              <p>{this.props.time}</p>
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
  time: PropTypes.string
};

export default Micropost
