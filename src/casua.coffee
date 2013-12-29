###
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
###
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
    ret = for one in _node
      callback.apply one, [one]
    ret[0]

  length: 0
  constructor: (node_meta) ->
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
    _forEach @, (parent) -> _forEach node, (child) -> parent.appendChild child
    @

  empty: ->
    _forEach @, ->
      while @firstChild
        @removeChild @firstChild
    @

casua.defineController = (methods) ->
    _renderNode = (_root, template) ->
      for node_meta, child of template
        if node_meta.charAt(0) != '@'
          node = new casua.Node node_meta
          _root.append node
          if typeof child is 'object'
            _renderNode node, child

    class
      constructor: (init_data) ->

      render: (template) ->
        fragment = new casua.Node document.createDocumentFragment()
        _renderNode fragment, template
        fragment



window.casua = casua