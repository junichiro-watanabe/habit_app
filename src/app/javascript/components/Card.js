import React from 'react'
import PropTypes from "prop-types"

class Card extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="card">
        <img src={this.props.src} alt={this.props.alt} />
        <h4>{this.props.text}</h4>
      </div>
    );
  }
}

Card.PropTypes = {
  src: PropTypes.string,
  text: PropTypes.string
};

export default Card;
