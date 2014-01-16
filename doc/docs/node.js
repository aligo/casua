// Generated by CoffeeScript 1.6.3
(function() {
  window.docs_node = {
    id: 'node',
    title: 'casua.Node',
    content: 'casua.Node is a wrapping to basic HTML DOM element, provides some jQuery-like methods, and compatible with jQuery.',
    sections: [
      {
        id: 'constructor',
        title: 'constructor / initialize',
        content: "`new casua.Node(element)`\n\n - `element` *[ String / casua.Node / Dom Element ]* \n - Returns a *[ casua.Node ]* wrapping to `element`\n\nexamples :\n\n```coffeescript\nnew casua.Node('.a-div')\n# => <div class=\"a-div\"></div>\n\nnew casua.Node('p.p-1#p-id.p-2')\n# => <p id=\"p-id\" class=\"p-1 p-2\"></p>'\n\nnew casua.Node('a href=\"/?a=b\" target=\"_blank\" disabled')\n# => <a disabled=\"disabled\" target=\"_blank\" href=\"/?a=b\"></a>\n\nnew casua.Node('<div></div>')\n# => <div></div>\n\nnew casua.Node(document.createElement('div'))\n# => <div></div>\n```"
      }, {
        id: 'append',
        title: 'append',
        content: "`node.append(content)` append content to the end of node\n\n - `content` *[ String / casua.Node / Dom Element ]*\n - Returns `node` itself"
      }, {
        id: 'attr',
        title: 'attr',
        content: "`node.attr(name)` get attribute value\n\n - `name` *[ String ]* attribute name\n - Returns attribute value\n\n`node.attr(name, value)` set attribute value\n\n - `name` *[ String ]* attribute name\n - `value` *[ Any ]* attribute value\n - Returns `node` itself"
      }, {
        id: 'empty',
        title: 'empty',
        content: "`node.empty()`\nRemove all child nodes\n\n - Returns `node` itself"
      }, {
        id: 'find',
        title: 'find',
        content: "`node.find(query)`\n\n - `query` *[ String ]* CSS3 Selector's querying if broswer supports, looking-up by tag name if not\n - Returns `casua.Node` found node(s)"
      }, {
        id: 'html',
        title: 'html',
        content: "`node.html()` get the HTML content\n\n - Returns the HTML\n\n`node.html(html)` set the HTML content\n\n - `html` *[ String ]* the HTML to set\n - Returns `node` itself"
      }, {
        id: 'on',
        title: 'on',
        content: "`node.on(type, handler)` attach an event handler \n\n - `type` *[ String ]* event type, such as \"click\", \"dblclick\", \"focus\"\n - `handler` *[ Function ]*\n - Returns `node` itself"
      }, {
        id: 'parent',
        title: 'parent',
        content: "`node.parent()`\n\n - Returns the parent of node if exists"
      }, {
        id: 'replaceWith',
        title: 'replaceWith',
        content: "`node.replaceWith(content)` replace this node with the content\n\n - `content` *[ String / casua.Node / Dom Element ]*\n - Returns `node` itself"
      }, {
        id: 'text',
        title: 'text',
        content: "`node.text()` get the text content\n\n - Returns the text\n \n`node.text(text)` set the text content\n\n - `text` *[ String ]* the text to set\n - Returns `node` itself"
      }, {
        id: 'trigger',
        title: 'trigger',
        content: "`node.trigger(type, event_data)` execute all handlers with given event type\n\n - `type` *[ String ]* event type, such as \"click\", \"dblclick\", \"focus\"\n - `event_data` *[ Object ]* additonal parameters to pass along to the event handler, such as `{'custom':'value'}`\n - Returns `node` itself"
      }, {
        id: 'val',
        title: 'val',
        content: "`node.val()` get the value\n\n - Returns attribute value\n\n`node.val(value)` set the value\n\n - `value` *[ Any ]* the value to set\n - Returns `node` itself}\n  ]"
      }
    ]
  };

}).call(this);