'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $state, Auth, $stateParams, contest, program, templates) ->
  $scope.programs = program.data
  $scope.contest = contest.data
  $scope.menu = $stateParams.contest
  $scope.$apend
  $scope.templates = templates.data
  $scope.questions = []
  $scope.template_ids = []
  $scope.ansChoice = ["A", "B", "C", "D", "E", "F", "G"]
  $scope.currentPlayer

  console.log "Userid"
  console.log Auth.getCurrentUser()._id

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

  # socket.syncUpdates 'question', $scope.questions

  $scope.checkScore = (player, index) ->
    score = 0
    for uAnswer, i in player.answers
      if $scope.questions[i].answers[uAnswer].is_correct == true
        score = score + 1
    player.score = score
    score


  $scope.compairPlayer = (player) ->
    console.log "88888888888888888888888888"
    console.log player.answers
    $scope.selectedCompair = {user: [], vs: [], player: player, me: $scope.currentPlayer}
    $scope.selectedCompair.name = player.name || "enemy"
    for ans, i in $scope.currentPlayer.answers
      console.log ans
      console.log i
      $scope.selectedCompair.user.push { ans: $scope.ansChoice[ans], p: ans}
      $scope.selectedCompair.vs.push { ans: $scope.ansChoice[player.answers[i]], p: player.answers[i]}

    console.log $scope.currentPlayer.answers
    console.log "999999999999999999999999999999999"
    console.log $scope.selectedCompair


  $scope.checkAns = (ans, index) ->

    if $scope.questions[index].answers[ans].is_correct == true
      return "fa-check"
    else
      return "fa-times"


  socket.syncUpdates 'question', $scope.questions, (event, item, object) ->
    for question in $scope.questions
      if question._id == item._id
        $.extend $scope.questions, item
        question.answers = item.answers
        $scope.$apply()

  $scope.showContestDetail = false
  $scope.showContestDetails = (contest) ->
    $scope.contestSelection = contest


    $http.get("/api/templates/#{contest.template_id}/questions",
      null
    ).success((ques) ->
      $scope.questions = ques
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )
    $scope.showContestDetail = true

    for i in contest.player
      if i.uid == Auth.getCurrentUser()._id && i.answers.length > 0
        $scope.currentPlayer = i
        console.log "currentPlayer:"
        console.log $scope.currentPlayer
        return


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
        $state.go("question", { contest: con._id })
      ).error((data, status, headers, config) ->
        swal("Not Active")
      )
