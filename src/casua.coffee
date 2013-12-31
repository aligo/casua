###
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
###



_shallowCopy = (src, dst = {}) ->
  dst[key] = value for key, value of src
  dst

_escape_chars = { lt: '<', gt: '>', quot: '"', amp: '&', apos: "'" }
_reversed_escape_chars = {}
_reversed_escape_chars[v] = k for k, v of _escape_chars 
_escapeHTML = (str) ->
  str.replace /[&<>"']/g, (m) ->
    '&' + _reversed_escape_chars[m] + ';'

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
      else
        div = document.createElement 'div'
        div.innerHTML = '<div>&#160;</div>' + node_meta
        div.removeChild div.firstChild
        for child in div.childNodes
          _addNodes @, child
    else if node_meta.nodeName
      _addNodes @, node_meta

  attr: (name, value) ->
    name = name.toLowerCase()
    if value?
      _forEach @, -> @setAttribute name, value
      @
    else
      @[0].getAttribute name, 2
    
  append: (node) ->
    node = new casua.Node node if typeof node is 'string'
    _forEach @, (i, parent) -> _forEach node, (j, child) -> parent.appendChild child
    @

  empty: ->
    _forEach @, ->
      while @firstChild
        @removeChild @firstChild
    @

  html: (value) ->
    if value?
      @empty()
      _forEach @, -> @innerHTML = value
      @
    else
      @[0].innerHTML

  text: (value) ->
    if value?
      @html _escapeHTML(value)
    else
      @html()

  on: (type, fn) ->
    _node = @
    @events[type] ||= []
    @events[type].push fn
    _forEach @, (idx) ->
      handler = _node.handlers[idx] ||= __createEventHanlder @, _node.events
      handleds = handler.handleds
      if handleds.indexOf(type) == -1
        __addEventListenerFn @, type, handler
        handleds.push type
    @

  trigger: (type, event_data = {}) ->
    _forEach @, ->
      event = document.createEvent 'HTMLEvents'
      event.initEvent type, true, true
      event[key] = value for key, value of event_data
      @dispatchEvent event
    @

class casua.Model

  _models = []

  _watchLoop = -> _watchModel _model for _model, i in _models

  _watchModel = (_model) ->
    for prop, i in _model._props
      if _model[prop]?
        __watchProp _model, prop
      else
        __callWatchs _model, '$delete', prop, _model._olds[prop]
        delete _model._olds[prop]
        _model._props.splice i, 1
    __forProps _model

  __forProps = (_model, init_data) ->
    init_data ||= _model
    if init_data.length
      for value, prop in init_data
        prop = prop.toString()
        __initProp _model, prop, value
    else if typeof _model is 'object'
      __initProp _model, prop, value for prop, value of init_data

  __initProp = (_model, prop, value) ->
    unless prop.charAt(0) == '_' || typeof value is 'function' || _model._props.indexOf(prop) != -1 || _model._props_blacklist.indexOf(prop) != -1
      if typeof value is 'object'
        value = new casua.Model value
      _model._props.push prop
      _model[prop] = value
      __callWatchs _model, '$add', prop, value
      __watchProp _model, prop

  __watchProp = (_model, prop) ->
    if _model[prop] != _model._olds[prop]
      __callWatchs _model, prop, _model[prop], _model._olds[prop]
      _model._olds[prop] = _model[prop]

  __callWatchs = (_model, prop, new_val, old_val) ->
    if _model._watchs[prop]
      fn.call _model, new_val, old_val for fn in _model._watchs[prop]

  _arrayMethods = ['pop', 'push', 'reverse', 'shift', 'sort', 'slice', 'unshift']
  __defineArrayMethods = (_model) ->
    for method in _arrayMethods
      ( (method) ->
        _model[method] = ->
          _array = for one in _model
            one
          ret = _array[method].apply _array, arguments
          i = 0
          _model[i] = one for one, i in _array
          if i < _model.length
            delete _model[j] for j in [i..(_model.length - 1)]
          _model.length = _array.length
          _watchModel _model
          ret
      )(method)

  setInterval _watchLoop, 50

  constructor: (init_data) ->
    _models.push @
    @_props = []
    @_olds = {}
    @_watchs = {}
    @_props_blacklist = []
    if init_data instanceof casua.Model
      return init_data
    else
      if init_data.length
        @length = init_data.length
        @_props_blacklist = _arrayMethods
        __defineArrayMethods @
        __initProp @, 'length', @length
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