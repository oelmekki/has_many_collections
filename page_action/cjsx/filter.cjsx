Filter = React.createClass
  handleChange: ( event ) -> @props.onChange event.target.value

  render: ->
    <input type="search" id="filter" placeholder="filter..." value={@props.term} onChange={@handleChange} />
