import React from "react"
function Sidebar(props) {

  function getClass(url) {
    if (url === location.pathname) {
      return "selected"
    }
  }

  return (
    <React.Fragment>
      <aside className="profile">
        <div className="user-info">
          <img src={props.user_image} />
          <h4>{props.user_name}</h4>
        </div>

        <div className="list">
          <ul>
            {props.links.map((item, index) => <a href={item.href} key={index}><li className={getClass(item.href)} dangerouslySetInnerHTML={{ __html: item.link }} /></a>)}
          </ul>
        </div>
      </aside>
    </React.Fragment >
  );
}

export default Sidebar
