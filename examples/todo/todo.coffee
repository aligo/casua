TasksCtrl = casua.defineController (scope) ->
  scope.set 'new_task_name', 'new'
  addNewTask: ->
    scope.get('tasks').push
      'name': scope.get('new_task_name')
    scope.set 'new_task_name', ''
    false
TaskCtrl = casua.defineController (scope) ->
  taskClass: ->
    if scope.get 'done'
      'is-done'
    else
      ''
      
app_node = new casua.Node document.getElementById('todo-app')

template =
 'ul.tasks-list':
   '@child tasks':
      '@controller': TaskCtrl
      'li':
        'input type="checkbox"':
          '@attr checked': '@done'
        '@attr class': '@taskClass()'
        'span':
          '@html': 'Task {{name}}'
  'input type="text"':
    '@val': '@new_task_name'
  'br': ''
  'a href="#"':
    '@on click': 'addNewTask'
    '@text': 'Add Task {{new_task_name}}'

new TasksCtrl(
  'tasks': [
    { 'name': 'one' }
    { 'name': 'two' }
    { 'name': 'three' }
  ]
).renderAt app_node, template