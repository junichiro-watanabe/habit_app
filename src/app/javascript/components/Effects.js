import React from "react"
import { useSpring, useTrail, animated, config } from 'react-spring'

function FadeIn(props) {
  const spring = useSpring({
    to: { opacity: 1 },
    from: { opacity: 0 },
    config: config.molasses
  })
  return <animated.h2 style={{ ...spring }}>{props.word}</animated.h2>
}

function StrongEachWord(props) {
  const message = props.word
  const trail = useTrail(
    message.length,
    {
      to: { opacity: 1 },
      from: { opacity: 0 },
      config: config.stiff
    }
  );
  return (
    trail.map((item, index) => (
      <animated.span style={{ ...item, fontSize: "25px" }}>
        {message[index]}
      </animated.span >)
    )
  )
}

export { FadeIn, StrongEachWord }
