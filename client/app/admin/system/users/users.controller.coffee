angular.module 'clublootApp'
.controller 'AdminSystemUserCtrl', ($scope, $http, socket, user) ->
  console.log "AdminSystemUserCtrl"
  $scope.users = user.data
