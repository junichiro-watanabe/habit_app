import React, { useState } from "react"
import propTypes from "prop-types"
import Modal from 'react-modal'
import Group from "./Group"

const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: '-45%',
    bottom: '-30%',
    transform: 'translate(-50%, -50%)',
    overflow: 'auto',
    WebkitOverflowScrolling: 'touch',
    background: 'rgb(255, 243, 228)'
  }
};

function AchievedInformation(props) {
  const [notAchieved, setNotAchieved] = useState(props.notAchieved)
  const [modalIsOpen, setModalIsOpen] = useState(false)

  function openModal() {
    setModalIsOpen({ modalIsOpen: true });
  }

  function closeModal() {
    fetch(props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        setNotAchieved(json)
      }
    )
    setModalIsOpen(false);
  }

  return (
    <React.Fragment>
      <div className="timeline-information">
        {notAchieved.length == 0 ?
          <React.Fragment>
            <div className="alert alert-success">
              <h3>今日の目標は全て達成しました</h3>
              <h4>お疲れさまでした！</h4>
            </div>
          </React.Fragment> :
          <React.Fragment>
            <div className="alert alert-danger">
              <h3>未達成の目標が <b><a id="not-achieved" onClick={openModal}>{notAchieved.length}</a></b> 個あります</h3>
              <h4>今日も目標達成できるように</h4>
              <h4>頑張りましょう！</h4>
            </div>
          </React.Fragment>}
        <Modal
          isOpen={modalIsOpen}
          onRequestClose={closeModal}
          style={customStyles}
          contentLabel="Not Achieved Modal" >
          <span onClick={closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
          <h3>目標未達一覧</h3>
          {notAchieved.map((item, index) =>
            <React.Fragment key={index}>
              <div className="index" id={`group-${item.group_id}`}>
                <Group
                  group_image={item.group_image}
                  group_name={item.group_name}
                  group_path={item.group_path}
                  group_habit={item.group_habit}
                  achievement_path={item.achievement_path}
                  owner_name={item.owner_name}
                  owner_path={item.owner_path}
                  member_path={item.member_path}
                  member_count={item.member_count}
                  belong={item.belong}
                  achieved={item.achieved}
                  token={props.token} />
              </div>
            </React.Fragment>
          )}
        </Modal>
      </div>
    </React.Fragment>
  );
}

AchievedInformation.propTypes = {
  path: propTypes.string,
  token: propTypes.string
};

export default AchievedInformation
