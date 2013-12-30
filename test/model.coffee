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
  array = new casua.Model [1, 2, 3]
  equal array[1], 2, 'array model'
  equal array.length, 3, 'array model length'
  