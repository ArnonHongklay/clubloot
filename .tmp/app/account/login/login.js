(function() {
  'use strict';
  angular.module('clublootApp').controller('LoginCtrl', function($scope, Auth, $location, $window) {
    $('body').css({
      background: '#50ACC4'
    });
    $scope.user = {};
    $scope.errors = {};
    $scope.login = function(form) {
      $scope.submitted = true;
      if (form.$valid) {
        return Auth.login({
          email: $scope.user.email,
          password: $scope.user.password
        }).then(function() {
          return $location.path('/');
        })["catch"](function(err) {
          return $scope.errors.other = err.message;
        });
      }
    };
    return $scope.loginOauth = function(provider) {
      return $window.location.href = '/auth/' + provider;
    };
  });

}).call(this);

//# sourceMappingURL=login.js.map
