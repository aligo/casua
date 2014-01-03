// Generated by CoffeeScript 1.6.3
/*
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
*/


(function() {
  var casua, k, v, _escapeHTML, _escape_chars, _reversed_escape_chars, _scopeCallAltWatch, _scopeCallWatch, _scopeInitParent, _scopeRemovePrepare, _shallowCopy,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _shallowCopy = function(src, dst) {
    var key, value;
    if (dst == null) {
      dst = {};
    }
    for (key in src) {
      value = src[key];
      dst[key] = value;
    }
    return dst;
  };

  _escape_chars = {
    lt: '<',
    gt: '>',
    quot: '"',
    amp: '&',
    apos: "'"
  };

  _reversed_escape_chars = {};

  for (k in _escape_chars) {
    v = _escape_chars[k];
    _reversed_escape_chars[v] = k;
  }

  _escapeHTML = function(str) {
    return str.replace(/[&<>"']/g, function(m) {
      return '&' + _reversed_escape_chars[m] + ';';
    });
  };

  casua = {};

  casua.Node = (function() {
    var __addEventListenerFn, __createEventHanlder, _addNodes, _forEach, _push;

    _addNodes = function(_node, elements) {
      var element, _i, _len, _results;
      if (elements.nodeName) {
        elements = [elements];
      }
      _results = [];
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        _results.push(_push(_node, element));
      }
      return _results;
    };

    _push = function(_node, one) {
      _node[_node.length] = one;
      return _node.length += 1;
    };

    _forEach = function(_node, callback) {
      var idx, one, ret;
      ret = (function() {
        var _i, _len, _results;
        _results = [];
        for (idx = _i = 0, _len = _node.length; _i < _len; idx = ++_i) {
          one = _node[idx];
          _results.push(callback.call(one, idx, one));
        }
        return _results;
      })();
      return ret[0];
    };

    __addEventListenerFn = window.document.addEventListener ? function(element, type, fn) {
      return element.addEventListener(type, fn, false);
    } : function(element, type, fn) {
      return element.attachEvent('on' + type, fn);
    };

    __createEventHanlder = function(element, events) {
      var ret;
      ret = function(event, type) {
        var eventFns, fn, i, prevent;
        event.preventDefault || (event.preventDefault = function() {
          return event.returnValue = false;
        });
        event.stopPropagation || (event.stopPropagation = function() {
          return event.cancelBubble = true;
        });
        event.target || (event.target = event.srcElement || document);
        if (event.defaultPrevented == null) {
          prevent = event.preventDefault;
          event.preventDefault = function() {
            event.defaultPrevented = true;
            return prevent.call(event);
          };
          event.defaultPrevented = false;
        }
        event.isDefaultPrevented = function() {
          return event.defaultPrevented || (event.returnValue === false);
        };
        eventFns = _shallowCopy(events[type || event.type] || []);
        for (i in eventFns) {
          fn = eventFns[i];
          fn.call(element, event);
        }
        delete event.preventDefault;
        delete event.stopPropagation;
        return delete event.isDefaultPrevented;
      };
      ret.elem = element;
      ret.handleds = [];
      return ret;
    };

    function Node(node_meta) {
      var attr, attrs_data, child, div, el, r, tag_data, _i, _j, _len, _len1, _ref;
      this.handlers = {};
      this.events = {};
      this.length = 0;
      if (node_meta instanceof casua.Node) {
        return node_meta;
      } else if (typeof node_meta === 'string') {
        if (node_meta.charAt(0) !== '<') {
          attrs_data = node_meta.split(' ');
          tag_data = attrs_data.shift();
          el = document.createElement((r = tag_data.match(/^([^\.^#]+)/)) ? r[1] : 'div');
          if (r = tag_data.match(/\.([^\.^#]+)/g)) {
            el.className = r.join(' ').replace(/\./g, '');
          }
          if (r = tag_data.match(/#([^\.^#]+)/)) {
            el.id = r[1];
          }
          _addNodes(this, el);
          for (_i = 0, _len = attrs_data.length; _i < _len; _i++) {
            attr = attrs_data[_i];
            if (attr.charAt(0) !== '#' && (r = attr.match(/^([^=]+)(?:=(['"])(.+?)\2)?$/))) {
              this.attr(r[1], r[3] || '');
            }
          }
        } else {
          div = document.createElement('div');
          div.innerHTML = '<div>&#160;</div>' + node_meta;
          div.removeChild(div.firstChild);
          _ref = div.childNodes;
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            child = _ref[_j];
            _addNodes(this, child);
          }
        }
      } else if (node_meta.nodeName) {
        _addNodes(this, node_meta);
      }
    }

    Node.prototype.attr = function(name, value) {
      name = name.toLowerCase();
      if (name === 'value') {
        return this.val(value);
      }
      if (value != null) {
        _forEach(this, function() {
          return this.setAttribute(name, value);
        });
        return this;
      } else {
        return this[0].getAttribute(name, 2);
      }
    };

    Node.prototype.append = function(node) {
      if (typeof node === 'string') {
        node = new casua.Node(node);
      }
      _forEach(this, function(i, parent) {
        return _forEach(node, function(j, child) {
          return parent.appendChild(child);
        });
      });
      return this;
    };

    Node.prototype.empty = function() {
      _forEach(this, function() {
        var _results;
        _results = [];
        while (this.firstChild) {
          _results.push(this.removeChild(this.firstChild));
        }
        return _results;
      });
      return this;
    };

    Node.prototype.html = function(value) {
      if (value != null) {
        this.empty();
        _forEach(this, function() {
          return this.innerHTML = value;
        });
        return this;
      } else {
        return this[0].innerHTML;
      }
    };

    Node.prototype.text = function(value) {
      if (value != null) {
        return this.html(_escapeHTML(value));
      } else {
        return this.html();
      }
    };

    Node.prototype.on = function(type, fn) {
      var _base, _node;
      _node = this;
      (_base = this.events)[type] || (_base[type] = []);
      this.events[type].push(fn);
      _forEach(this, function(idx) {
        var handleds, handler, _base1;
        handler = (_base1 = _node.handlers)[idx] || (_base1[idx] = __createEventHanlder(this, _node.events));
        handleds = handler.handleds;
        if (handleds.indexOf(type) === -1) {
          __addEventListenerFn(this, type, handler);
          return handleds.push(type);
        }
      });
      return this;
    };

    Node.prototype.trigger = function(type, event_data) {
      if (event_data == null) {
        event_data = {};
      }
      _forEach(this, function() {
        var event, key, value;
        event = document.createEvent('HTMLEvents');
        event.initEvent(type, true, true);
        for (key in event_data) {
          value = event_data[key];
          event[key] = value;
        }
        return this.dispatchEvent(event);
      });
      return this;
    };

    Node.prototype.remove = function() {
      _forEach(this, function() {
        if (this.parentNode) {
          return this.parentNode.removeChild(this);
        }
      });
      return this;
    };

    Node.prototype.replaceWith = function(node) {
      if (typeof node === 'string') {
        node = new casua.Node(node);
      }
      _forEach(this, function(i, from) {
        return _forEach(node, function(j, to) {
          if (from.parentNode) {
            return from.parentNode.replaceChild(to, from);
          }
        });
      });
      return this;
    };

    Node.prototype.val = function(value) {
      if (value != null) {
        _forEach(this, function() {
          return this.value = value;
        });
        return this;
      } else {
        return this[0].value;
      }
    };

    return Node;

  })();

  _scopeInitParent = function(_scope, _parent) {
    _scope._childs = [];
    if (_parent != null) {
      if (_parent._childs.indexOf(_scope) === -1) {
        _parent._childs.push(_scope);
      }
      return _scope._parent = _parent;
    }
  };

  _scopeRemovePrepare = function(_scope, key) {
    var i, s;
    if (_scope._data[key] instanceof casua.Scope) {
      s = _scope._data[key];
      if (s._parent != null) {
        i = s._parent._childs.indexOf(s);
        s._parent._childs.splice(i, 1);
      }
    }
    return _scopeCallWatch(_scope, _scope._data[key], key, '$delete');
  };

  _scopeCallWatch = function(_scope, new_val, old_val, key) {
    var child, fn, _i, _j, _len, _len1, _ref, _ref1, _results;
    if (typeof key === 'string' && key.charAt(0) === '$') {
      return _scopeCallAltWatch(_scope, new_val, old_val, key);
    } else {
      if (_scope._watches[key]) {
        _ref = _scope._watches[key];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          fn = _ref[_i];
          fn.call(_scope, new_val, old_val, key);
        }
      }
      _ref1 = _scope._childs;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        child = _ref1[_j];
        if (child._data[key] == null) {
          _results.push(_scopeCallWatch(child, new_val, old_val, key));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  };

  _scopeCallAltWatch = function(_scope, new_val, key, type) {
    var fn, _i, _len, _ref, _results;
    if (_scope._watches[type]) {
      _ref = _scope._watches[type];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        _results.push(fn.call(_scope, new_val, type, key));
      }
      return _results;
    }
  };

  casua.Scope = (function() {
    function Scope(init_data, parent) {
      var key, value;
      if (init_data instanceof casua.Scope) {
        return init_data;
      } else if (init_data.length != null) {
        return new casua.ArrayScope(init_data, parent);
      } else {
        _scopeInitParent(this, parent);
        this._watches = {};
        this._data = {};
        for (key in init_data) {
          value = init_data[key];
          this.set(key, value);
        }
      }
    }

    Scope.prototype.get = function(key) {
      var ret;
      if (this._watch_lists && this._watch_lists.indexOf(key) === -1) {
        this._watch_lists.push(key);
      }
      ret = this._data[key];
      if ((ret == null) && (this._parent != null)) {
        ret = this._parent.get(key);
      }
      return ret;
    };

    Scope.prototype.set = function(key, value) {
      var old;
      if (!(typeof key === 'string' && key.charAt(0) === '$')) {
        if (typeof value === 'object') {
          value = new casua.Scope(value, this);
        }
        if (this._data[key] !== value) {
          old = this._data[key];
          this._data[key] = value;
          if (old == null) {
            _scopeCallWatch(this, value, key, '$add');
          }
          return _scopeCallWatch(this, value, old, key);
        }
      }
    };

    Scope.prototype.remove = function(key) {
      _scopeRemovePrepare(this, key);
      return delete this._data[key];
    };

    Scope.prototype.$watch = function(key, fn) {
      var _base;
      (_base = this._watches)[key] || (_base[key] = []);
      return this._watches[key].push(fn);
    };

    Scope.prototype.$startGetWatches = function() {
      return this._watch_lists = [];
    };

    Scope.prototype.$stopGetWatches = function() {
      var lists, one;
      lists = (function() {
        var _i, _len, _ref, _results;
        _ref = this._watch_lists;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          one = _ref[_i];
          _results.push(one);
        }
        return _results;
      }).call(this);
      delete this._watch_lists;
      return lists;
    };

    return Scope;

  })();

  casua.ArrayScope = (function(_super) {
    __extends(ArrayScope, _super);

    function ArrayScope(init_data, parent) {
      var idx, value, _i, _len;
      if (init_data instanceof casua.Scope) {
        return init_data;
      } else if (init_data.length == null) {
        return new casua.Scope(init_data, parent);
      } else {
        _scopeInitParent(this, parent);
        this._watches = {};
        this._data = [];
        for (idx = _i = 0, _len = init_data.length; _i < _len; idx = ++_i) {
          value = init_data[idx];
          this.set(idx, value);
        }
      }
    }

    ArrayScope.prototype.length = function() {
      return this._data.length;
    };

    ArrayScope.prototype.remove = function(key) {
      _scopeRemovePrepare(this, key);
      return this._data.splice(key, 1);
    };

    ArrayScope.prototype.each = function(fn) {
      var i, one, _i, _len, _ref, _results;
      _ref = this._data;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        one = _ref[i];
        _results.push(fn.call(this, this.get(i), i));
      }
      return _results;
    };

    ArrayScope.prototype.pop = function() {
      return this.remove(this._data.length - 1)[0];
    };

    ArrayScope.prototype.shift = function() {
      return this.remove(0)[0];
    };

    ArrayScope.prototype.push = function() {
      var one, _i, _len;
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        one = arguments[_i];
        this.set(this._data.length, one);
      }
      return this._data.length;
    };

    ArrayScope.prototype.unshift = function() {
      var i, one, pos, _old_length;
      _old_length = this._data.length;
      this.push.apply(this, arguments);
      pos = (function() {
        var _i, _len, _ref, _results;
        _ref = this._data;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          one = _ref[i];
          if (i < _old_length) {
            _results.push(i + arguments.length);
          } else {
            _results.push(i - _old_length);
          }
        }
        return _results;
      }).apply(this, arguments);
      _scopeCallWatch(this, pos, null, '$move');
      return this._data.length;
    };

    ArrayScope.prototype.reverse = function() {
      var i, one, pos;
      this._data.reverse();
      pos = (function() {
        var _i, _len, _ref, _results;
        _ref = this._data;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          one = _ref[i];
          _results.push(this._data.length - 1 - i);
        }
        return _results;
      }).call(this);
      _scopeCallWatch(this, pos, null, '$move');
      return this;
    };

    ArrayScope.prototype.sort = function(fn) {
      var i, one, pos, self, to_sort;
      self = this;
      to_sort = (function() {
        var _i, _len, _ref, _results;
        _ref = this._data;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          one = _ref[i];
          _results.push({
            e: one,
            o: i
          });
        }
        return _results;
      }).call(this);
      to_sort.sort(function(a, b) {
        return fn.call(self, a.e, b.e);
      });
      pos = [];
      this._data = (function() {
        var _i, _len, _results;
        _results = [];
        for (i = _i = 0, _len = to_sort.length; _i < _len; i = ++_i) {
          one = to_sort[i];
          pos[one.o] = i;
          _results.push(one.e);
        }
        return _results;
      })();
      _scopeCallWatch(this, pos, null, '$move');
      return this;
    };

    return ArrayScope;

  })(casua.Scope);

  casua.defineController = function(init_fn) {
    var __computeBind, __compute_controller_method_regexp, __compute_controller_regexp, __compute_match_key_regexp, __compute_match_regexp, __compute_scope_key_regexp, __compute_scope_regexp, __nodeAttrBind, __nodeBind, __nodeCondition, _renderNode, _renderNodes;
    _renderNode = function(_controller, _scope, _root, template) {
      var child, new_controller, new_template, node, node_meta, r, _results;
      if (_scope instanceof casua.ArrayScope) {
        return _renderNodes(_controller, _scope, _root, template);
      } else if (template['@controller']) {
        new_template = _shallowCopy(template);
        new_controller = new template['@controller'](_scope);
        delete new_template['@controller'];
        return _renderNode(new_controller, _scope, _root, new_template);
      } else {
        _results = [];
        for (node_meta in template) {
          child = template[node_meta];
          if (node_meta.charAt(0) === '@') {
            if (r = node_meta.toLowerCase().match(/^@(\w+)(?: (\S+))?$/)) {
              switch (r[1]) {
                case 'on':
                  _results.push(_root.on(r[2], _controller.methods[child]));
                  break;
                case 'html':
                case 'text':
                  _results.push(__nodeBind(_controller, _root, r[1], _scope, child));
                  break;
                case 'val':
                  _results.push(__nodeBind(_controller, _root, r[1], _scope, child));
                  break;
                case 'attr':
                  _results.push(__nodeAttrBind(_controller, _root, r[2], _scope, child));
                  break;
                case 'child':
                  _results.push(_renderNode(_controller, _scope.get(r[2]), _root, child));
                  break;
                case 'if':
                  _results.push(__nodeCondition(_controller, _root, r[1], _scope, child));
                  break;
                default:
                  _results.push(void 0);
              }
            } else {
              _results.push(void 0);
            }
          } else {
            node = new casua.Node(node_meta);
            _root.append(node);
            if (typeof child === 'object') {
              _renderNode(_controller, _scope, node, child);
            } else {
              __nodeBind(_controller, node, 'text', _scope, child);
            }
            _results.push(node);
          }
        }
        return _results;
      }
    };
    _renderNodes = function(_controller, _scope, _root, template) {
      var add_fn, _nodes;
      _root.empty();
      _nodes = [];
      add_fn = function(new_scope, type, idx) {
        return _nodes[idx] = _renderNode(_controller, new_scope, _root, template);
      };
      _scope.$watch('$add', add_fn);
      _scope.$watch('$delete', function(new_scope, type, idx) {
        var node, nodes, _i, _len, _results;
        nodes = _nodes.splice(idx, 1)[0];
        _results = [];
        for (_i = 0, _len = nodes.length; _i < _len; _i++) {
          node = nodes[_i];
          _results.push(node.remove());
        }
        return _results;
      });
      _scope.$watch('$move', function(new_pos, type) {
        var new_po, node, nodes, old_po, _i, _j, _len, _len1, _new_nodes, _results;
        _new_nodes = [];
        for (old_po = _i = 0, _len = new_pos.length; _i < _len; old_po = ++_i) {
          new_po = new_pos[old_po];
          _new_nodes[new_po] = _nodes[old_po];
        }
        _nodes = _new_nodes;
        _root.empty();
        _results = [];
        for (_j = 0, _len1 = _nodes.length; _j < _len1; _j++) {
          nodes = _nodes[_j];
          _results.push((function() {
            var _k, _len2, _results1;
            _results1 = [];
            for (_k = 0, _len2 = nodes.length; _k < _len2; _k++) {
              node = nodes[_k];
              _results1.push(_root.append(node));
            }
            return _results1;
          })());
        }
        return _results;
      });
      return _scope.each(function(one, idx) {
        return add_fn.call({}, one, null, idx);
      });
    };
    __nodeBind = function(_controller, _node, _method, _scope, src) {
      return __computeBind(_controller, _scope, src, function(result) {
        return _node[_method].call(_node, result);
      });
    };
    __nodeAttrBind = function(_controller, _node, attr, _scope, src) {
      return __computeBind(_controller, _scope, src, function(result) {
        return _node.attr(attr, result);
      });
    };
    __nodeCondition = function(_controller, _node, _method, _scope, src) {
      var cur_node, false_node, true_node;
      cur_node = true_node = _node;
      false_node = new casua.Node('<!-- -->');
      return __computeBind(_controller, _scope, src, (function(result) {
        if (result) {
          cur_node.replaceWith(true_node);
          return cur_node = true_node;
        } else {
          cur_node.replaceWith(false_node);
          return cur_node = false_node;
        }
      }), true);
    };
    __compute_match_regexp = /\{\{([\S^\}]+)\}\}/g;
    __compute_match_key_regexp = /^\{\{([\S^\}]+)\}\}$/;
    __compute_scope_regexp = /@(\S+)/g;
    __compute_scope_key_regexp = /^@(\S+)$/;
    __compute_controller_regexp = /@(\S+)\(\)/g;
    __compute_controller_method_regexp = /^@(\S+)\(\)$/;
    __computeBind = function(_controller, _scope, src, fn, to_eval) {
      var key, keys_to_watch, r, ret, watch_fn, _i, _len, _ref;
      if (to_eval == null) {
        to_eval = false;
      }
      keys_to_watch = [];
      watch_fn = (r = src.match(__compute_controller_method_regexp)) ? function() {
        return fn.call({}, _controller.methods[r[1]].call(_controller));
      } : (r = src.match(__compute_scope_key_regexp)) ? function() {
        return fn.call({}, this.get(r[1]));
      } : (r = src.match(__compute_match_regexp)) ? function() {
        var scope;
        scope = this;
        return fn.call({}, src.replace(__compute_match_regexp, function(part) {
          part = part.match(__compute_match_key_regexp);
          return scope.get(part[1]);
        }));
      } : to_eval ? (src = src.replace(__compute_controller_regexp, function(part) {
        part = part.match(__compute_controller_method_regexp);
        return '_controller.methods.' + part[1] + '.call(_controller)';
      }), src = src.replace(__compute_scope_regexp, function(part) {
        part = part.match(__compute_scope_key_regexp);
        return '_scope.get("' + part[1] + '")';
      }), function() {
        return fn.call({}, eval(src));
      }) : function() {
        return fn.call({}, src);
      };
      _scope.$startGetWatches();
      ret = watch_fn.call(_scope);
      _ref = _scope.$stopGetWatches();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        _scope.$watch(key, watch_fn);
      }
      return ret;
    };
    return (function() {
      function _Class(init_data) {
        this.scope = new casua.Scope(init_data);
        this.methods = init_fn.call(this, this.scope, this);
      }

      _Class.prototype.renderAt = function(container, template) {
        return _renderNode(this, this.scope, (new casua.Node(container)).empty(), template);
      };

      _Class.prototype.render = function(template) {
        var fragment;
        fragment = new casua.Node(document.createElement('div'));
        _renderNode(this, this.scope, fragment, template);
        return fragment;
      };

      return _Class;

    })();
  };

  window.casua = casua;

}).call(this);
