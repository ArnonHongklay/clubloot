'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $filter, $http, socket, $state, Auth, $stateParams, contest, program, templates, $timeout) ->
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

  # console.log "templates"
  # console.log $scope.templates
  # console.log socket
  # console.log "Userid"
  # console.log Auth.getCurrentUser()._id

  # console.log $scope.templates


  $scope.checkActive = (contest) ->
    status = contest.stage
    if contest.stage != "close"
      return true
    else
      return false
    # if status == "runing" || status == "finish"
    #   # console.log status
    #   return true
    # else if status =="cancel"
    #   return false
    # else
    #   now = new Date().getTime()
    #   start = new Date(status).getTime()
    #   return now < start

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
    $scope.selectedCompair = {
      user: [],
      vs: [],
      player: player,
      me: $scope.currentPlayer
    }

    $scope.selectedCompair.name = player.name || "enemy"
    return unless $scope.currentPlayer.answers
    for ans, i in $scope.currentPlayer.answers
      $scope.selectedCompair.user.push { ans: $scope.ansChoice[ans], p: ans}
      $scope.selectedCompair.vs.push {
        ans: $scope.ansChoice[player.answers[i]],
        p: player.answers[i]
      }

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
    if $scope.contest.program == item.program && event == "created"
      i = 0
      for c in $scope.allContest
        if c._id != item._id
          i = i + 1
        else
      if i == $scope.allContest.length
        $scope.allContest.unshift(item)
        $scope.$apply()
        return

    for contest in $scope.allContest
      # console.log contest._id == item._id
      if contest._id == item._id
        contest.stage = item.stage
        contest.player = item.player
        contest.status = item.status
        $scope.$apply()
        return
    if $scope.contestSelection._id == item._id
      $scope.contestSelection = item


  socket.syncUpdates 'contest', $scope.templates

  # $scope.orderContest = (contest) ->
  #   # console.log "contest"
  #   # console.log contest
  #   # console.log contest.max_player - contest.player.length
  #   return contest.max_player - contest.player.length

  $scope.orderContest = (contest) ->
    $scope.students = $filter('orderBy')(contest, ->
      # console.log contest
    )
    return

  $scope.showContestDetail = false
  $scope.showContestDetails = (contest) ->
    # console.log contest
    $scope.alreadyJoin = false
    $scope.contestSelection = contest
    for p in $scope.contestSelection.player
      if Auth.getCurrentUser()._id == p.uid
        # console.log "alreadyJoin"
        $scope.alreadyJoin = true
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
      date = new Date(template.start_time)
      cc = date.getFullYear() + '/' +
           date.getMonth() + '/' +
           date.getDate() + ' ' +
           date.getHours() + ':' +
           date.getMinutes() + ':' +
           date.getSeconds()
      cd_time = cc
    )
    for i in contest.player
      if i.uid == Auth.getCurrentUser()._id
        $scope.currentPlayer = i

  $scope.getNumber = (num) ->
    if (typeof(num) != "undefined")
      num = num / 500
      new Array(num)
    else
      new Array()

  $scope.joinContest = (con) ->
    if Auth.getCurrentUser().coins < con.fee
      swal("you need more coin to join")
      return false

    if con.player.length <= con.max_player
      $http.put("/api/contest/#{con._id}/join",
          Auth.getCurrentUser()
        ).success((ok) ->
          $scope.contestSelection = ok
          $state.go("question", { contest: con._id })
        ).error((data, status, headers, config) ->
          swal("Not Active")
        )
    else
      swal("Full contest")
      return false

    for p in con.participant
      if p.uid == Auth.getCurrentUser()._id
        return false

  if $stateParams.liveDashboard
    $scope.showContestDetails($scope.contest)

    if $stateParams.viewPlayer
      console.log $stateParams.viewPlayer
      console.log $('#tablePlayers tr:first-child')
      setTimeout (->
        #your code to be executed after 1 second
        $('#tablePlayers tr:first-child').click()
        return
      ), 1000
