// Generated by CoffeeScript 1.9.2
(function() {
  var hasProp = {}.hasOwnProperty;

  window.Url = (function() {
    Url.prototype.parser_regexp = /^(.*:\/\/)([^:\/]+)(:[^\/]+)?(.*?)(\?.*?)?(#.*)?$/;

    function Url(initial) {
      if (!initial) {
        initial = window.location.href;
      }
      initial.replace(this.parser_regexp, (function(_this) {
        return function(match, _protocol, _domain, _port, _path, _params, _anchor) {
          _this._protocol = _protocol;
          _this._domain = _domain;
          _this._port = _port;
          _this._path = _path;
          _this._params = _params;
          _this._anchor = _anchor;
        };
      })(this));
      this.protocol = this._protocol ? this._protocol.replace(/:\/\//, '') : '';
      this.domain = this._domain || '';
      this.port = this._port ? this._port.replace(/:/, '') : '';
      this.path = this._path || '';
      this.params = this._params ? this._params.replace(/^\?/, '') : '';
      this.anchor = this._anchor ? this._anchor.replace(/#/, '') : '';
    }

    Url.prototype.get_params = function() {
      var params;
      params = {};
      $.each(this.params.split('&'), function(i, pair) {
        return pair.replace(/(.*)=(.*)/, function(match, name, value) {
          return params[name] = value;
        });
      });
      return params;
    };

    Url.prototype.set_params = function(params) {
      var name, value;
      this.params = '';
      for (name in params) {
        if (!hasProp.call(params, name)) continue;
        value = params[name];
        this.params = "" + this.params + name + "=" + value + "&";
      }
      this.params = this.params.replace(/&$/, '');
      return this;
    };

    Url.prototype.to_s = function() {
      var anchor, params, port;
      port = this.port ? ":" + this.port : '';
      params = this.params ? "?" + this.params : '';
      anchor = this.anchor ? "#" + this.anchor : '';
      return this.protocol + "://" + this.domain + port + this.path + params + anchor;
    };

    Url.prototype.relative_path = function() {
      var anchor, params;
      params = this.params ? "?" + this.params : '';
      anchor = this.anchor ? "#" + this.anchor : '';
      return "" + this.path + params + anchor;
    };

    return Url;

  })();

}).call(this);