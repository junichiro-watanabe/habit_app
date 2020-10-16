import React from "react"
import PropTypes from "prop-types"
class Like extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      like: this.props.like,
      likeCount: this.props.like_count
    }
  }

  like = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          like: json.like,
          likeCount: json.like_count
        })
      }
    )
  }

  unLike = () => {
    fetch(this.props.path, {
      method: 'DELETE',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          like: json.like,
          likeCount: json.like_count
        })
      }
    )
  }

  getClass(like) {
    if (this.state.like) {
      return "like"
    } else {
      return "unlike"
    }
  }

  render() {
    return (
      <React.Fragment>
        <a className={this.getClass()} onClick={this.state.like ? this.unLike : this.like} >
          <span className="glyphicon glyphicon-heart" aria-hidden="true"></span>
        </a>&nbsp;
        <a href={this.props.path}>{this.state.likeCount}</a>
      </React.Fragment>
    );
  }
}

Like.PropTypes = {
  path: PropTypes.string,
  like: PropTypes.bool,
  like_count: PropTypes.number,
  token: PropTypes.string
}

export default Like
