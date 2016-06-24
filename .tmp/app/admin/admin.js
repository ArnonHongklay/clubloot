(function() {
  'use strict';
  angular.module('clublootApp').config(function($stateProvider) {
    return $stateProvider.state('admin', {
      url: '/admin',
      templateUrl: 'app/admin/admin.html',
      controller: 'AdminCtrl'
    });
  });

  'use strict';

  angular.module('clublootApp').controller('AdminCtrl', function($scope, $http, Auth, User) {
    $http.get('/api/users').success(function(users) {
      return $scope.users = users;
    });
    return $scope["delete"] = function(user) {
      User.remove({
        id: user._id
      });
      return _.remove($scope.users, user);
    };
  });

}).call(this);

//# sourceMappingURL=admin.js.map
