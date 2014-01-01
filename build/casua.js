// Generated by CoffeeScript 1.6.3
/*
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
*/


(function() {
  var casua, k, v, _escapeHTML, _escape_chars, _reversed_escape_chars, _scopeCallWatch, _scopeInitParent, _shallowCopy,
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
            if (r = attr.match(/^([^=]+)(?:=(['"])(.+?)\2)?$/)) {
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

  _scopeCallWatch = function(_scope, new_val, old_val, key, to_childs) {
    var child, fn, _i, _j, _len, _len1, _ref, _ref1, _results;
    if (to_childs == null) {
      to_childs = true;
    }
    if (_scope._watchs[key]) {
      _ref = _scope._watchs[key];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        fn.call(_scope, new_val, old_val, key);
      }
    }
    if (to_childs) {
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

  casua.Scope = (function() {
    function Scope(init_data, parent) {
      var key, value;
      if (init_data instanceof casua.Scope) {
        return init_data;
      } else if (init_data.length != null) {
        return new casua.ArrayScope(init_data, parent);
      } else {
        _scopeInitParent(this, parent);
        this._watchs = {};
        this._data = {};
        for (key in init_data) {
          value = init_data[key];
          this.set(key, value);
        }
      }
    }

    Scope.prototype.get = function(key) {
      var ret;
      ret = this._data[key];
      if ((ret == null) && (this._parent != null)) {
        ret = this._parent.get(key);
      }
      return ret;
    };

    Scope.prototype.set = function(key, value) {
      if (!(typeof key === 'string' && key.charAt(0) === '$')) {
        if (typeof value === 'object') {
          value = new casua.Scope(value, this);
        }
        if (this._data[key] !== value) {
          if (this._data[key] == null) {
            _scopeCallWatch(this, value, key, '$add', false);
          }
          _scopeCallWatch(this, value, this._data[key], key);
          return this._data[key] = value;
        }
      }
    };

    Scope.prototype.remove = function(key) {
      var i, s;
      if (this._data[key] instanceof casua.Scope) {
        s = this._data[key];
        if (s._parent != null) {
          i = s._parent._childs.indexOf(s);
          s._parent._childs.splice(i, 1);
        }
      }
      _scopeCallWatch(this, this._data[key], key, '$delete', false);
      return delete this._data[key];
    };

    Scope.prototype.$watch = function(key, fn) {
      var _base;
      (_base = this._watchs)[key] || (_base[key] = []);
      return this._watchs[key].push(fn);
    };

    return Scope;

  })();

  casua.ArrayScope = (function(_super) {
    var method, _fn, _i, _len, _ref;

    __extends(ArrayScope, _super);

    _ref = ['pop', 'push', 'reverse', 'shift', 'sort', 'slice', 'unshift'];
    _fn = function(method) {
      return ArrayScope.prototype[method] = function() {
        var idx, one, ret, value, _array, _j, _len1;
        _array = (function() {
          var _j, _len1, _ref1, _results;
          _ref1 = this._data;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            one = _ref1[_j];
            _results.push(one);
          }
          return _results;
        }).call(this);
        ret = _array[method].apply(_array, arguments);
        this._data = [];
        for (idx = _j = 0, _len1 = _array.length; _j < _len1; idx = ++_j) {
          value = _array[idx];
          this.set(idx, value);
        }
        return ret;
      };
    };
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      method = _ref[_i];
      _fn(method);
    }

    function ArrayScope(init_data, parent) {
      var idx, value, _j, _len1;
      if (init_data instanceof casua.Scope) {
        return init_data;
      } else if (init_data.length == null) {
        return new casua.Scope(init_data, parent);
      } else {
        _scopeInitParent(this, parent);
        this._watchs = {};
        this._data = [];
        for (idx = _j = 0, _len1 = init_data.length; _j < _len1; idx = ++_j) {
          value = init_data[idx];
          this.set(idx, value);
        }
      }
    }

    ArrayScope.prototype.length = function() {
      return this._data.length;
    };

    return ArrayScope;

  })(casua.Scope);

  casua.defineController = function(fn) {
    var _computeBind, _renderNode;
    _renderNode = function(_controller, _root, template) {
      var child, node, node_meta, r, value, _results;
      _results = [];
      for (node_meta in template) {
        child = template[node_meta];
        if (node_meta.charAt(0) !== '@') {
          node = new casua.Node(node_meta);
          _root.append(node);
          if (typeof child === 'object') {
            _results.push(_renderNode(_controller, node, child));
          } else {
            _results.push(void 0);
          }
        } else {
          if (r = node_meta.toLowerCase().match(/^@(\w+)(?: (\w+))?$/)) {
            switch (r[1]) {
              case 'on':
                _results.push(_root.on(r[2], _controller.methods[child]));
                break;
              case 'html':
              case 'text':
                value = _computeBind(_controller, child);
                _results.push(_root[r[1]].call(_root, value));
                break;
              default:
                _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
      }
      return _results;
    };
    _computeBind = function(_controller, src) {
      var binded_props, dst, r;
      dst = src;
      binded_props = [];
      if (r = src.match(/^@(\S+)$/)) {
        dst = _controller.scope.get(r[1]);
        binded_props.push(r[1]);
      }
      return dst;
    };
    return (function() {
      function _Class(init_data) {
        this.scope = new casua.Scope(init_data);
        this.methods = fn.call(this, this.scope);
      }

      _Class.prototype.render = function(template) {
        var fragment;
        fragment = new casua.Node(document.createDocumentFragment());
        _renderNode(this, fragment, template);
        return fragment;
      };

      return _Class;

    })();
  };

  window.casua = casua;

}).call(this);
