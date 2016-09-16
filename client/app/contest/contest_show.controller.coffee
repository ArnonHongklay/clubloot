'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $state, Auth, $stateParams, contest, program) ->
  $scope.programs = program.data
  $scope.contest = contest.data
  $scope.menu = $stateParams.contest
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

  # $('#getting-started').countdown '2017/01/01', (event) ->
  #   $(this).text event.strftime('%D days %H:%M:%S')
  #   return

  $scope.showContestDetail = false
  $scope.showContestDetails = (contest) ->
    $scope.contestSelection = contest
    $scope.showContestDetail = true

  $scope.getNumber = (num) ->
    new Array(num);

  $scope.joinContest = (con) ->
    if con.player.length >= con.max_player
      swal("Full contest")
      return false

    for p in con.participant
      if p.uid == Auth.getCurrentUser()._id
        return false

    $http.put("/api/contest/#{con._id}/join",
        Auth.getCurrentUser()
      ).success((ok) ->
        $scope.contestSelection = ok
        # $state.go("question", { contest: con._id })
      ).error((data, status, headers, config) ->
        swal("Not Active")
      )
