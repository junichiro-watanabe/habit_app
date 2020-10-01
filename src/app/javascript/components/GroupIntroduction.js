import React from "react"
import PropTypes from "prop-types"
import Belong from "./Belong"
import Achievement from "./Achievement"
class GroupIntroduction extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      belong: this.props.belong,
      achieved: this.props.achieved,
      memberCount: this.props.member_count
    }
  }

  setBelong = (belong) => {
    this.setState({ belong: belong })
  }

  setAchieved = (achieved) => {
    this.setState({ achieved: achieved })
  }

  setMemberCount = (memberCount) => {
    this.setState({ memberCount: memberCount })
  }

  render() {
    return (
      <React.Fragment>
        <div className="group">
          <div className="group-head jumbotron">
            <img src={this.props.group_image} />
            <ol>
              <li><h3>{this.props.group_name}</h3></li>
              <li>主催者：<a href={this.props.owner_path}>{this.props.owner_name}</a></li>
              <li>メンバー：<a href={this.props.member_path}>{this.state.memberCount}人が参加</a></li><br />
              <Belong path={this.props.belong_path}
                belong={this.state.belong}
                memberCount={this.state.memberCount}
                setBelong={this.setBelong}
                setMemberCount={this.setMemberCount} />
            </ol>
          </div>
          <div className="group-body">
            <div>
              <h3>習慣</h3>
              <p>{this.props.group_habit}</p>
            </div>
            <div>
              <h3>概要</h3>
              <p>{this.props.group_overview}</p>
            </div>
            {this.state.belong ?
              <React.Fragment>
                <h3>本日の目標は{this.state.achieved ? "達成です！" : "未達です！"}</h3>
                <Achievement path={this.props.achievement_path}
                  achieved={this.state.achieved}
                  setAchieved={this.setAchieved} />
              </React.Fragment> :
              null}
            {this.props.owner ?
              <React.Fragment>
                <li><a href={this.props.edit_group_path}>編集する</a></li>
                <li><a href={this.props.edit_image_group_path}>画像変更する</a></li>
                <li><a href={this.props.delete_group_path}>削除する</a></li>
              </React.Fragment> : null}
          </div>
        </div>
      </React.Fragment>
    );
  }
}

GroupIntroduction.propTypes = {
  group_image: PropTypes.string,
  group_name: PropTypes.string,
  group_path: PropTypes.string,
  owner_name: PropTypes.string,
  owner_path: PropTypes.string,
  member_path: PropTypes.string,
  member_count: PropTypes.number,
  group_habit: PropTypes.string,
  group_overview: PropTypes.string,
  belong_path: PropTypes.string,
  achievement_path: PropTypes.string,
  edit_group_path: PropTypes.string,
  edit_image_group_path: PropTypes.string,
  delete_group_path: PropTypes.string,
  belong: PropTypes.bool,
  achieved: PropTypes.bool,
  owner: PropTypes.bool
};

export default GroupIntroduction
