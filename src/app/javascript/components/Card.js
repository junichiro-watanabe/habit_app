import React from 'react'
import ReactDOM from 'react-dom'

class Card extends React.Component {
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

export default Card;
