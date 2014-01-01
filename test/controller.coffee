_test = window._test

module 'Controller'
test 'defineController', ->
  container = new casua.Node ''
  testController = casua.defineController ->
  testCtrlInst = new testController {}
  container.empty().append testCtrlInst.render
    '.test':
      '.test2': ''
  equal container[0].innerHTML, '<div class="test"><div class="test2"></div></div>', 'ok'

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
  testController = casua.defineController ->
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

  scope = testCtrlInst.scope
  scope.set 'test', 'changed'

  equal fragment2[0].children[0].innerHTML, 'changed', 'scope value changed 1'
  equal fragment3[0].children[0].innerHTML, 'changed is good.', 'scope value changed 2'

  scope.set 'test2', 'is better'
  equal fragment3[0].children[0].innerHTML, 'changed is better.', 'scope value changed 3'