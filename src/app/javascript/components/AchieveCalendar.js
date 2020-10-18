import React from "react"
import PropTypes from "prop-types"
import Calendar from 'react-calendar'
import 'react-calendar/dist/Calendar.css'
import MicropostHistory from './MicropostHistory'
import Modal from 'react-modal';
import Micropost from './Micropost'

const customStyles = {
  content: {
    top: '50%',
    left: '50%',
    right: '-50%',
    bottom: '-30%',
    transform: 'translate(-50%, -50%)',
    overflow: 'auto',
    WebkitOverflowScrolling: 'touch'
  }
};

class AchieveCalendar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      date: new Date(),
      history: this.props.history,
      modalIsOpen: false
    }
  }

  afterOpenModal = () => {
    this.subtitle.style.color = '#black';
  }
  closeModal = () => {
    this.setState({ modalIsOpen: false });
  }

  onChange = (date) => {
    this.setState({ date: date })
  }

  onClickDay = (value, view) => {
    this.setState({ modalIsOpen: true })
  }

  getFormatDate(date) {
    return `${date.getFullYear()}-${('0' + (date.getMonth() + 1)).slice(-2)}-${('0' + date.getDate()).slice(-2)}`;
  }

  getTileClass = ({ date, view }) => {
    if (view !== 'month') {
      return '';
    }
    const day = this.getFormatDate(date);
    if (this.state.history[day]) {
      if (this.state.history[day].length >= 5) {
        return "high";
      } else if (this.state.history[day].length >= 3) {
        return "middle";
      } else if (this.state.history[day].length >= 1) {
        return "row";
      }
    }
  }

  render() {
    return (
      <React.Fragment>
        <div className="calendar">
          <h5>達成状況確認カレンダー</h5>
          <Calendar
            locale="ja-JP"
            calendarType="US"
            onChange={this.onChange}
            value={this.state.date}
            onClickDay={this.onClickDay}
            tileClassName={this.getTileClass} />
        </div>

        {this.state.history[this.getFormatDate(this.state.date)] ?
          <Modal
            isOpen={this.state.modalIsOpen}
            onAfterOpen={this.afterOpenModal}
            onRequestClose={this.closeModal}
            style={customStyles}
            contentLabel="Example Modal"
          >
            <h2 ref={subtitle => this.subtitle = subtitle}>{this.getFormatDate(this.state.date)} の達成目標</h2>
            {this.state.history[this.getFormatDate(this.state.date)].map((item) =>
              <React.Fragment>
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
                  token={this.props.token} />
              </React.Fragment>
            )}
            <button className="btn btn-default" onClick={this.closeModal}>close</button>
          </Modal> : null
        }
      </React.Fragment>
    );
  }
}

export default AchieveCalendar
