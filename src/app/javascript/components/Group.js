import React from "react"
import PropTypes from "prop-types"
class Group extends React.Component {
  constructor(props) {
    super(props);
  }

  componentWillMount() {
    setTimeout(() => {
      this.setState({
        txt: "読み込み中",
        backGround: "white"
      });
      // alert("loading");
    }, 2000);
  }

  render() {
    return (
      <React.Fragment>
        <div className="item-info">
          <img src={this.props.group_image} />
          <ol>
            <a href={this.props.group_path}><li><h3>{this.props.group_name}</h3></li></a>
            <li>習慣：{this.props.group_habit}</li>
            <li>概要：{this.props.group_overview}</li>
          </ol>
        </div>
      </React.Fragment>
    );
  }
}

Group.propTypes = {
  group_image: PropTypes.string,
  group_name: PropTypes.string,
  group_path: PropTypes.string,
  group_habit: PropTypes.string,
  group_overview: PropTypes.string,
};

export default Group
