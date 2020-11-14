import React from "react"
import { FadeIn, StrongEachWord } from "./Effects"
import Card from "./Card"

function Home(props) {

  return (
    <React.Fragment>
      <div className="container first-content">
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

      <div className="jumbotron about">
        <div className="container">
          <FadeIn word="Habit Appとは？" />
          <p>「勉強したいけど、いつも挫折してしまう…」</p>
          <p>「習慣にしたいけど、なかなか継続できない…」</p>
          <p>そのような悩みをお持ちの方は、仲間と一緒ならば解決できるかもしれません</p>
          <br></br>
          <p>Habit Appは共に習慣付けを頑張ってくれる仲間集めを支援します</p>
        </div>
      </div>

      <div className="container step-content">
        <h3>3ステップで習慣づけ</h3>
        <div className="cards row">
          <div className="col-sm-4">
            <Card src="/assets/light.png" alt="plan" text="習慣を決める" />
          </div>
          <div className="col-sm-4">
            <Card src="/assets/team.png" alt="team" text="仲間を集める" />
          </div>
          <div className="col-sm-4">
            <Card src="/assets/continue.png" alt="continue" text="共に継続する" />
          </div>
        </div>
      </div>
    </React.Fragment >
  );
}

export default Home
