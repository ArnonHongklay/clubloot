(function() {
  'use strict';
  var auth, express, passport, router;

  express = require('express');

  passport = require('passport');

  auth = require('../auth.service');

  router = express.Router();

  router.get('/', passport.authenticate('facebook', {
    scope: ['email', 'user_about_me'],
    failureRedirect: '/signup',
    session: false
  })).get('/callback', passport.authenticate('facebook', {
    failureRedirect: '/signup',
    session: false
  }), auth.setTokenCookie);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
