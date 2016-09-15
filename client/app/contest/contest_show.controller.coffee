'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $stateParams, contest, program) ->
  $scope.programs = program.data
  $scope.contest = contest.data
  $scope.menu = $scope.contest.program
  $scope.$apend

  $scope.stepBack = () ->
    window.location.href = '/contest'

  console.log $scope.contests
  # $http.get("/api/by_program",
  #     # $stateParams.contest
  #     null
  #   ).success((ok) ->
  #     console.log "ok"
  #     console.log ok
  #   ).error((data, status, headers, config) ->
  #     swal("Not Active")
  #   )
