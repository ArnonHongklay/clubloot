(function() {
  var FacebookStrategy, passport;

  passport = require('passport');

  FacebookStrategy = require('passport-facebook').Strategy;

  exports.setup = function(User, config) {
    return passport.use(new FacebookStrategy({
      clientID: config.facebook.clientID,
      clientSecret: config.facebook.clientSecret,
      callbackURL: config.facebook.callbackURL
    }, function(accessToken, refreshToken, profile, done) {
      return User.findOne({
        'facebook.id': profile.id
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          user = new User({
            name: profile.displayName,
            email: profile.emails[0].value,
            role: 'user',
            username: profile.username,
            provider: 'facebook',
            facebook: profile._json
          });
          return user.save(function(err) {
            if (err) {
              return done(err);
            }
            return done(err, user);
          });
        } else {
          return done(err, user);
        }
      });
    }));
  };

}).call(this);

//# sourceMappingURL=passport.js.map
