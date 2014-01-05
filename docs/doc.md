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
   - Returns `node` self
 
### attr
  `node.attr(name)` get attribute value
   - `name` *[ String ]* attribute name
   - Returns attribute value

  `node.attr(name, value)` set attribute value
   - `name` *[ String ]* attribute name
   - `value` *[ Any ]* attribute value
   - Returns `node` self

### empty
  `node.empty()`
  Remove all child nodes
   - Returns `node` self

### find
  `node.find(query)`
   - `query` *[ String ]* CSS3 Selector's querying if broswer supports, looking-up by tag name if not
   - Returns `casua.Node` found node(s)

### html
  `node.html()` get the HTML content
   - Returns the HTML

  `node.html(html)` set the HTML content
   - `html` *[ String ]* the HTML to set
   - Returns `node` self

### on
  `node.on(type, handler)` attach an event handler 
   - `type` *[ String ]* event type, such as "click", "dblclick", "focus"
   - `handler` *[ Function ]*
   - Returns `node` self

### parent
  `node.parent()`
   - Returns the parent of node if exists

### replaceWith
  `node.replaceWith(content)` replace this node with the content
   - `content` *[ String / casua.Node / Dom Element ]*
   - Returns `node` self

### text
  `node.text()` get the text content
   - Returns the text
   
  `node.text(text)` set the text content
   - `text` *[ String ]* the text to set
   - Returns `node` self

### val
  `node.val()` get the value
   - Returns attribute value

  `node.val(value)` set the value
   - `value` *[ Any ]* the value to set
   - Returns `node` self

---


## casua.Scope
casua.Scope basically like a js object, has attributes that is used to contain data, the difference is that casua.Scope with a pair of get () and set () method to change their attributes, so related watch handlers can be fired the scope of what data has been modified in order to update the view.

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

