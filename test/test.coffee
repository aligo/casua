

module 'casua.Element'
test 'Should can be created', ->
  el1 = new casua.Element '.a-div'
  equal el1[0].outerHTML, '<div class="a-div"></div>', 'ok'

  el2 = new casua.Element 'p.p-1#p-id.p-2'
  equal el2[0].outerHTML, '<p id="p-id" class="p-1 p-2"></p>', 'ok'