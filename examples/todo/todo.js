// Generated by CoffeeScript 1.6.3
(function() {
  var TaskCtrl, TasksCtrl, app_node, template;

  TasksCtrl = casua.defineController(function(scope) {
    scope.set('new_task_name', 'new');
    return {
      addNewTask: function() {
        scope.get('tasks').push({
          'name': scope.get('new_task_name')
        });
        return scope.set('new_task_name', '');
      },
      removeSelectedTasks: function() {
        return scope.get('tasks').filter(function(task) {
          return !task.get('done');
        });
      }
    };
  });

  TaskCtrl = casua.defineController(function(scope) {
    var tasks_scope;
    tasks_scope = scope.get('$parent');
    return {
      taskClass: function() {
        if (scope.get('done')) {
          return 'is-done';
        } else {
          return '';
        }
      },
      removeTask: function() {
        return tasks_scope.remove(tasks_scope.indexOf(scope));
      },
      startEdit: function() {
        return scope.set('editing', true);
      },
      saveChange: function(e) {
        var keyCode;
        keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
          return scope.set('editing', false);
        }
      }
    };
  });

  app_node = new casua.Node(document.getElementById('todo-app'));

  template = {
    'ul.tasks-list': {
      '@child tasks': {
        '@controller': TaskCtrl,
        'li': {
          '@attr class': 'taskClass()',
          'input type="checkbox"': {
            '@attr checked': '@done'
          },
          'span': {
            '@unless': '@editing',
            '@on dblclick': 'startEdit()',
            '@html': 'Task {{@name}}'
          },
          'input type="text"': {
            '@if': '@editing',
            '@val': '@name',
            '@on keyup': 'saveChange()'
          },
          'a': {
            '@text': 'x',
            '@on click': 'removeTask()'
          }
        }
      }
    },
    '.d0': 'Count: {{@tasks.length}}',
    'input type="text"': {
      '@val': '@new_task_name'
    },
    '.d1': {
      'a': {
        '@on click': 'addNewTask()',
        '@text': 'Add Task {{@new_task_name}}'
      }
    },
    '.d2': {
      'a': {
        '@on click': 'removeSelectedTasks()',
        '@text': 'Remove Selected Tasks'
      }
    }
  };

  new TasksCtrl({
    'tasks': [
      {
        'name': 'one'
      }, {
        'name': 'two'
      }, {
        'name': 'three'
      }
    ]
  }).renderAt(app_node, template);

}).call(this);
