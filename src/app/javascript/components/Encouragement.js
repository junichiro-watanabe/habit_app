import React from "react"
import PropTypes from "prop-types"
class Encouragement extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <React.Fragment>
        <form action={this.props.path} method="post" className="encouragement">
          <input type="hidden" name="authenticity_token" value={this.props.token} />
          <div className="form-group">
            <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
            <label for="encouragement">&nbsp;&nbsp;目標達成お疲れさまでした！メンバーに対して煽ることができます&nbsp;&nbsp;</label>
            <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
            <textarea className="form-control" name="content" id="encouragement" placeholder="煽ってください"></textarea>
          </div>
          <button type="submit" className="btn btn-warning">煽る</button>
        </form>
      </React.Fragment>
    );
  }
}

Encouragement.propTypes = {
  path: PropTypes.string,
  token: PropTypes.string
}

export default Encouragement
