'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $stateParams, contest, program) ->
  $scope.programs = program.data
  $scope.contest = contest.data
  $scope.menu = $scope.contest.program
  $scope.$apend

  $scope.stepBack = () ->
    window.location.href = '/contest'

  $http.get("/api/contest/program/#{$scope.contest.program}/all",
      null
    ).success((ok) ->
      $scope.allContest = ok
      console.log ok
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $scope.showContestDetail = (contest) ->
    $scope.contestSelection = contest
    $scope.showContestDetail = true
