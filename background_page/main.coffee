chrome.runtime.onConnect.addListener ( port ) ->
  if port.name == 'got_token'
    port.onMessage.addListener ( ph_resp ) ->
      api = new Background.Api()
      api.persist_token( ph_resp )


chrome.tabs.onUpdated.addListener( ( tabId, changeInfo, tab ) ->
  decider = new Background.PageActionDecider( tab )
  decider.decide()
)

@get_collections = ( id, callback ) ->
  api = new Background.Api()
  api.authorize( -> api.retrieve_collections( id, callback ) )
