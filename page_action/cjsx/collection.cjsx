Collection = React.createClass
  open: -> window.open @props.data.collection_url

  render: ->
    <li className="collection">
      <a href={@props.data.collection_url} onClick={@open}>
        <h2>
          <span className="count">{@props.data.posts_count}</span>
          {@props.data.name}
        </h2>
        <img src={@props.data.user.image_url[ '30px' ]} />
        <span className="user_name">{@props.data.user.name}</span>
      </a>
    </li>
