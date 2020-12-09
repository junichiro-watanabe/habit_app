import React, { useState } from "react"
import propTypes from "prop-types"
import Calendar from 'react-calendar'
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
    background: 'rgb(255, 243, 228)'
  }
};

function AchieveCalendar(props) {
  const [history, setHistory] = useState(props.history);
  const [date, setDate] = useState(new Date());
  const [modalIsOpen, setModalIsOpen] = useState(false);

  function closeModal() {
    setModalIsOpen(false);
  }

  function onChange(date) {
    setDate(date);
  }

  function onClickDay(value, view) {
    history[getFormatDate(value)] ? setModalIsOpen(true) : null;
  }

  function getFormatDate(date) {
    return `${date.getFullYear()}-${('0' + (date.getMonth() + 1)).slice(-2)}-${('0' + date.getDate()).slice(-2)}`;
  }

  function getTileClass({ date, view }) {
    if (view !== 'month') {
      return '';
    }
    const day = getFormatDate(date);
    if (history[day]) {
      if (history[day].length >= 5) {
        return `day-${day} high`;
      } else if (history[day].length >= 3) {
        return `day-${day} middle`;
      } else if (history[day].length >= 1) {
        return `day-${day} row`;
      } else {
        return `day-${day}`;
      }
    }
  }

  return (
    <React.Fragment>
      <div className="calendar">
        <h5>達成状況確認カレンダー</h5>
        <Calendar
          locale="ja-JP"
          calendarType="US"
          onChange={onChange}
          value={date}
          onClickDay={onClickDay}
          tileClassName={getTileClass} />
        {history[getFormatDate(date)] ?
          <Modal
            isOpen={modalIsOpen}
            onRequestClose={closeModal}
            style={customStyles}
            contentLabel="Micropost Modal" >
            <span onClick={closeModal} className="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
            <h3>{getFormatDate(date)} 達成目標</h3>
            {history[getFormatDate(date)].map((item) =>
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
                  token={props.token} />
              </React.Fragment>
            )}
          </Modal> : null
        }
      </div>
    </React.Fragment>
  );
}

AchieveCalendar.propTypes = {
  token: propTypes.string
};

export default AchieveCalendar
