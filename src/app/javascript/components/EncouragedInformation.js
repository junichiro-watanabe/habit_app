import React, { useState } from "react";
import propTypes from "prop-types";
import Modal from 'react-modal'
import Micropost from './Micropost'

const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: '-45%',
    bottom: '-30%',
    transform: 'translate(-50%, -50%)',
    overflow: 'auto',
    WebkitOverflowScrolling: 'touch',
    background: 'white'
  }
};

function EncouragedInformation(props) {
  const [encouraged, setEncouraged] = useState(props.encouraged)
  const [modalIsOpen, setModalIsOpen] = useState(false)

  function openModal() {
    setModalIsOpen(true);
  }

  function closeModal() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setEncouraged(json)
      }
    )
    setModalIsOpen(false);
  }

  return (
    <React.Fragment>
      <div className="timeline-information">
        {encouraged.length == 0 ?
          <React.Fragment>
            <div className="alert alert-success">
              <h3>煽っているユーザはいません</h3>
              <h4>先に目標を達成しましょう！</h4>
            </div>
          </React.Fragment> :
          <React.Fragment>
            <div className="alert alert-warning">
              <h3>
                <span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
                  &nbsp;&nbsp;<b><a id="encouraged" onClick={openModal}>{encouraged.length}</a></b> 回煽られています
                  &nbsp;&nbsp;<span className="glyphicon glyphicon-fire" aria-hidden="true"></span>
              </h3>
              <h4>仲間に負けずに頑張りましょう！</h4>
            </div>
          </React.Fragment>}
        <Modal
          isOpen={modalIsOpen}
          onRequestClose={closeModal}
          style={customStyles}
          contentLabel="Encouraged Modal" >
          <span onClick={closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
          <h3>仲間の投稿を見て頑張りましょう！</h3>
          {encouraged.map((item, index) =>
            <React.Fragment key={index}>
              <Micropost
                user_image={item.user_image}
                user_name={item.user_name}
                user_path={item.user_path}
                group_name={item.group_name}
                group_path={item.group_path}
                content={item.content}
                time={item.time}
                history={item.history}
                encouragement={item.encouragement}
                like_path={item.like_path}
                like={item.like}
                like_count={item.like_count}
                token={props.token} />
            </React.Fragment>
          )}
        </Modal>
      </div>
    </React.Fragment>
  );
}

EncouragedInformation.propTypes = {
  path: propTypes.string,
  token: propTypes.string
};

export default EncouragedInformation
