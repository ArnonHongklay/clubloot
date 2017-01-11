
angular.module 'clublootApp'
.controller 'AdminUserPrizesCtrl', ($scope, $http, socket, prizes) ->
  $scope.prizes = prizes.data
  console.log $scope.prizes
