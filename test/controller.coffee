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
