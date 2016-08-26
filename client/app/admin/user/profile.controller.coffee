angular.module 'clublootApp'
.controller 'AdminUserCtrl', ($scope, $http, socket) ->
  console.log "AdminUserCtrl"

  # $http.put("/api/user/#{$scope.gems._id}",
  #   $scope.gems
  # ).success((data, status, headers, config) ->
  #   console.log data
  # ).error((data, status, headers, config) ->

  # )
