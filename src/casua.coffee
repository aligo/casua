###
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
###

casua = {}

class casua.Element
  constructor: (element) ->
    if element instanceof Element
      element
    else if typeof element is 'string'
      if element.charAt(0) != '<'
        tag_data = element.split ' '
        @[0] = document.createElement if r = tag_data[0].match(/^([^\.^#]+)/)
          r[1]
        else
          'div'
        if r = tag_data[0].match(/\.([^\.^#]+)/g)
          @[0].className = r.join(' ').replace /\./g, ''
        if r = tag_data[0].match(/#([^\.^#]+)/)
          @[0].id = r[1]

window.casua = casua