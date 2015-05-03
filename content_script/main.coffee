# This script is executed when returning from PH's `oauth#authorize`.
#
# If all is good, there should be a `code` query parameter, which represent
# temporary `access_grant` token from PH. Our job is to ask hunting cabin
# server to retrieve a permanent token using that access, then to send it
# to extension background page, which will store it in browser.
#
# We can contact directly PH api from js because it requires application secrets.
#
# Note that presence of code query parameter is not guarenteed: there
# may have been an error.
#
class TokenChecker
  constructor: ->
    unless @has_error()
      if @access_grant()
        @get_token()
      else
        @error()


  # Retrieve token when access_granted token is present
  get_token: ->
    url = new Url( "#{@url().domain_part()}/has_many_collections/get_token" )
    url.set_params( code: @access_grant() )
    $.getJSON( url.to_s(), ( resp ) =>
      @finalize resp
    )


  # Contact back extension's background page
  finalize: ( resp ) ->
    if resp.error
      @error()
    else
      port = chrome.runtime.connect( name: 'got_token' )
      port.postMessage resp



  # There is no error, but no access_granted token as
  # well.
  # OR
  # there was an error while retrieving token.
  #
  # Let's simulate an error.
  error: ->
    params = @url().get_params()
    params.error = 'no_access_grant_or_token'
    @url().set_params( params )
    window.location.href = @url().to_s()


  # Server side handles error pretty well, already, so
  # let's trust it in matter of error presence.
  has_error: -> document.querySelector( '#error' )

  # Current url, cached. If you alter it (like error simulation
  # do), it will be preserved at next call.
  url: -> @_url ?= new Url( window.location.href )

  # Retrieve grant token from url
  access_grant: -> @url().get_params().code


new TokenChecker()
