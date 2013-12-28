###
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
###

$ = jQuery

casua =
  createElement: (element) ->
    if element.charAt(0) != '<'
      attrs_data = element.split ' '
      tag_data = attrs_data.shift()
      el = document.createElement if r = tag_data.match(/^([^\.^#]+)/)
        r[1]
      else
        'div'
      if r = tag_data.match /\.([^\.^#]+)/g
        el.className = r.join(' ').replace /\./g, ''
      if r = tag_data.match /#([^\.^#]+)/
        el.id = r[1]
      $el = $(el)
      for attr in attrs_data
        if r = attr.match /^([^=]+)(?:=(['"])(.+?)\2)?$/
          $el.attr r[1], ( r[3] || '' )
      $el
    else
      $(element)

window.casua = casua