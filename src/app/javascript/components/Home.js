import React from "react"
import PropTypes from "prop-types"
import { FadeIn, StrongEachWord } from "./Effects"
import Card from "./Card"

class Home extends React.Component {

  render() {
    return (
      <React.Fragment>
        <div className="first-content">
          <div>
            <FadeIn word="仲間と協力して" />
            <FadeIn word="習慣を身に着けよう" />
          </div>

          <div className="start-button">
            <a href="/signup">
              <button className="btn btn-success">今すぐ始める</button>
            </a>
          </div>
        </div>

        <div class="step-content">
          <h3>3ステップで習慣づけ</h3>
          <div className="cards row">
            <div className="col-md-4">
              <Card src="/assets/notebook.png" alt="plan" text="習慣を決める" />
            </div>
            <div className="col-md-4">
              <Card src="/assets/team.png" alt="team" text="仲間を集める" />
            </div>
            <div className="col-md-4">
              <Card src="/assets/continue.png" alt="continue" text="共に継続する" />
            </div>
          </div>
        </div>
      </React.Fragment >
    );
  }
}

export default Home
