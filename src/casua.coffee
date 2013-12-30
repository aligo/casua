###
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
###



_shallowCopy = (src, dst = {}) ->
  dst[key] = value for key, value of src
  dst

casua = {}

class casua.Node
  _addNodes = (_node, elements) ->
    if elements.nodeName
      elements = [elements]
    for element in elements
      _push _node, element

  _push = (_node, one) ->
    _node[_node.length] = one
    _node.length += 1

  _forEach = (_node, callback) ->
    ret = for one, idx in _node
      callback.call one, idx, one
    ret[0]
      
  __addEventListenerFn = if window.document.addEventListener
    (element, type, fn) -> element.addEventListener type, fn, false
  else
    (element, type, fn) -> element.attachEvent 'on' + type, fn
  # __removeEventListenerFn = if window.document.removeEventListener
  #   (element, type, fn) -> element.removeEventListener type, fn, false
  # else
  #   (element, type, fn) -> element.detachEvent 'on' + type, fn

  __createEventHanlder = (element, events) ->
    ret = (event, type) ->
      event.preventDefault ||= -> event.returnValue = false
      event.stopPropagation ||= -> event.cancelBubble = true
      event.target ||= event.srcElement || document
      unless event.defaultPrevented?
        prevent = event.preventDefault
        event.preventDefault = ->
          event.defaultPrevented = true
          prevent.call event
        event.defaultPrevented = false
      event.isDefaultPrevented = -> ( event.defaultPrevented ) ||  ( event.returnValue == false )
      eventFns = _shallowCopy( events[type || event.type] || [])
      fn.call element, event for i, fn of eventFns
      delete event.preventDefault
      delete event.stopPropagation
      delete event.isDefaultPrevented
    ret.elem = element
    ret.handleds = []
    ret

  constructor: (node_meta) ->
    @handlers = {}
    @events = {}
    @length = 0
    if node_meta instanceof casua.Node
      return node_meta
    else if typeof node_meta is 'string'
      if node_meta.charAt(0) != '<'
        attrs_data = node_meta.split ' '
        tag_data = attrs_data.shift()
        el = document.createElement if r = tag_data.match(/^([^\.^#]+)/)
          r[1]
        else
          'div'
        if r = tag_data.match /\.([^\.^#]+)/g
          el.className = r.join(' ').replace /\./g, ''
        if r = tag_data.match /#([^\.^#]+)/
          el.id = r[1]
        _addNodes @, el
      for attr in attrs_data
        if r = attr.match /^([^=]+)(?:=(['"])(.+?)\2)?$/
          @attr r[1], ( r[3] || '' )
    else if node_meta.nodeName
      _addNodes @, node_meta

  attr: (name, value) ->
    ret = _forEach @, ->
      name = name.toLowerCase()
      if value?
        @setAttribute name, value
      else
        @getAttribute name, 2
    if value?
      @
    else
      ret
    
  append: (node) ->
    _forEach @, (i, parent) -> _forEach node, (j, child) -> parent.appendChild child
    @

  empty: ->
    _node = @
    _forEach @, ->
      while @firstChild
        @removeChild @firstChild
    @

  on: (type, fn) ->
    @events[type] ||= []
    @events[type].push fn
    _forEach @, (idx) ->
      handler = _node.handlers[idx] ||= __createEventHanlder @, _node.events
      handleds = handler.handleds
      if handleds.indexOf(type) == -1
        __addEventListenerFn @, type, handler
        handleds.push type

  trigger: (type, event_data = {}) ->
    _forEach @, ->
      event = document.createEvent 'HTMLEvents'
      event.initEvent type, true, true
      event[key] = value for key, value of event_data
      @dispatchEvent event

class casua.Model

  _props_blacklist = /^(?:length)$/

  _models = []

  _watchLoop = -> _watchModel _model for _model, i in _models

  _watchModel = (_model) ->
    #watch old prop
    for prop, i in _model._props
      if _model[prop]?
        __watchProp _model, prop
      else
        delete _models._olds[prop]
        _models.props.splice i, 1
    __forProps _model

  __forProps = (_model, init_data) ->
    init_data ||= _model
    if init_data.length
      _model.length = init_data.length
      for value, prop in init_data
        prop = prop.toString()
        __initProp _model, prop, value
    else if typeof _model is 'object'
      __initProp _model, prop, value for prop, value of init_data

  __initProp = (_model, prop, value) ->
    unless prop.charAt(0) == '$' || typeof value is 'function' || _model._props.indexOf(prop) != -1
      _model._props.push prop
      _model[prop] = value
      __watchProp _model, prop

  __watchProp = (_model, prop) ->
    if _model[prop] != _model._olds[prop]
      if _model._watchs[prop]
        fn.call _model, _model[prop], _model._olds[prop] for fn in _model._watchs[prop]
      _model._olds[prop] = _model[prop]

  setInterval _watchLoop, 50

  constructor: (init_data) ->
    _models.push @
    @_props = []
    @_olds = {}
    @_watchs = {}
    if init_data instanceof casua.Model
      return init_data
    else
      __forProps @, init_data

  $watch: (prop, fn) ->
    @_watchs[prop] ||= []
    @_watchs[prop].push fn

casua.defineController = (fn) ->
  _renderNode = (_controller, _root, template) ->
    for node_meta, child of template
      unless node_meta.charAt(0) == '@'
        node = new casua.Node node_meta
        _root.append node
        if typeof child is 'object'
          _renderNode _controller, node, child
      else
        if r = node_meta.toLowerCase().match(/^@(\w+)(?: (\w+))?$/)
          switch r[1]
            when 'on'
              _root.on r[2], _controller.methods[child]

  class
    constructor: (init_data) ->
      scope = init_data # temporary
      @methods = fn.call @, scope

    render: (template) ->
      fragment = new casua.Node document.createDocumentFragment()
      _renderNode @, fragment, template
      fragment

window.casua = casua