module 'Scope'
test 'Should can be create', ->
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
  