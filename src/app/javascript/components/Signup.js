import React, { useState, useEffect } from "react"
import propTypes from "prop-types"
import { useTransition, animated, config } from "react-spring"
import { StrongEachWord } from "./Effects"
import Card from "./Card"

const cards = [
  { id: 0, value: <Card src="/assets/light.png" alt="plan" text="習慣を決める" /> },
  { id: 1, value: <Card src="/assets/team.png" alt="team" text="仲間を集める" /> },
  { id: 2, value: <Card src="/assets/continue.png" alt="continue" text="共に継続する" /> }
]

function Slide(props) {
  const [index, set] = useState(0)
  const transitions = useTransition(cards[index], item => item.id, {
    from: { opacity: 0 },
    enter: { opacity: 1 },
    leave: { opacity: 0 },
    config: config.molasses,
  })
  useEffect(() => void setInterval(() => set(state => (state + 1) % 3), 2000), [])
  return transitions.map(({ item, props, key }) => (
    <animated.div key={key} style={{ ...props, position: "absolute" }}>
      {item.value}
    </animated.div >
  ))
}

function Signup() {
  return (
    <React.Fragment>
      <div className="word">
        <StrongEachWord word="新規登録して習慣付けを開始しよう！" />
      </div>
      <Slide />
    </React.Fragment>
  );
}

export default Signup
