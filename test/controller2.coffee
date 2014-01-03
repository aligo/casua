_test = window._test

module 'Controller 2'

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

test 'CST @attr', ->
  testController = casua.defineController ->
  testCtrlInst = new testController
    test: 'value1'
    alt_class: 'alt'
  fragment1 = testCtrlInst.render
    'div':
      '@attr data-attr': '@test'
  equal fragment1[0].children[0].outerHTML, '<div data-attr=\"value1\"></div>', 'bind @attr'
  testCtrlInst.scope.set 'test', 'new'
  equal fragment1[0].children[0].outerHTML, '<div data-attr=\"new\"></div>', 'bind @attr'

  fragment2 = testCtrlInst.render
    'div.original':
      '@attr class': 'another {{alt_class}}'
  equal fragment2[0].children[0].outerHTML, '<div class=\"original another alt\"></div>', 'bind @attr class'

  testCtrlInst.scope.set 'alt_class', 1
  fragment3 = testCtrlInst.render
    'div.original':
      '@class': 'another-{{alt_class}}'
  equal fragment3[0].children[0].outerHTML, '<div class=\"original another-1\"></div>', 'bind @class for short'