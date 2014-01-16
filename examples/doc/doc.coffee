converter = new Showdown.converter()

DocApp = casua.defineController (scope) ->

SectionCtrl = casua.defineController (scope) ->
  contentHtml: -> converter.makeHtml scope.get('content')

app_node = new casua.Node document.getElementById('doc-app')

template =
  '#side-index':
    '.unit':
      'a.name href="#"': 'Casua (0.0.2)'
    '.units':
      '@child units':
        '.unit':
          'a.name':
            '@attr href': '#{{@id}}'
            '@text': '@title'
          'ul.sections':
            '@child sections':
              'li':
                'a':
                  '@attr href': '#{{@$parent.id}}-{{@id}}'
                  '@text': '@title'
  '#main-content':
    'header':
      'h1.casua': 'Casua'
      'p #1': 'A casual and neat Structured Template and MVVM engine.'
      'p #2':
        'a href="https://github.com/aligo/casua"':
          'span': 'View the Project on GitHub'
          'small': 'aligo/casua'
    '.units':
      '@child units':
        '@controller': SectionCtrl
        '.unit':
          '@attr id': '@id'
          'h1': '@title'
          'div': 
            '@html': 'contentHtml()'
          '.sections':
            '@child sections':
              '@controller': SectionCtrl
              '.section':
                '@attr id': '{{@$parent.id}}-{{@id}}'
                'h2': '@title'
                'div': 
                  '@html': 'contentHtml()'


new DocApp(
  units: [window.docs_controller, window.docs_cst, window.docs_scope, window.docs_arrayscope, window.docs_node]
).renderAt app_node, template