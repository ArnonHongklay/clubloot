(function() {
  exports.setup = function(User, config) {
    var TwitterStrategy, passport;
    passport = require('passport');
    TwitterStrategy = require('passport-twitter').Strategy;
    return passport.use(new TwitterStrategy({
      consumerKey: config.twitter.clientID,
      consumerSecret: config.twitter.clientSecret,
      callbackURL: config.twitter.callbackURL
    }, function(token, tokenSecret, profile, done) {
      return User.findOne({
        'twitter.id_str': profile.id
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          user = new User({
            name: profile.displayName,
            username: profile.username,
            role: 'user',
            provider: 'twitter',
            twitter: profile._json
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
