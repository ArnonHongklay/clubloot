(function() {
  'use strict';
  angular.module('clublootApp').config(function($stateProvider) {
    return $stateProvider.state('main', {
      url: '/',
      templateUrl: 'app/main/main.html',
      controller: 'MainCtrl'
    });
  });

  'use strict';

  angular.module('clublootApp').controller('MainCtrl', function($scope, $http, socket) {
    $('body').css({
      background: '#fff'
    });
    $scope.awesomeThings = [];
    $http.get('/api/things').success(function(awesomeThings) {
      $scope.awesomeThings = awesomeThings;
      return socket.syncUpdates('thing', $scope.awesomeThings);
    });
    $scope.addThing = function() {
      if ($scope.newThing === '') {
        return;
      }
      $http.post('/api/things', {
        name: $scope.newThing
      });
      return $scope.newThing = '';
    };
    $scope.deleteThing = function(thing) {
      return $http["delete"]('/api/things/' + thing._id);
    };
    $scope.$on('$destroy', function() {
      return socket.unsyncUpdates('thing');
    });
    $scope.setFilter = function(value) {
      if (value === 'live') {
        $scope.live = true;
        return $scope.upcoming = false;
      } else {
        $scope.live = false;
        return $scope.upcoming = true;
      }
    };
    return $scope.setFilter('live');
  });

}).call(this);

//# sourceMappingURL=main.js.map
