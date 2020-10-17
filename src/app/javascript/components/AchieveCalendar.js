import React from "react"
import PropTypes from "prop-types"
import Calendar from 'react-calendar'
import 'react-calendar/dist/Calendar.css'
class AchieveCalendar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      date: new Date(),
      history: this.props.history
    }
  }

  onChange = (date) => { this.setState({ date }) }

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
            onClickDay={(value, event) => alert(this.getFormatDate(value))}
            tileClassName={this.getTileClass} />
        </div>
      </React.Fragment>
    );
  }
}

export default AchieveCalendar
