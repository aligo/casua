module 'Scope'
test 'Should can be created', ->
  scope = new casua.Scope
    test: 1
  equal scope.get('test'), 1, 'get()'
  scope.set 'test', 2
  equal scope.get('test'), 2, 'set()'
  scope.remove 'test'
  equal scope.get('test')?, false, 'remove()'

test 'Should can handle mutitple-levels scope', ->
  scope = new casua.Scope
    test: 1
    one: 1
    level2:
      test: 2
      two: 2
    to_remove:
      test: 3
  equal ( scope._childs.indexOf(scope.get('level2')) == -1 ), false, 'parent._childs be seted up'
  equal ( scope.get('level2')._parent == scope ), true, 'child._parent be seted up'

  equal scope.get('test'), 1, 'get 1st level scope'
  equal (scope.get('level2') instanceof casua.Scope), true, 'level2 is a instance of casua.Scope'
  equal scope.get('level2').get('test'), 2, 'get 2st level scope'
  equal scope.get('level2').get('one'), 1, 'resolve to parent scope'
  scope.get('level2').set('one', 'overwrite')
  equal scope.get('level2').get('one'), 'overwrite', 'overwrite current scope'
  equal scope.get('one'), 1, 'but parent is not changed'

  equal scope._childs.length, 2, 'scope has two childs'
  scope.remove('to_remove')
  equal scope._childs.length, 1, 'to_remove has been remove & release'

test 'Should can be created to ArrayScope', ->
  scope = new casua.Scope [1, 2, 3]
  equal (scope instanceof casua.ArrayScope), true, 'is a instance of casua.ArrayScope'
  equal (scope instanceof casua.Scope), true, 'is a instance of casua.Scope'
  equal scope.length(), 3, 'array length()'
  equal scope.get(0), 1, 'array get()'
  scope.set 2, 4
  equal scope.get(2), 4, 'array set()'

  scope.push 'x'
  equal scope.length(), 4, 'array push()'
  equal scope.get(3), 'x', 'array push()'

  equal scope.pop(), 'x', 'array pop()'
  equal scope.length(), 3, 'array pop()'

  scope.remove 0
  equal scope.length(), 2, 'array remove()'
  equal scope.get(0), 2, 'array remove()'
  equal scope.get(1), 4, 'array remove()'

  arr = []
  scope.each (value, idx) ->
    arr[idx] = value

  deepEqual arr, scope._data, 'array each()'

test 'Should can watch', ->
  changed = []
  watch_fn = (n, o, k) -> changed.push [n, o, k]
  scope = new casua.Scope
    test: 1
    test2: 2
    child:
      test: 2
      test3: 3
  scope.$watch 'test', watch_fn
  scope.get('child').$watch 'test', watch_fn
  scope.get('child').$watch 'test2', watch_fn
  scope.$watch '$add', watch_fn
  scope.$watch '$delete', watch_fn
  scope.set 'test', 'changed'
  deepEqual changed.pop(), ['changed', 1, 'test'], 'watch set()'
  equal changed.length, 0, 'child\'s watch can not be triggered when it has same key as parent'

  scope.set 'test2', 'changed1'
  deepEqual changed.pop(), ['changed1', 2, 'test2'], 'child\'s watch can be triggered when it has not key same as parent)'

  scope.set 'new', 'new value'
  deepEqual changed.pop(), ['new value', 'new', '$add'], 'watch $add'

  scope.remove 'new'
  deepEqual changed.pop(), ['new value', 'new', '$delete'], 'watch $delete'

test 'Should can watch ArrayScope', ->
  changed = []
  watch_fn = (n, o, k) -> changed.push [n, o, k]
  scope = new casua.Scope
    arr: [0, 1, 2]
    test: -1
  scope.get('arr').$watch 0, watch_fn
  scope.get('arr').$watch 1, watch_fn
  scope.get('arr').$watch 2, watch_fn
  scope.get('arr').$watch 'test', watch_fn
  scope.get('arr').$watch '$add', watch_fn
  scope.get('arr').$watch '$delete', watch_fn
  scope.get('arr').push 4
  deepEqual changed.pop(), [4, 3, '$add'], 'watch $add'

  scope.get('arr').$watch 3, watch_fn
  scope.get('arr').set 3, 'test'
  deepEqual changed.pop(), ['test', 4, 3], 'watch set()'

  equal scope.get('arr').shift(), 0, 'watch $delete'
  deepEqual changed.pop(), ['test', 2, 2], 'watch $delete'
  deepEqual changed.pop(), [2, 1, 1], 'watch $delete'
  deepEqual changed.pop(), [1, 0, 0], 'watch $delete'
  deepEqual changed.pop(), ['test', 3, '$delete'], 'watch $delete'

  scope.set 'test', 'change'
  deepEqual changed.pop(), ['change', -1, 'test'], 'watch parent'
