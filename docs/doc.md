## casua.Node
casua.Node is a wrapping to basic HTML DOM element, provides some jQuery-like methods, and compatible with jQuery.

### constructor / initialize  
`new casua.Node(element)`
 - `element` *[ String / casua.Node / Dom Element ]* 
 - Returns a *[ casua.Node ]* wrapping to `element`

examples :
```coffeescript
new casua.Node('.a-div')
# => <div class="a-div"></div>

new casua.Node('p.p-1#p-id.p-2')
# => <p id="p-id" class="p-1 p-2"></p>'

new casua.Node('a href="/?a=b" target="_blank" disabled')
# => <a disabled="disabled" target="_blank" href="/?a=b"></a>

new casua.Node('<div></div>')
# => <div></div>

new casua.Node(document.createElement('div'))
# => <div></div>
  ```

### append
`node.append(content)` append content to the end of node
 - `content` *[ String / casua.Node / Dom Element ]*
 - Returns `node` itself
 
### attr
`node.attr(name)` get attribute value
 - `name` *[ String ]* attribute name
 - Returns attribute value

`node.attr(name, value)` set attribute value
 - `name` *[ String ]* attribute name
 - `value` *[ Any ]* attribute value
 - Returns `node` itself

### empty
`node.empty()`
Remove all child nodes
 - Returns `node` itself

### find
`node.find(query)`
 - `query` *[ String ]* CSS3 Selector's querying if broswer supports, looking-up by tag name if not
 - Returns `casua.Node` found node(s)

### html
`node.html()` get the HTML content
 - Returns the HTML

`node.html(html)` set the HTML content
 - `html` *[ String ]* the HTML to set
 - Returns `node` itself

### on
`node.on(type, handler)` attach an event handler 
 - `type` *[ String ]* event type, such as "click", "dblclick", "focus"
 - `handler` *[ Function ]*
 - Returns `node` itself

### parent
`node.parent()`
 - Returns the parent of node if exists

### replaceWith
`node.replaceWith(content)` replace this node with the content
 - `content` *[ String / casua.Node / Dom Element ]*
 - Returns `node` itself

### text
`node.text()` get the text content
 - Returns the text
 
`node.text(text)` set the text content
 - `text` *[ String ]* the text to set
 - Returns `node` itself

### val
`node.val()` get the value
 - Returns attribute value

`node.val(value)` set the value
 - `value` *[ Any ]* the value to set
 - Returns `node` itself

---


## casua.Scope
casua.Scope basically like a js object, has properties that is used to contain data, the difference is that casua.Scope with a pair of get () and set () method to change their properties, so related watch handlers can be fired the scope of what data has been modified in order to update the view.

### constructor / initialize  
`new casua.Scope(init_data, [parent])`
 - `init_data` *[ Object ]* initial data
 - `parent` *[ casua.Scope ]* parent scope attached to this new scope
 - Returns a *[ casua.Scope ]*

### get
`scope.get(key)`
 - `key` *[ String ]*
 - Returns *[ Any / casua.Scope ]*

examples:
```coffeescript
scope = new casua.Scope {
  name: 'Joe'
  age: 35
  job: {
    company: 'cool'
    title: 'coder'
  }
}
scope.get('name') # => 'Joe'
scope.get('job') # => *[ casua.Scope ]*
scope.get('job').get('company') # => 'cool'
scope.get('job.title') # => 'coder'
job_scope = scope.get('job')
job_scope.get('$parent') # => *[ casua.Scope ]* back to scope
job_scope.get('$parent.age') # => 35
scope.get('$parent.job.company') # => 'cool'
```

### set
`scope.set(key, value)`
 - `key` *[ String ]* supports same format as get()
 - `value` *[ Any / casua.Scope ]*
 - Returns `scope` itself

### remove
`scope.remove(key)` remove the property
 - `key` *[ String ]* supports same format as get()
 - Returns `scope` itself

### $watch
`scope.$watch(key, handler)` attach a watch handler 
 - `key` *[ String ]* supports same format as get()
 - `handler` *[ Function ]*
 - Returns `scope` itself

### Watch Handlers
When scope changes, watch handlers attached to the changed property will be invoked, with passed three parameters:
`( new_val, old_val, key )`
 - `new_val` the new value after change
 - `old_val` the old value before change
 - `key` the changed property key

In addition casua.Scope also supports two special handlers:

```
scope.$watch('$add', handler)
scope.$watch('$delete', handler)
```

They will fired when adding new property to scope or deleting property from scope.

Three parameters passed will become:
`(val, key, '$add')` and `(val, key, '$delete')`

