(function() {
  'use strict';
  var auth, express, passport, router;

  express = require('express');

  passport = require('passport');

  auth = require('../auth.service');

  router = express.Router();

  router.get('/', passport.authenticate('twitter', {
    failureRedirect: '/signup',
    session: false
  })).get('/callback', passport.authenticate('twitter', {
    failureRedirect: '/signup',
    session: false
  }), auth.setTokenCookie);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
