import React from 'react'
import PropTypes from "prop-types"

function Card(props) {

  return (
    <div className="card">
      <img src={props.src} alt={props.alt} />
      <h4>{props.text}</h4>
    </div>
  );
}

Card.PropTypes = {
  src: PropTypes.string,
  text: PropTypes.string
};

export default Card;
