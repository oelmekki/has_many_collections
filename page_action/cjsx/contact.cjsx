Contact = React.createClass
  contactUrl: -> "https://twitter.com/oelmekki"

  handleClick: -> window.open @contactUrl()

  render: ->
    <p id="contact">Any problem? Feel free to <a href={@contactUrl()} onClick={@handleClick}>ping me</a>.</p>
