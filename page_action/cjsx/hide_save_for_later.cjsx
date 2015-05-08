HideSaveForLater = React.createClass
  handleChange: ( event ) -> @props.onChange( event.target.checked )

  render: ->
    <p id="hide-save-for-later">
      <label>
        <input type="checkbox" defaultChecked={@props.checked} onChange={@handleChange} />
        Hide "Save for later" collections
      </label>
    </p>
