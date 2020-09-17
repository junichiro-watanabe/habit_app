import React from 'react'
import PropTypes from "prop-types"

class Card extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="card">
        <div>
          <img src={this.props.src} alt={this.props.alt} width="200px" height="200px" />
        </div>
        <h3>{this.props.text}</h3>
      </div>
    );
  }
}

Card.propTypes = {
  src: PropTypes.string,
  text: PropTypes.string
};

export default Card;
