'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket, $timeout, programs, templates, questions) ->
  $scope.programList = programs.data
  $scope.templates = templates.data
  $scope.questions = questions.data

  $scope.qaSelection = []

  $scope.landingContest = ->
    $http.post("/api/contest",
        $scope.contests
      ).success((data, status, headers, config) ->
        console.log $scope.programList
        console.log $scope.templates
        console.log $scope.questions

        $scope.template_id = []
        for template in $scope.templates
          if template.program == data.program #&& template.active == true
            $scope.template_id.push(template._id)
            console.log template._id

        console.log $scope.template_id[0]
        $http.get("/api/templates/#{$scope.template_id[0]}/questions",
            null
          ).success((ok) ->
            $scope.ques = ok
            console.log ok
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
    # $http.post("")


  $scope.unlessEmpty = () ->
    # console.log $scope.contests
    # for q in $scope.newContestQuestion
    #   if q.ans == ''
    #     return false
    # return true
    return if $scope.qaSelection == undefined
    return if $scope.ques == undefined
    console.log "xxxxx"
    if $scope.qaSelection.length == $scope.ques.length
      return true

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    console.log index
    $scope.qaShowAns[index] = true
    # if $scope.newContestQuestion[index].showAns == true
    #   $scope.newContestQuestion[index].showAns = false
    #   return
    # for q in $scope.newContestQuestion
    #   q.showAns = false



    # $scope.newContestQuestion[index].showAns = true
