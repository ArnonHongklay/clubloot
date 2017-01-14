
angular.module 'clublootApp'
.controller 'AdminUserProfileCtrl', ($scope, $http, socket, $filter) ->
  $scope.menuActive = 'Profile'

  $scope.update = ->
    # console.log $scope.user
    $http.put("/api/users/#{$scope.user._id}",
      $scope.user
    ).success((data, status, headers, config) ->
      # console.log data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )
