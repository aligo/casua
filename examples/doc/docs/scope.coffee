window.docs_scope =
  id: 'scope'
  title: 'casua.Scope'
  content: 'casua.Scope basically like a js object, has properties that is used to contain data, the difference is that casua.Scope with a pair of get () and set () method to change their properties, so related watch handlers can be fired the scope of what data has been modified in order to update the view.'
  sections: [
    {
      id: 'constructor'
      title: 'constructor / initialize'
      content: """
      `new casua.Scope(init_data, [parent])`

       - `init_data` *[ Object ]* initial data
       - `parent` *[ casua.Scope ]* parent scope attached to this new scope
       - Returns a *[ casua.Scope ]*
      """
    }
    {
      id: 'get'
      title: 'get'
      content: """
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
      """
    }
    {
      id: 'set'
      title: 'set'
      content: """
      `scope.set(key, value)`

       - `key` *[ String ]* supports same format as get()
       - `value` *[ Any / casua.Scope ]*
       - Returns `scope` itself
      """
    }
    {
      id: 'remove'
      title: 'remove'
      content: """
      `scope.remove(key)` remove the property

       - `key` *[ String ]* supports same format as get()
       - Returns `scope` itself
      """
    }
    {
      id: 'watch'
      title: '$watch'
      content: """
      `scope.$watch(key, handler)` attach a watch handler 

       - `key` *[ String ]* supports same format as get()
       - `handler` *[ Function ]*
       - Returns `scope` itself
      """
    }
    {
      id: 'handlers'
      title: 'Watch Handlers'
      content: """
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
      """
    }
  ]

window.docs_arrayscope =
  id: 'arrayscope'
  title: 'casua.ArrayScope'
  content: """
  ArrayScope is a special scope wrapped Array. It also have get() set() remove() and watch(), which exist and can be used like in Scope.

  ArrayScope also provides following methods:
  """
  sections: [
    {
      id: 'length'
      title: 'length'
      content: """
      `scope.length()` get the length of array

       - Returns *[ Integer ]*
      """
    }
    {
      id: 'each'
      title: 'each'
      content: """
      `scope.each(fn)` iterates over array

       - `fn` *[ Function ]* Each invocation of iterator is called it with two arguments: `(element, index)`, and context `this` is the ArrayScope itself.
       - `handler` *[ Function ]*
       - Returns `scope` itself
      """
    }
    {
      id: 'indexOf'
      title: 'indexOf'
      content: """
      `scope.indexOf(element)`

       - `element` *[ Any / casua.Scope ]*
       - Returns *[ Integer ]* position of element in array, if element not exist, returns -1
      """
    }
    {
      id: 'pop'
      title: 'pop'
      content: """
      `scope.pop()` removes last element of array, returns that element

       - Returns *[ Any / casua.Scope ]*
      """
    }
    {
      id: 'push'
      title: 'push'
      content: """
      `scope.push(element1, element2, ..., elementX)`

       - `element` *[ Any / casua.Scope ]* adds new items to the end of an array, returns new length.
       - Returns *[ Integer ]*
      """
    }
    {
      id: 'reverse'
      title: 'reverse'
      content: """
      `scope.reverse()` reverses the order of the elements in array

       - Returns `scope` itself
      """
    }
    {
      id: 'shift'
      title: 'shift'
      content: """
      `scope.shift()` removes first element of array, returns that element

       - Returns *[ Any / casua.Scope ]*
      """
    }
    {
      id: 'sort'
      title: 'sort'
      content: """
      `scope.sort(fn)`

       - `fn` *[ Function ]* called with arguments: `(a, b)`, and `a` and `b` will be sorted ascending or descending, based on numbers `fn` return.
       - Returns *[ Any / casua.Scope ]*
      """
    }
    {
      id: 'unshift'
      title: 'unshift'
      content: """
      `scope.unshift(element1, element2, ..., elementX)`

       - `element` *[ Any / casua.Scope ]* adds new items to the beginning of an array, returns new length.
       - Returns *[ Integer ]*
      """
    }
    {
      id: 'filter'
      title: 'filter'
      content: """
      `scope.filter(fn)` looks through each element in array, keep only elements that pass a truth test (`fn` return).

       - `fn` *[ Function ]* called it with two arguments: `(element, index)`, and context `this` is the ArrayScope itself.
       - Returns `scope` itself
      """
    }
  ]