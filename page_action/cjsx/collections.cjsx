Collections = React.createClass
  resultsCount: -> if @props.items.length > 1 then "#{@props.items.length} results." else "#{@props.items.length} result."

  render: ->
    if @props.items.length
      collections = (<Collection data={collection} key={collection.id} /> for collection in @props.items)

      <div>
        <p id="results-count">{@resultsCount()}</p>
        <ul id="collections">
          {collections}
        </ul>
      </div>
    else
      <h2>Nothing there (yet).</h2>
