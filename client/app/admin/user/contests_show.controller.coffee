
angular.module 'clublootApp'
.controller 'AdminUserContestsActiveCtrl', ($scope, $http, socket, $state, $stateParams) ->
	menuContests = 'active'


angular.module 'clublootApp'
.controller 'AdminUserContestsCompletedCtrl', ($scope, $http, socket, $state, $stateParams) ->
  menuContests = 'completed'

angular.module 'clublootApp'
.controller 'AdminUserContestsWonCtrl', ($scope, $http, socket, $state, $stateParams) ->
  menuContests = 'won'
