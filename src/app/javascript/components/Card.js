import React from 'react'
import propTypes from "prop-types"

function Card(props) {

  return (
    <div className="card">
      <img src={props.src} alt={props.alt} />
      <h4>{props.text}</h4>
    </div>
  );
}

Card.propTypes = {
  src: propTypes.string,
  text: propTypes.string
};

export default Card;
