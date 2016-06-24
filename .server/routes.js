
/**
Main application routes
 */

(function() {
  'use strict';
  var errors, path;

  errors = require('./components/errors');

  path = require('path');

  module.exports = function(app) {
    app.use('/api/things', require('./api/thing'));
    app.use('/api/users', require('./api/user'));
    app.use('/auth', require('./auth'));
    app.route('/:url(api|auth|components|app|bower_components|assets)/*').get(errors[404]);
    return app.route('/*').get(function(req, res) {
      return res.sendFile(path.resolve(app.get('appPath') + '/index.html'));
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map
