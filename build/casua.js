// Generated by CoffeeScript 1.6.3
/*
Casua
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
*/


(function() {
  var casua, _shallowCopy;

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
      var attr, attrs_data, el, r, tag_data, _i, _len;
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
        }
        for (_i = 0, _len = attrs_data.length; _i < _len; _i++) {
          attr = attrs_data[_i];
          if (r = attr.match(/^([^=]+)(?:=(['"])(.+?)\2)?$/)) {
            this.attr(r[1], r[3] || '');
          }
        }
      } else if (node_meta.nodeName) {
        _addNodes(this, node_meta);
      }
    }

    Node.prototype.attr = function(name, value) {
      var ret;
      ret = _forEach(this, function() {
        name = name.toLowerCase();
        if (value != null) {
          return this.setAttribute(name, value);
        } else {
          return this.getAttribute(name, 2);
        }
      });
      if (value != null) {
        return this;
      } else {
        return ret;
      }
    };

    Node.prototype.append = function(node) {
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

    Node.prototype.on = function(type, fn) {
      var _base, _node;
      _node = this;
      (_base = this.events)[type] || (_base[type] = []);
      this.events[type].push(fn);
      return _forEach(this, function(idx) {
        var handleds, handler, _base1;
        handler = (_base1 = _node.handlers)[idx] || (_base1[idx] = __createEventHanlder(this, _node.events));
        handleds = handler.handleds;
        if (handleds.indexOf(type) === -1) {
          __addEventListenerFn(this, type, handler);
          return handleds.push(type);
        }
      });
    };

    Node.prototype.trigger = function(type, event_data) {
      if (event_data == null) {
        event_data = {};
      }
      return _forEach(this, function() {
        var event, key, value;
        event = document.createEvent('HTMLEvents');
        event.initEvent(type, true, true);
        for (key in event_data) {
          value = event_data[key];
          event[key] = value;
        }
        return this.dispatchEvent(event);
      });
    };

    return Node;

  })();

  casua.defineController = function(fn) {
    var _renderNode;
    _renderNode = function(_controller, _root, template) {
      var child, node, node_meta, r, _results;
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
    return (function() {
      function _Class(init_data) {
        var scope;
        scope = init_data;
        this.methods = fn.call(this, scope);
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
