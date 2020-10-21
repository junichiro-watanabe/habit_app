import React from "react"
import PropTypes from "prop-types"
import Achievement from "./Achievement"
class Group extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      belong: this.props.belong,
      achieved: this.props.achieved,
      memberCount: this.props.member_count
    }
  }

  setAchieved = (achieved) => {
    this.setState({ achieved: achieved })
  }

  render() {
    return (
      <React.Fragment>
        <div className="item">
          {this.state.belong ?
            <span className="alert alert-info">
              このコミュニティに参加しています
            </span> : null}
          <div className="item-info row">
            <div className="user-image col-sm-2">
              <img src={this.props.group_image} />
            </div>
            <div className="col-sm-7">
              <div className="list">
                <a href={this.props.group_path}><li><h3>{this.props.group_name}</h3></li></a>
                <li>オーナー：<a href={this.props.owner_path}>{this.props.owner_name}</a></li>
                <li>メンバー：<a href={this.props.member_path}>{this.state.memberCount}人が参加</a></li>
                <li>習慣：{this.props.group_habit}</li>
              </div>
            </div>
            <div className="achievement col-sm-3">
              {this.state.belong ?
                <React.Fragment>
                  <h4>
                    {this.state.achieved ? <a className="alert alert-success">達成</a> : <a className="alert alert-danger">未達</a>}
                  </h4>
                  <Achievement
                    path={this.props.achievement_path}
                    achieved={this.state.achieved}
                    token={this.props.token}
                    setAchieved={this.setAchieved} />
                </React.Fragment> :
                null}
            </div>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

Group.PropTypes = {
  group_image: PropTypes.string,
  group_name: PropTypes.string,
  group_path: PropTypes.string,
  group_habit: PropTypes.string,
  achievement_path: PropTypes.string,
  owner_name: PropTypes.string,
  owner_path: PropTypes.string,
  member_path: PropTypes.string,
  member_count: PropTypes.number,
  belong: PropTypes.bool,
  achieved: PropTypes.bool,
  token: PropTypes.string
};

export default Group
