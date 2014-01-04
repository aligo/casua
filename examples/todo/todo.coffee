TasksCtrl = casua.defineController (scope) ->
  scope.set 'new_task_name', 'new'
  addNewTask: ->
    scope.get('tasks').push
      'name': scope.get('new_task_name')
    scope.set 'new_task_name', ''
    false
  removeSelectedTasks: ->
    scope.get('tasks').filter (task) -> not task.get 'done'
    false

TaskCtrl = casua.defineController (scope) ->
  tasks_scope = scope.get('$parent')
  taskClass: ->
    if scope.get 'done'
      'is-done'
    else
      ''
  removeTask: ->
    tasks_scope.remove tasks_scope.indexOf(scope)
    false
      
app_node = new casua.Node document.getElementById('todo-app')

template =
 'ul.tasks-list':
   '@child tasks':
      '@controller': TaskCtrl
      'li':
        'input type="checkbox"':
          '@attr checked': '@done'
        '@attr class': 'taskClass()'
        'span':
          '@html': 'Task {{name}}'
        'a href="#"':
          '@text': 'x'
          '@on click': 'removeTask()'
  '.d0': 'Count: {{tasks.length}}'
  'input type="text"':
    '@val': '@new_task_name'
  '.d1':
    'a href="#"':
      '@on click': 'addNewTask()'
      '@text': 'Add Task {{new_task_name}}'
  '.d2':
    'a href="#"':
      '@on click': 'removeSelectedTasks()'
      '@text': 'Remove Selected Tasks'

new TasksCtrl(
  'tasks': [
    { 'name': 'one' }
    { 'name': 'two' }
    { 'name': 'three' }
  ]
).renderAt app_node, template