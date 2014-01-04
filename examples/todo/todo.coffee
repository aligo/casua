TasksCtrl = casua.defineController (scope) ->
  scope.set 'new_task_name', 'new'
  addNewTask: ->
    scope.get('tasks').push
      'name': scope.get('new_task_name')
    scope.set 'new_task_name', ''
  removeSelectedTasks: ->
    scope.get('tasks').filter (task) -> not task.get 'done'
TaskCtrl = casua.defineController (scope) ->
  tasks_scope = scope.get('$parent')
  taskClass: ->
    if scope.get 'done'
      'is-done'
    else
      ''
  removeTask: ->
    tasks_scope.remove tasks_scope.indexOf(scope)
  startEdit: ->
    scope.set 'editing', true
  saveChange: (e) ->
    keyCode = e.keyCode || e.which
    scope.set 'editing', false if keyCode == 13
      
app_node = new casua.Node document.getElementById('todo-app')

template =
 'ul.tasks-list':
   '@child tasks':
      '@controller': TaskCtrl
      'li':
        '.normal':
          '@unless': '@editing'
          '@attr class': 'taskClass()'
          '@on dblclick': 'startEdit()'
          'input type="checkbox"':
            '@attr checked': '@done'
          'span':
            '@html': 'Task {{@name}}'
          'a':
            '@text': 'x'
            '@on click': 'removeTask()'
        '.editing':
          '@if': '@editing'
          'input type="text"':
            '@val': '@name'
            '@on keyup': 'saveChange()'
  '.d0': 'Count: {{@tasks.length}}'
  'input type="text"':
    '@val': '@new_task_name'
  '.d1':
    'a':
      '@on click': 'addNewTask()'
      '@text': 'Add Task {{@new_task_name}}'
  '.d2':
    'a':
      '@on click': 'removeSelectedTasks()'
      '@text': 'Remove Selected Tasks'

new TasksCtrl(
  'tasks': [
    { 'name': 'one' }
    { 'name': 'two' }
    { 'name': 'three' }
  ]
).renderAt app_node, template