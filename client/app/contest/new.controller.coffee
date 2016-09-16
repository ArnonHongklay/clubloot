'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket, $timeout, Auth, programs, templates, questions) ->
  $scope.programList = programs.data
  $scope.templates = templates.data
  $scope.questions = questions.data

  $scope.qaSelection = []

  $scope.landingContest = ->
    $scope.contests.owner = Auth.getCurrentUser().email
    $scope.contests.loot.category = "gem-red"
    $scope.contests.participant = []
    $scope.contests.participant.push(Auth.getCurrentUser())
    $http.post("/api/contest",
        $scope.contests
      ).success((data, status, headers, config) ->
        # console.log $scope.programList
        # console.log $scope.templates
        # console.log $scope.questions

        console.log data
        $scope.template_ids = []
        for template in $scope.templates
          if template.program == data.program #&& template.active == true
            $scope.template_ids.push(template._id)
            console.log template._id

        $scope.template_id = $scope.template_ids[$scope.template_ids.length-1]

        $scope.contest = {}
        $scope.contest.id = data._id
        $http.get("/api/templates/#{$scope.template_id}", null).success (d) ->
          $scope.contest.status = d.start_time

        $http.get("/api/templates/#{$scope.template_id}/questions",
            null
          ).success((ques) ->
            $scope.contest.challenge = ques.length
            $scope.contest.ques = ques
          ).error((data, status, headers, config) ->
            swal("Not Active")
          )

        $scope.createNewStep = '2'
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.numbers = [
    { title: 1 },
    { title: 2 },
    { title: 3 },
    { title: 4 },
    { title: 5 }
  ]

  $scope.newContestQuestion = [
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false}
  ]

  $scope.finishNewContest = () ->
    window.location.href = '/dashboard'

  $scope.doneProcessing =  ->
    console.log $scope.newContestQuestion

  $scope.unlessEmpty = () ->
    return false if $scope.qaSelection == undefined
    return false if $scope.contest == undefined
    return false if $scope.contest.ques == undefined

    console.log $scope.contest.ques
    console.log $scope.qaSelection
    if $scope.contest.ques.length == $scope.qaSelection.length
      console.log "xxxxx"
      return true

  $scope.addScore = ->
    counter = 0
    for q,i in $scope.contest.ques
      for a in q.answers
        console.log a
        console.log a.is_correct
        console.log $scope.qaSelection[i]
        if a.title == $scope.qaSelection[i] && a.is_correct
          console.log "=============================================fuck"
          counter += 1

    $timeout ->
      console.log counter
      $scope.contest.player = [{ uid: Auth.getCurrentUser()._id, name: Auth.getCurrentUser().email, score: counter }]
      $http.put("/api/contest/#{$scope.contest.id}", $scope.contest).success (data) ->
        console.log data
      $scope.createNewStep = '3'
    , 300

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    console.log index
    $scope.qaShowAns[index] = true
