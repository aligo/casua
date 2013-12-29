module 'casua.Node'
test 'Should can parse node_meta to build DOM node', ->
  tests_data =
    '.a-div': '<div class="a-div"></div>'
    'p.p-1#p-id.p-2': '<p id="p-id" class="p-1 p-2"></p>'
    'a href="/?a=b" target=\'_blank\' data-test="te\'st" only-prop': '<a only-prop=\"\" data-test=\"te\'st\" target=\"_blank\" href=\"/?a=b\"></a>'

  for node_meta, expect_html of tests_data
    nd = new casua.Node node_meta
    equal nd[0].outerHTML, expect_html, '"' + node_meta + '" is ok'

module 'Controller'
test 'defineController', ->
  container = new casua.Node ''
  testController = casua.defineController
    clickOne: ->
      console.log 'ok'
  testCtrlInst = new testController
    title: 'test'
  container.empty().append testCtrlInst.render
    '.test':
      '.test2': ''
      
  equal container[0].innerHTML, '<div class="test"><div class="test2"></div></div>', 'ok'

