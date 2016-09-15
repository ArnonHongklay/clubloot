'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $stateParams, contests) ->
  $scope.contests = contests.data
  $scope.menu = $stateParams.contest
  $scope.$apend

  $scope.stepBack = () ->
    window.location.href = '/contest'


  $http.get("/api/contest",
      # $stateParams.contest
      null
    ).success((ok) ->
      console.log ok
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )
