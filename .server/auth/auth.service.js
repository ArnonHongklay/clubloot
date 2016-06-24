(function() {
  'use strict';
  var User, compose, config, expressJwt, hasRole, isAuthenticated, jwt, mongoose, passport, setTokenCookie, signToken, validateJwt;

  mongoose = require('mongoose');

  passport = require('passport');

  config = require('../config/environment');

  jwt = require('jsonwebtoken');

  expressJwt = require('express-jwt');

  compose = require('composable-middleware');

  User = require('../api/user/user.model');

  validateJwt = expressJwt({
    secret: config.secrets.session
  });


  /**
  Attaches the user object to the request if authenticated
  Otherwise returns 403
   */

  isAuthenticated = function() {
    return compose().use(function(req, res, next) {
      if (req.query && req.query.hasOwnProperty('access_token')) {
        req.headers.authorization = 'Bearer ' + req.query.access_token;
      }
      return validateJwt(req, res, next);
    }).use(function(req, res, next) {
      return User.findById(req.user._id, function(err, user) {
        if (err) {
          return next(err);
        }
        if (!user) {
          return res.status(401).end();
        }
        req.user = user;
        return next();
      });
    });
  };


  /**
  Checks if the user role meets the minimum requirements of the route
   */

  hasRole = function(roleRequired) {
    var meetsRequirements;
    if (!roleRequired) {
      throw new Error('Required role needs to be set');
    }
    return compose().use(isAuthenticated()).use(meetsRequirements = function(req, res, next) {
      if (config.userRoles.indexOf(req.user.role) >= config.userRoles.indexOf(roleRequired)) {
        return next();
      } else {
        return res.status(403).end();
      }
    });
  };


  /**
  Returns a jwt token signed by the app secret
   */

  signToken = function(id) {
    return jwt.sign({
      _id: id
    }, config.secrets.session, {
      expiresInMinutes: 60 * 5
    });
  };


  /**
  Set token cookie directly for oAuth strategies
   */

  setTokenCookie = function(req, res) {
    var token;
    if (!req.user) {
      return res.status(404).json({
        message: 'Something went wrong, please try again.'
      });
    }
    token = signToken(req.user._id, req.user.role);
    res.cookie('token', JSON.stringify(token));
    return res.redirect('/');
  };

  exports.isAuthenticated = isAuthenticated;

  exports.hasRole = hasRole;

  exports.signToken = signToken;

  exports.setTokenCookie = setTokenCookie;

}).call(this);

//# sourceMappingURL=auth.service.js.map
