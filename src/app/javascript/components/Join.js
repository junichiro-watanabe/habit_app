import React from "react"
import PropTypes from "prop-types"
class Join extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <React.Fragment>
        {!this.props.belong ?
          <React.Fragment>
            <a rel="nofollow" data-method="patch" href={this.props.link}>参加する</a>
          </React.Fragment > :
          < React.Fragment >
            <a rel="nofollow" data-method="delete" href={this.props.link}>脱退する</a>
          </React.Fragment >}
      </React.Fragment>
    );
  }
}

Join.propTypes = {
  belong: PropTypes.boolean,
  link: PropTypes.string
};

export default Join
