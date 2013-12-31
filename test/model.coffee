module 'Model'
test 'Should can be create', ->
  model1 = new casua.Model
    test: 1
  equal model1.test, 1, 'object model'

test 'Should can watch change', ->
  model1 = new casua.Model
    test: 1
  equal model1.test, 1, 'object model'
  watched = 0
  newVal = false
  oldVal = false
  model1.$watch 'test', (n, o) ->
    newVal = n
    oldVal = o
    watched += 1
  stop()
  model1.test = 2
  model1.test = 2
  setTimeout ( ->
    equal newVal, 2, 'can get new val'
    equal oldVal, 1, 'can get old val'
    equal watched, 1, 'can watch'
    model1.$watch 'test', -> watched *= 2
    model1.test = 3
    setTimeout ( ->
      equal watched, 4, 'can watch twice'
      model1.$watch 'newprop', -> watched += @newprop
      model1.newprop = 200
      setTimeout ( ->
        equal watched, 204, 'can watch new prop'
        start()
      ), 60
    ), 60
  ), 60

test 'Should can act as a array', ->
  watched = 0
  watched_adds = []
  watched_deletes = []
  array = new casua.Model [1, 2, 3]
  equal array[1], 2, 'array model'
  equal array.length, 3, 'array model length'
  array.$watch 1, (n, o) ->
    watched += n
  array.$watch 3, (n, o) ->
    watched += 1
  array.$watch '$add', (idx, one) ->
    watched_adds.push
      idx: idx
      one: one
  array.$watch '$delete', (idx, one) ->
    watched_deletes.push
      idx: idx
      one: one
  array[1] = 9
  array.push 'x'
  equal array.length, 4, 'array model push'
  equal array[3], 'x', 'array model push'
  stop()
  setTimeout ( ->
    equal watched, 10, 'can watch array'
    equal watched_adds[(watched_adds.length - 1)].idx, 3, 'can watch $add'
    equal watched_adds[(watched_adds.length - 1)].one, 'x', 'can watch $add'
    array.pop()
    equal array[2], 3, 'array model pop'
    equal array.length, 3, 'array model pop'
    setTimeout ( ->
      equal watched_deletes[(watched_deletes.length - 1)].idx, 3, 'can watch $delete'
      equal watched_deletes[(watched_deletes.length - 1)].one, 'x', 'can watch $delete'
      start()
    ), 60
  ), 60

