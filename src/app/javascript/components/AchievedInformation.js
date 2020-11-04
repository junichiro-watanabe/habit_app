import React from "react"
import PropTypes from "prop-types"
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

class AchievedInformation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      notAchieved: this.props.notAchieved,
      modalIsOpen: false
    }
  }

  afterOpenModal = () => {
    this.close.style.float = 'right';
    this.close.style.fontSize = '30px';
    this.close.style.cursor = 'pointer';
  }

  openModal = () => {
    this.setState({ modalIsOpen: true });
  }

  closeModal = () => {
    fetch(this.props.path, {
      method: 'PATCH',
      headers: new Headers({ "Content-type": "application/json" }),
      body: JSON.stringify({ "authenticity_token": this.props.token })
    }).then((response) => response.json()
    ).then(
      (json) => {
        this.setState({
          notAchieved: json
        })
      }
    )
    this.setState({ modalIsOpen: false });
  }

  render() {
    return (
      <React.Fragment>
        <div className="timeline-information">
          {this.state.notAchieved.length == 0 ?
            <React.Fragment>
              <div className="alert alert-success">
                <h3>今日の目標は全て達成しました</h3>
                <h4>お疲れさまでした！</h4>
              </div>
            </React.Fragment> :
            <React.Fragment>
              <div className="alert alert-danger">
                <h3>未達成の目標が <b><a id="not-achieved" onClick={this.openModal}>{this.state.notAchieved.length}</a></b> 個あります</h3>
                <h4>今日も目標達成できるように</h4>
                <h4>頑張りましょう！</h4>
              </div>
            </React.Fragment>}
          <Modal
            isOpen={this.state.modalIsOpen}
            onAfterOpen={this.afterOpenModal}
            onRequestClose={this.closeModal}
            style={customStyles}
            contentLabel="Not Achieved Modal" >
            <span ref={close => this.close = close} onClick={this.closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            <h3>目標未達一覧</h3>
            {this.state.notAchieved.map((item) =>
              <React.Fragment>
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
                    token={this.props.token} />
                </div>
              </React.Fragment>
            )}
          </Modal>
        </div>
      </React.Fragment>
    );
  }
}

AchievedInformation.PropTypes = {
  path: PropTypes.string,
  token: PropTypes.string
};

export default AchievedInformation
