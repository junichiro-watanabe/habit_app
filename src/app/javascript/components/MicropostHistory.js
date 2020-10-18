import React from 'react';
import PropTypes from "prop-types"
import Modal from 'react-modal';
import Micropost from './Micropost'
const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: 'auto',
    bottom: 'auto',
    marginRight: '-50%',
    transform: 'translate(-50%, -50%)'
  }
};

class MicropostHistory extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      modalIsOpen: false
    };
  }
  openModal = () => {
    this.setState({ modalIsOpen: true });
  }
  afterOpenModal = () => {
    this.subtitle.style.color = '#f00';
  }
  closeModal = () => {
    this.setState({ modalIsOpen: false });
  }

  render() {
    return (
      <React.Fragment>
        <div>
          <button onClick={this.openModal}>Open Modal!!</button>
          <Modal
            isOpen={this.state.modalIsOpen}
            onAfterOpen={this.afterOpenModal}
            onRequestClose={this.closeModal}
            style={customStyles}
            contentLabel="Example Modal"
          >
            <h2 ref={subtitle => this.subtitle = subtitle}>ModalWindow</h2>
            <Micropost
              user_image={this.props.user_image}
              user_name={this.props.user_name}
              user_path={this.props.user_path}
              group_name={this.props.group_name}
              group_path={this.props.group_path}
              content={this.props.content}
              time={this.props.time}
              history={this.props.history}
              encouragement={this.props.encouragement}
              like_path={this.props.like_path}
              like={this.props.like}
              like_count={this.props.like_count}
              token={this.props.token} />
            <button onClick={this.closeModal}>close</button>
          </Modal>
        </div>
      </React.Fragment>
    );
  }
}

export default MicropostHistory
