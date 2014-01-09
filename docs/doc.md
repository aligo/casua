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
 
### trigger
`node.trigger(type, event_data)` execute all handlers with given event type
 - `type` *[ String ]* event type, such as "click", "dblclick", "focus"
 - `event_data` *[ Object ]* additonal parameters to pass along to the event handler, such as `{'custom':'value'}`
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

Using `$parent` in key, can resolve to parent of current scope (if exist).

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

## casua.ArrayScope
ArrayScope is a special scope wrapped Array. It also have get() set() remove() and watch(), which exist and can be used like in Scope.

ArrayScope also provides following methods:

### length
`scope.length()` get the length of array
 - Returns *[ Integer ]*

### each
`scope.each(fn)` iterates over array
 - `fn` *[ Function ]* Each invocation of iterator is called it with two arguments: `(element, index)`, and context `this` is the ArrayScope itself.
 - `handler` *[ Function ]*
 - Returns `scope` itself

### indexOf
`scope.indexOf(element)`
 - `element` *[ Any / casua.Scope ]*
 - Returns *[ Integer ]* position of element in array, if element not exist, returns -1

### pop
`scope.pop()` removes last element of array, returns that element
 - Returns *[ Any / casua.Scope ]*

### push
`scope.push(element1, element2, ..., elementX)`
 - `element` *[ Any / casua.Scope ]* adds new items to the end of an array, returns new length.
 - Returns *[ Integer ]*

### reverse
`scope.reverse()` reverses the order of the elements in array
 - Returns `scope` itself

### shift
`scope.shift()` removes first element of array, returns that element
 - Returns *[ Any / casua.Scope ]*

### sort
`scope.sort(fn)`
 - `fn` *[ Function ]* called with arguments: `(a, b)`, and `a` and `b` will be sorted ascending or descending, based on numbers `fn` return.
 - Returns *[ Any / casua.Scope ]*

### unshift
`scope.unshift(element1, element2, ..., elementX)`
 - `element` *[ Any / casua.Scope ]* adds new items to the beginning of an array, returns new length.
 - Returns *[ Integer ]*

### filter
`scope.filter(fn)` looks through each element in array, keep only elements that pass a truth test (`fn` return).
 - `fn` *[ Function ]* called it with two arguments: `(element, index)`, and context `this` is the ArrayScope itself.
 - Returns `scope` itself

### Watch Handlers
In addition to normal Scope watches and `$add`, `$delete`, ArrayScope also provides `$move` watch, used to track the position changes of element of array.

```
scope.$watch('$move', handler)
```
When the changes happended, handler will be invoked with passed three parameters:

```
(pos, null, '$move')
```
 - pos *[ Array ]* its index refers to the original position of element, and its value refers to new position, such as `[ 2, 1, 0 ]`, means that array has been reversed, first element is moved to position 2, which is last, and second still in position 1, and last gone to the 0, became first.


---

## Controller

The controller in casua, are behind the DOM elements, used to response the user interaction and update the result to the view. Todo that, a controller should have some methods, which can binded as event handler of DOM element, or as computed value to html, attrbutes or condition of DOM el ement.

### To define a controller

```javascript
exampleController = casua.defineController( function (scope) {
  /* Constructor 
   * This constructor function will be called when everytime the controller be instantiated.
   * Over here, You can initialize data to scope, such as loading data from backend api.
   */
  scope.set('amount', 10);
  return {
    /* Returns Methods
     * Everytime controller is invoked, should return a object, which contained some methods like following, to bind with view.
     */
    computedAmount: function () {
      // Return a computed value
      return scope.get('amount') + 100;
    },
    onClickClearAmount: function (event) {
      // Binded as a onclick event handler, argument event passed in is a DOM Event.
      scope.set('amount', 0);
    }
  };
} );

```

In fact, casua is designed to be used together with coffeescript, the code above in coffeescript will be more simple and clear, like:

```coffeescript
exampleController = casua.defineController (scope) ->
  scope.set('amount', 10)

  computedAmount: -> scope.get('amount') + 100 
  onClickClearAmount: (e) -> scope.set('amount', 0)

```

### New Controller

After you defined prototype of controller, you can use `new` opreator to get a instance of the controller.

`instance = new exampleController(init_data, parent_controller)`
 - `init_data` *[ Object / casua.Scope ]* all passed in `init_data` will be converted to casua.Scope, and can be accessed by `scope` in controller
 - `parent_controller` Optional, parent of current controller

### render() / renderAt()

Once you get a instance of controller, contained the scope of data, you can render the view with the template to DOM element.

`instance.renderAt(container, template)`

The `container` here, can be a casua.Node, DOM element, or even a jQuery object.

`node = instance.render(template)`

Return a div node, which as container of the view, for you can insert it to anywhere later.

### Context in method

Within method is invoked, is a context, you can use `this` or `@` (in coffeescript) to access.

```coffeescript
controllerPrototype = casua.defineController (scope) ->

  accessContextExample: -> 
    @ or this # the context
    this.anotherMethod() # call another method in controller
    this.$parent # refers to parent controller is exist
    this.$parent.someMethod() # call the method in parent controller
    this.$node() # get the current node that this `accessContextExample` is binded to
    this.$node('$root') # get the named node `$root`, which default is root node of controller
    this.$node('.name') # <=> this.$node().find('.name')

    this.$parent.$node() # can NOT do that, access parent nodes

  anotherMethod: ->
    console.log 'called'
```

### Example

```coffeescript
exampleController = casua.defineController (scope) ->
  scope.set 'was_or_not', 'was not'
  onClick: -> scope.set 'was_or_not', 'was'

app_node = new casua.Node document.getElementById('app')

template =
  'div':
    '@on click': 'onClick()'
    '@text': 'this {{@was_or_not}} clicked'

new exampleController().renderAt app_node, template

```
