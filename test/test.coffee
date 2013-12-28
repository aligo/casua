

module 'Element'
test 'casua.createElement', ->
  tests_data =
    '.a-div': '<div class="a-div"></div>'
    'p.p-1#p-id.p-2': '<p id="p-id" class="p-1 p-2"></p>'
    'a href="/?a=b" target=\'_blank\' data-test="te\'st" only-prop': '<a only-prop=\"\" data-test=\"te\'st\" target=\"_blank\" href=\"/?a=b\"></a>'

  for element, expect_html of tests_data
    el = casua.createElement element
    equal el[0].outerHTML, expect_html, '"' + element + '" is ok'
