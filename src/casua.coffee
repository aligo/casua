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

_scopeInitParent = (_scope, _parent) ->
  _scope._childs = []
  if _parent?
    _parent._childs.push _scope if _parent._childs.indexOf(_scope) == -1
    _scope._parent = _parent

_scopeRemovePrepare = (_scope, key) ->
  if _scope._data[key] instanceof casua.Scope
    s = _scope._data[key]
    if s._parent?
      i = s._parent._childs.indexOf s
      s._parent._childs.splice i, 1
  _scopeCallWatch _scope, _scope._data[key], key, '$delete', false

_scopeCallWatch = (_scope, new_val, old_val, key, to_childs = true) ->
  if _scope._watchs[key]
    fn.call _scope, new_val, old_val, key for fn in _scope._watchs[key]
  if to_childs
    for child in _scope._childs
      unless child._data[key]?
        _scopeCallWatch child, new_val, old_val, key

class casua.Scope

  constructor: (init_data, parent) ->
    if init_data instanceof casua.Scope
      return init_data
    else if init_data.length?
      return new casua.ArrayScope init_data, parent
    else
      _scopeInitParent @, parent
      @_watchs = {}
      @_data = {}
      @set key, value for key, value of init_data

  get: (key) ->
    ret = @_data[key]
    ret = @_parent.get(key) if !ret? && @_parent?
    ret

  set: (key, value) ->
    unless typeof key is 'string' && key.charAt(0) == '$'
      if typeof value is 'object'
        value = new casua.Scope value, @
      if @_data[key] != value
        old = @_data[key]
        @_data[key] = value
        unless old?
          _scopeCallWatch @, value, key, '$add', false
        _scopeCallWatch @, value, old, key

  remove: (key) ->
    _scopeRemovePrepare @, key
    delete @_data[key]

  $watch: (key, fn) ->
    @_watchs[key] ||= []
    @_watchs[key].push fn

class casua.ArrayScope extends casua.Scope

  for method in ['pop', 'push', 'reverse', 'shift', 'sort', 'slice', 'unshift']
    ( (method) ->
      ArrayScope.prototype[method] = ->
        _array = for one in @_data
          one
        ret = _array[method].apply _array, arguments
        while _array.length < @_data.length
          @remove( @_data.length - 1 )
        idx = 0
        @set idx, value for value, idx in _array
        ret
    )(method)

  constructor: (init_data, parent) ->
    if init_data instanceof casua.Scope
      return init_data
    else if not init_data.length?
      return new casua.Scope init_data, parent
    else
      _scopeInitParent @, parent
      @_watchs = {}
      @_data = []
      @set idx, value for value, idx in init_data

  length: -> @_data.length

  remove: (key) ->
    _scopeRemovePrepare @, key
    @_data.splice key, 1

  each: (fn) ->
    for one, i in @_data
      fn.call @, one, i
     
casua.defineController = (fn) ->

  _renderNode = (_controller, _scope, _root, template) ->
    if _scope instanceof casua.ArrayScope
      _renderNodes _controller, _scope, _root, template
    else
      for node_meta, child of template
        unless node_meta.charAt(0) == '@'
          node = new casua.Node node_meta
          _root.append node
          if typeof child is 'object'
            _renderNode _controller, _scope, node, child
          else
            __nodeBind node, 'text', _scope, child
          node
        else
          if r = node_meta.toLowerCase().match(/^@(\w+)(?: (\S+))?$/)
            switch r[1]
              when 'on'
                _root.on r[2], _controller.methods[child]
              when 'html', 'text'
                __nodeBind _root, r[1], _scope, child
              when 'child'
                _renderNode _controller, _scope.get(r[2]), _root, child

  _renderNodes = (_controller, _scope, _root, template) ->
    add_fn = _generateNodesAddFn _controller, _root, template
    _scope.$watch '$add', add_fn
    _scope.each (one) -> add_fn.call {}, one

  _generateNodesAddFn = (_controller, _root, template) ->
    (new_scope) ->
      _renderNode _controller, new_scope, _root, template

  __nodeBind = (_node, _method, _scope, src) ->
    __computeBind _scope, src, (result) ->
      _node[_method].call _node, result

  __compute_match_regexp = /\{\{([\S^\}]+)\}\}/g
  __compute_match_key_regexp = /^\{\{([\S^\}]+)\}\}$/

  __computeBind = (_scope, src, fn) ->
    keys_to_watch = []
    watch_fn = if r = src.match(/^@(\S+)$/)
      key = r[1]
      keys_to_watch.push key
      -> fn.call {}, @get(key)
    else if r = src.match __compute_match_regexp
      for part in r
        part = part.match __compute_match_key_regexp
        keys_to_watch.push part[1]
      ->
        scope = @
        fn.call {}, src.replace __compute_match_regexp, (part) ->
          part = part.match __compute_match_key_regexp
          scope.get part[1]
    else
      -> fn.call {}, src
    for key in keys_to_watch
      _scope.$watch key, watch_fn
    watch_fn.call _scope

  class
    constructor: (init_data) ->
      @scope = new casua.Scope init_data
      @methods = fn.call @, @scope, @

    render: (template) ->
      fragment = new casua.Node document.createDocumentFragment()
      _renderNode @, @scope, fragment, template
      fragment

window.casua = casua