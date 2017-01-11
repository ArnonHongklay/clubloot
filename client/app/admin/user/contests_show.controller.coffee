
angular.module 'clublootApp'
.controller 'AdminUserContestsActiveCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'active'

angular.module 'clublootApp'
.controller 'AdminUserContestsCompletedCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'completed'

angular.module 'clublootApp'
.controller 'AdminUserContestsWonCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'won'
