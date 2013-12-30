_test = window._test || = {}

window._test._trigger = (node, event_type) ->
  e = document.createEvent 'HTMLEvents'
  e.initEvent event_type, true, true
  node = [node] unless node.length
  for el in node
    el.dispatchEvent e

module 'Node'
test 'Should can parse node_meta to build DOM node', ->
  tests_data =
    '.a-div': '<div class="a-div"></div>'
    'p.p-1#p-id.p-2': '<p id="p-id" class="p-1 p-2"></p>'
    'a href="/?a=b" target=\'_blank\' data-test="te\'st" only-prop': '<a only-prop=\"\" data-test=\"te\'st\" target=\"_blank\" href=\"/?a=b\"></a>'

  for node_meta, expect_html of tests_data
    nd = new casua.Node node_meta
    equal nd[0].outerHTML, expect_html, '"' + node_meta + '" is ok'

test 'Should can get and set attribute by attr()', ->
  node = new casua.Node ''
  node.attr 'test', 'test'
  equal node[0].getAttribute('test', 2), 'test', 'set'
  equal node.attr('test'), 'test', 'get'
  equal node.attr('test-2', 'chained').attr('teSt-2'), 'chained', 'chained'

test 'Should can append()', ->
  node1 = new casua.Node 'h1'
  node2 = new casua.Node 'span'
  equal node1.append(node2)[0].outerHTML, '<h1><span></span></h1>', 'append'

  jquery_node = $('<div></div>')
  jquery_node.append node1
  equal jquery_node[0].outerHTML, '<div><h1><span></span></h1></div>', 'compatible with jquery # 1'

  node3 = new casua.Node ''
  node3.append jquery_node
  equal node3[0].outerHTML, '<div><div><h1><span></span></h1></div></div>', 'compatible with jquery # 2'

test 'Should can empty()', ->
  node = new casua.Node 'h1'
  node[0].innerHTML = 'xxxx'
  equal node.empty()[0].innerHTML, '', 'empty'

test 'Should can on()', ->
  clicked = 0
  node = new casua.Node 'a'
  node.on 'click', ->
    clicked += 1
  node.on 'click', ->
    clicked += 2
  _test._trigger node, 'click'
  equal clicked, 3, 'ok'

test 'Should can trigger()', ->
  clicked = 0
  node = new casua.Node 'a'
  node.on 'click', (event) ->
    clicked = event.test_data
  node.trigger 'click', { test_data: 5 }
  equal clicked, 5, 'ok'
  