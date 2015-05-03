class Background.PageActionDecider
  constructor: ( @tab ) -> @api = new Background.Api

  # Decide whether to show page action or not
  decide: -> if @is_product_url() then @show_page_action() else @hide_page_action()


  # Tell if we're on a product page
  is_product_url: -> @tab.url.match /^https:\/\/www.producthunt.com\/posts\//

  # Ensure we have api access
  check_authorization: ->
    @api.is_authorized( ( authorized ) => if authorized then @check_collection_count() else @show_page_action() )


  show_page_action: -> chrome.pageAction.show @tab.id

  hide_page_action: ->
    chrome.pageAction.hide @tab.id
    chrome.storage.sync.set( collections: [] )
    

