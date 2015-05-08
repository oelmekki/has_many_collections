Main = React.createClass
  getInitialState: -> { hideSaveForLater: @props.hideSaveForLater, error: false }

  componentDidMount: -> @populate()

  populate: ->
    @retrievePageId( ( id ) =>
      chrome.runtime.getBackgroundPage ( bg ) =>
        bg.get_collections( id, ( collections ) =>
          if collections is 'error'
            @setState( collections: [], error: true )
          else
            @setState( collections: collections, error: false )
        )
    )


  retrievePageId: ( callback ) ->
    retrievingInterval = setInterval( ->
      chrome.tabs.query({ active: true }, ( tabs ) ->
        tab = tabs[0]

        chrome.tabs.executeScript( tab.id, { code: "JSON.parse( document.querySelector( '[data-react-class=\"PostDetailHeader\"]' ).dataset.reactProps ).id" }, ( id ) ->
          if id
            clearInterval retrievingInterval
            callback( id )
        )
      )
    , 500 )


  filterCollections: ->
    @state.collections.filter( ( item ) =>
      ( ! @state.hideSaveForLater or item.name.toLowerCase().trim() != 'save for later' ) and
      ( ! @state.filter or item.name.toLowerCase().indexOf( @state.filter.toLowerCase() ) isnt -1 )
    )


  showInterface: -> ! @state.error and @state.collections?.length


  handleFilterChange: ( term ) -> @setState( filter: term )

  handleSaveForLaterChange: ( isChecked ) ->
    chrome.storage.sync.set( filter_for_later: isChecked )
    @setState( hideSaveForLater: isChecked )

  filter: -> <Filter onChange={@handleFilterChange} term={@state.filter} /> if @showInterface()
  saveForLater: -> <HideSaveForLater checked={@state.hideSaveForLater} onChange={@handleSaveForLaterChange} /> if @showInterface()


  content: ->
    if @state.error
      <ApiError />
    else
      if @state.collections
        <Collections items={@filterCollections()} hideSaveForLater={@state.hideSaveForLater} filter={@state.filter} />
      else
        <Waiting />

  render: ->
    <div>
      <Title>
        {@filter()}
      </Title>
      {@saveForLater()}
      {@content()}
      <Contact />
    </div>

document.addEventListener( 'DOMContentLoaded', ->
  chrome.storage.sync.get( 'filter_for_later', ( resp ) =>
    React.render(
      <Main hideSaveForLater={resp.filter_for_later} />,
      document.querySelector( '#main' )
    )
  )
)
