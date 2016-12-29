
angular.module 'clublootApp'
.controller 'AdminUserContestsCtrl', ($scope, $http, socket, $state, $stateParams) ->
  # console.log $scope.user._id
  # console.log "/api/users/#{$scope.user._id}/contests"

  $http.get("/api/program").success (data) ->
    $scope.program = data

  $scope.menu = (status) ->
    $scope.menuActiveContest = status
    $scope.contests = []
    $http.get("/api/users/#{$scope.user._id}/contests/#{status}").success (data) ->
      console.log $scope.contests = data

  $scope.menu('active')