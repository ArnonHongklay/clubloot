'use strict'

angular.module 'clublootApp'
.controller 'ContestQuestionCtrl', ($timeout, $scope, $http, Auth, templates, contest) ->
  $scope.templates = templates.data
  $scope.contests = contest.data
  $scope.current_user = Auth.getCurrentUser()
  $scope.newPlayer = false

  for player, i in $scope.contests.player

    if player.name == $scope.current_user.email
      break
    if i == $scope.contests.player.length-1
      if player.name != $scope.current_user.name
        $scope.newPlayer = true

  $scope.qaSelection = []

  $scope.template_ids = []
  for template in $scope.templates
    if template.program == $scope.contests.program
      $scope.template_ids.push(template._id)
      # console.log template._id

  $scope.template_id = $scope.template_ids[$scope.template_ids.length-1]
  $scope.contest = {}

  $scope.contest._id = $scope.contests._id
  $http.get("/api/templates/#{$scope.template_id}/questions",
      null
    ).success((ques) ->
      $scope.contest.ques = ques
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $scope.joinNewContest = () ->
    console.log $scope.contest.ques
    console.log $scope.qaSelection
    if $scope.qaSelection.length == 0
      swal 'You must answer at less 1 question'
      return

    if $scope.qaSelection.length < $scope.contest.ques.length
      swal {
        title: 'Are you sure?'
        text: 'You are not answer all questions yet'
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'Continue anyway'
        cancelButtonText: 'No'
        closeOnConfirm: false
        closeOnCancel: true
      }, (isConfirm) ->
        if isConfirm
          $http.put("/api/contest/#{$scope.contest._id}/join",
              Auth.getCurrentUser()
            ).success((ok) ->
              $scope.addScore()

            ).error((data, status, headers, config) ->
              swal("Not Active")
            )
        else
    else
      $http.put("/api/contest/#{$scope.contest._id}/join",
        Auth.getCurrentUser()
      ).success((ok) ->
        $scope.addScore()

      ).error((data, status, headers, config) ->
        swal("Not Active")
      )


  $scope.addScore = ->
    # window.location.href = "/contest"
    counter = 0
    for q,i in $scope.contest.ques
      for a in q.answers
        if a.title == $scope.qaSelection[i] && a.is_correct
          counter += 1

    $timeout ->
      # console.log counter
      $scope.contest.player = {
        uid: Auth.getCurrentUser()._id,
        name: Auth.getCurrentUser().email,
        score: counter,
        answers: $scope.qaSelection
      }

      $http.put("/api/contest/#{$scope.contest._id}/player",
        $scope.contest
      ).success (data) ->
        # console.log data
        window.location.href = "/contest"
      $scope.createNewStep = '3'
    , 300

  $scope.unlessEmpty = () ->
    return false if $scope.qaSelection == undefined
    return false if $scope.contest == undefined
    return false if $scope.contest.ques == undefined

    # console.log $scope.contest.ques
    # console.log $scope.qaSelection
    if $scope.contest.ques.length == $scope.qaSelection.length
      # console.log "xxxxx"
      return true

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    # console.log index
    $scope.qaShowAns[index] = true
