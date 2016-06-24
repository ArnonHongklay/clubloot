(function() {
  'use strict';
  var User, app, should, user;

  should = require('should');

  app = require('../../app');

  User = require('./user.model');

  user = new User({
    provider: 'local',
    name: 'Fake User',
    email: 'test@test.com',
    password: 'password'
  });

  describe('User Model', function() {
    before(function(done) {
      return User.remove().exec().then(function() {
        return done();
      });
    });
    afterEach(function(done) {
      return User.remove().exec().then(function() {
        return done();
      });
    });
    it('should begin with no users', function(done) {
      return User.find({}, function(err, users) {
        users.should.have.length(0);
        return done();
      });
    });
    it('should fail when saving a duplicate user', function(done) {
      return user.save(function() {
        var userDup;
        userDup = new User(user);
        return userDup.save(function(err) {
          should.exist(err);
          return done();
        });
      });
    });
    it('should fail when saving without an email', function(done) {
      user.email = '';
      return user.save(function(err) {
        should.exist(err);
        return done();
      });
    });
    it('should authenticate user if password is valid', function() {
      return user.authenticate('password').should.be["true"];
    });
    return it('should not authenticate user if password is invalid', function() {
      return user.authenticate('blah').should.not.be["true"];
    });
  });

}).call(this);

//# sourceMappingURL=user.model.spec.js.map
