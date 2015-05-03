class Popup
  constructor: ->
    @populate()
    @bind()

  populate: ->
    @retrieve_page_id( ( id ) =>
      chrome.runtime.getBackgroundPage ( bg ) =>
        bg.get_collections( id, ( collections ) =>
          $( '#waiting' ).hide()
          $( '#collections' ).show()

          if collections == 'error'
            @show_error()
          else
            $( '#filter' ).show()
            @add_collection( collection ) for collection in collections
        )
    )

  add_collection: ( collection ) ->
    $li = $( '<li class="collection"></li>' ).appendTo $( 'ul#collections' )
    $a = $( "<a href='#{collection.collection_url}'></a>" ).appendTo $li
    $( "<h2><span class='count'>#{collection.posts_count}</span> #{collection.name}</h2>" ).appendTo $a
    $( "<img src='#{collection.user.image_url[ '30px' ]}'>" ).appendTo $a
    $( "<span class='user_name'>#{collection.user.name}</span>" ).appendTo $a


  show_error: ->
    $li = $( '<li class="collection error"><h2>Sorry, an error occured while contacting product hunt :(</h2></li>' ).appendTo $( 'ul#collections' )


  bind: ->
    $( '#collections' ).on( 'click', 'a', -> window.open( @href ) )
    $( '#filter' ).on( 'keyup', @search )
    $( '#filter' ).on( 'search', @search )


  search: =>
    term = $( '#filter' ).val().toLowerCase()

    if term.length == 0
      @show_all()
    else
      $( '.collection' ).each( ( i, el ) ->
        $el = $( el )
        if $el.text().toLowerCase().indexOf( term ) is -1
          $el.hide()
        else
          $el.show()
      )

      if $( '.collection:visible' ).length
        @no_result().hide()
      else
        @no_result().show()


  no_result: ->
    @_no_result ?= $( '<li id="no-result">Sorry, no match for that.</li>' ).appendTo $( '#collections' )

  show_all: -> $( '.collection' ).show()

  retrieve_page_id: ( callback ) ->
    chrome.tabs.query({ active: true }, ( tabs ) ->
      tab = tabs[0]

      chrome.tabs.executeScript( tab.id, { code: "JSON.parse( document.querySelector( '[data-react-class=\"PostDetailHeader\"]' ).dataset.reactProps ).id" }, ( id ) ->
        callback( id ) if id
      )
    )
    

document.addEventListener( 'DOMContentLoaded', -> new Popup() )
