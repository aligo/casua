_test = window._test

module 'Controller'
test 'defineController', ->
  container = new casua.Node ''
  testController = casua.defineController ->
  testCtrlInst = new testController {}
  testCtrlInst.renderAt container,
    '.test':
      '.test2': '<test3>'
  equal container[0].innerHTML, '<div class="test"><div class="test2">&lt;test3&gt;</div></div>', 'ok'

test 'array scope', ->
  container = new casua.Node 'ul'
  testController = casua.defineController ->
  testCtrlInst = new testController [
    { title: 'one' }
    { title: 'two' }
  ]
  array = testCtrlInst.scope
  testCtrlInst.renderAt container,
    'li':
      'span': '@title'

  equal container.html(), '<li><span>one</span></li><li><span>two</span></li>', 'render'  
  array.push { title: 'three' }
  equal container.html(), '<li><span>one</span></li><li><span>two</span></li><li><span>three</span></li>', 'watch $add'
  array.shift()
  equal container.html(), '<li><span>two</span></li><li><span>three</span></li>', 'watch $delete'
  array.unshift
    title: 'one'
  equal container.html(), '<li><span>one</span></li><li><span>two</span></li><li><span>three</span></li>', 'watch $move'

test 'CST @on', ->
  clicked = 0
  testController = casua.defineController ->
    clickOne: -> 
      clicked = 1
    clickTwo: -> 
      clicked += 5
  testCtrlInst = new testController {}
  fragment1 = testCtrlInst.render
    'a':
      '@on click': 'clickOne'
  _test._trigger fragment1[0].children[0], 'click'
  equal clicked, 1, '@on click: clickOne'

  fragment2 = testCtrlInst.render
    'a':
      '@on click': 'clickOne'
      '@on click': 'clickTwo'
  _test._trigger fragment2[0].children[0], 'click'
  equal clicked, 6, '@on click: clickTwo'

  _test._trigger fragment1[0].children[0], 'click'
  equal clicked, 1, '@on click: clickOne'

test 'CST @html', ->
  testController = casua.defineController (scope) ->
    computeMethod: ->
      scope.get('test') + ' computed'

  testCtrlInst = new testController
    test: 'scope value'
    test2: 'is good'
  fragment1 = testCtrlInst.render
    'h1':
      '@html': 'pure html'
  equal fragment1[0].children[0].innerHTML, 'pure html', 'pure html'
  fragment2 = testCtrlInst.render
    'h1':
      '@html': '@test'
  equal fragment2[0].children[0].innerHTML, 'scope value', 'single binding'

  fragment3 = testCtrlInst.render
    'h1':
      '@html': '{{test}} {{test2}}.'
  equal fragment3[0].children[0].innerHTML, 'scope value is good.', 'computed binding'

  fragment4 = testCtrlInst.render
    'h1':
      '@html': '@computeMethod()'
  equal fragment4[0].children[0].innerHTML, 'scope value computed', 'compute method binding'

  scope = testCtrlInst.scope
  scope.set 'test', 'changed'

  equal fragment2[0].children[0].innerHTML, 'changed', 'scope value changed 1'
  equal fragment3[0].children[0].innerHTML, 'changed is good.', 'scope value changed 2'
  equal fragment4[0].children[0].innerHTML, 'changed computed', 'changed compute method'

  scope.set 'test2', 'is better'
  equal fragment3[0].children[0].innerHTML, 'changed is better.', 'scope value changed 3'

test 'CST @child', ->
  testController = casua.defineController ->
  testCtrlInst = new testController
    test: 'parent'
    child_test:
      test2: 'child'
      test3: 'this is a child'
  fragment1 = testCtrlInst.render
    'div':
      'h1': '@test'
      '@child child_test':
        'h2': '@test2'
        'div': '{{test3}}'

  equal fragment1[0].children[0].innerHTML, '<h1>parent</h1><h2>child</h2><div>this is a child</div>', 'child 1'

  testCtrlInst.scope.get('child_test').set 'test2', 'changed'

  equal fragment1[0].children[0].innerHTML, '<h1>parent</h1><h2>changed</h2><div>this is a child</div>', 'child binding'

test 'CST @child ArrayScope', ->
  testController = casua.defineController ->
  testCtrlInst = new testController
    lists: []
  lists = testCtrlInst.scope.get('lists')

  fragment1 = testCtrlInst.render
    'ul':
      '@child lists':
        'li': 'task{{no}}'
  equal fragment1[0].children[0].innerHTML, '', 'no child'

  lists.push { no: 1 }
  lists.push { no: 3 }
  equal fragment1[0].children[0].innerHTML, '<li>task1</li><li>task3</li>', '2 childs'

  lists.push { no: 2 }
  equal fragment1[0].children[0].innerHTML, '<li>task1</li><li>task3</li><li>task2</li>', '3 childs'

  lists.sort (a, b) -> a.get('no') - b.get('no')
  equal fragment1[0].children[0].innerHTML, '<li>task1</li><li>task2</li><li>task3</li>', 'sorted childs'

test 'CST @controller', ->
  testController = casua.defineController ->
  childController = casua.defineController (scope) ->
    scope.set 'name', 'task' + scope.get('no')
  testCtrlInst = new testController
    lists: []
  lists = testCtrlInst.scope.get('lists')
  fragment1 = testCtrlInst.render
    'ul':
      '@child lists':
        '@controller': childController
        'li': '{{name}}'
  lists.push { no: 1 }
  lists.push { no: 2 }
  equal fragment1[0].children[0].innerHTML, '<li>task1</li><li>task2</li>', '2 childs'

test 'CST @if', ->
  testController = casua.defineController ->
  testCtrlInst = new testController
    bool1: true
    bool2: false
  scope = testCtrlInst.scope
  fragment1 = testCtrlInst.render
    '.test':
      'span #1':
        '@if': '@bool1'
        '@text': 'bool1 is true'
      'span #2':
        '@if': '@bool2'
        '@text': 'bool2 is true'
  equal fragment1[0].children[0].innerHTML, '<span>bool1 is true</span><div style=\"display: none;\"></div>', 'ok'

  scope.set 'bool1', false
  scope.set 'bool2', true

  equal fragment1[0].children[0].innerHTML, '<div style=\"display: none;\"></div><span>bool2 is true</span>', 'ok'