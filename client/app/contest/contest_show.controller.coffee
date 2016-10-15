'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $state, Auth, $stateParams, contest, program, templates, $timeout) ->
  $scope.programs = program.data
  $scope.contest = contest.data
  $scope.menu = $stateParams.contest
  $scope.$apend
  $scope.templates = templates.data
  $scope.questions = []
  $scope.template_ids = []
  $scope.ansChoice = ["A", "B", "C", "D", "E", "F", "G"]
  $scope.currentPlayer
  $scope.currentTemplate = ''
  $scope.selectedContestStatus = ''

  console.log "templates"
  console.log $scope.templates
  console.log socket
  console.log "Userid"
  console.log Auth.getCurrentUser()._id

  $scope.stepBack = () ->
    window.location.href = '/contest'

  $http.get("/api/contest/program/#{$scope.contest.program}/all",
      null
    ).success((ok) ->
      $scope.allContest = ok
      for contest in $scope.allContest
        $http.get("/api/templates/#{contest.template_id}",
          null
        ).success((template) ->

          console.log "-0-0-0-0-"
        )

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

  $scope.checkstatus = (status) ->
    return status


  $scope.compairPlayer = (player) ->
    console.log "88888888888888888888888888"
    $scope.selectedCompair = {user: [], vs: [], player: player, me: $scope.currentPlayer}
    $scope.selectedCompair.name = player.name || "enemy"
    console.log $scope.currentPlayer
    return unless $scope.currentPlayer.answers
    for ans, i in $scope.currentPlayer.answers
      console.log ans
      console.log i
      $scope.selectedCompair.user.push { ans: $scope.ansChoice[ans], p: ans}
      $scope.selectedCompair.vs.push { ans: $scope.ansChoice[player.answers[i]], p: player.answers[i]}

    console.log $scope.currentPlayer.answers
    console.log "999999999999999999999999999999999"
    console.log $scope.selectedCompair


  $scope.checkAns = (ans, index) ->
    return "fa-check" if $scope.questions[index].answers[ans].is_correct == true

    for i, k in $scope.questions[index].answers
      if i.is_correct == false && k >= $scope.questions[index].answers.length
        return ""

    return "fa-times"


  socket.syncUpdates 'question', $scope.questions, (event, item, object) ->
    for question in $scope.questions
      if question._id == item._id
        $.extend $scope.questions, item
        question.answers = item.answers
        $scope.$apply()


  socket.syncUpdates 'contest', [], (event, item, object) ->
    console.log "socket contest"
    console.log event
    console.log item
    console.log "-------------------"
    if $scope.contestSelection._id == item._id
      $scope.contestSelection = item
    for contest in $scope.allContest
      if contest._id == item._id
        contest = item
    $scope.$apply()


  $scope.showContestDetail = false
  $scope.showContestDetails = (contest) ->
    $scope.alreadyJoin = false
    $scope.contestSelection = contest
    for p in $scope.contestSelection.player
      if Auth.getCurrentUser()._id == p.uid
        console.log "alreadyJoin"
        $scope.alreadyJoin = true
    console.log "showContestDetails"
    console.log contest
    cd_time = ''
    $http.get("/api/templates/#{contest.template_id}/questions",
      null
    ).success((ques) ->
      $scope.questions = ques
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )
    $scope.showContestDetail = true

    $http.get("/api/templates/#{contest.template_id}",
      null
    ).success((template) ->
      console.log template
      date = new Date(template.start_time)
      console.log date
      cc = date.getFullYear() + '/' + date.getMonth() + '/' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds()
      console.log cc
      cd_time = cc

      # $('#selectedStatus').countdown cc, (event) ->
      #   $scope.selectedContestStatus = "Started" if event.type == 'stoped'
      #   return if $scope.selectedContestStatus == 'Started'
      #   $scope.selectedContestStatus = event.strftime('%D days %H:%M:%S')
    )
    console.log "00000000000000000000999999999999999999999999999999"
    for i in contest.player
      if i.uid == Auth.getCurrentUser()._id
        console.log "same"
        $scope.currentPlayer = i
    console.log $scope.currentPlayer

  $scope.getNumber = (num) ->
    new Array(num);

  $scope.joinContest = (con) ->
    if con.player.length >= con.max_player
      swal("Full contest")
      return false

    if Auth.getCurrentUser().coins < con.fee
      swal("you need more coin to join")
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
