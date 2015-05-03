class window.Url
  parser_regexp: /^(.*:\/\/)([^:\/]+)(:[^\/]+)?(.*?)(\?.*?)?(#.*)?$/

  constructor: ( initial ) ->
    initial = window.location.href unless initial
    initial.replace( @parser_regexp, ( match, @_protocol, @_domain, @_port, @_path, @_params, @_anchor ) =>  )
    @protocol = if @_protocol then @_protocol.replace( /:\/\//, '' ) else ''
    @domain = @_domain or ''
    @port = if @_port then @_port.replace( /:/, '' ) else ''
    @path = @_path or ''
    @params = if @_params then @_params.replace( /^\?/, '' ) else ''
    @anchor = if @_anchor then @_anchor.replace( /#/, '' ) else ''


  get_params: ->
    params = {}
    $.each( @params.split( '&' ), ( i, pair ) ->
      pair.replace( /(.*)=(.*)/, ( match, name, value ) -> ( params[ name ] = value ) )
    )

    params


  set_params: ( params ) ->
    @params = ''
    @params = "#{@params}#{name}=#{value}&" for own name, value of params
    @params = @params.replace( /&$/, '' )
    @


  to_s: ->
    port = if @port then ":#{@port}" else ''
    params = if @params then "?#{@params}" else ''
    anchor = if @anchor then "##{@anchor}" else ''
    "#{@protocol}://#{@domain}#{port}#{@path}#{params}#{anchor}"

  relative_path: ->
    params = if @params then "?#{@params}" else ''
    anchor = if @anchor then "##{@anchor}" else ''
    "#{@path}#{params}#{anchor}"

