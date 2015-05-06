class Background.Api
  # Check if we already have access to api
  is_authorized: ( callback ) ->
    chrome.storage.sync.get( 'ph_access_token', ( resp ) =>
      if @valid_token resp.ph_access_token
        callback( true )
      else
        callback( false )
    )


  # Ask for authorization to api if missing, then proceed with callback
  authorize: ( callback ) ->
    @is_authorized( ( authorized ) => if authorized then callback() else @get_token() )


  # Use token to persist authorization on api
  persist_token: ( ph_resp ) ->
    ph_resp.created_at = new Date().getTime()
    chrome.storage.sync.set( ph_access_token: ph_resp )
    chrome.tabs.remove( Background.last_tab.id )
    

  retrieve_collections: ( id, callback ) ->
    chrome.storage.sync.get( 'ph_access_token', ( resp ) =>
      token = resp.ph_access_token

      xhr = new XMLHttpRequest()
      xhr.open( 'GET', "https://api.producthunt.com/v1/posts/#{id}/collections" )

      xhr.onreadystatechange = ->
        if xhr.readyState == 4
          if xhr.status == 200
            resp = JSON.parse( xhr.responseText )
            callback( resp.collections )

          else
            chrome.storage.sync.set( ph_access_token: null )
            callback( 'error' )

      xhr.setRequestHeader( 'Authorization', "Bearer #{token.access_token}" )
      xhr.send()
    )
    


  valid_token: ( token ) -> token and token.created_at + ( token.expires_in * 1000 ) > new Date().getTime()
  get_token: -> chrome.tabs.create( url: "http://#{Background.oauth_domain}OAUTH_PATH", ( tab ) -> Background.last_tab = tab )

