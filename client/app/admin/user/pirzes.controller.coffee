
angular.module 'clublootApp'
.controller 'AdminUserPrizesCtrl', ($scope, $http, socket, prizes) ->
  $scope.menuActive = 'Prizes'
  $scope.prizes = prizes.data
