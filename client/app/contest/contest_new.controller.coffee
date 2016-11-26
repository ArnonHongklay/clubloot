'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket, $timeout, Auth, programs, templates, questions) ->
  $scope.programList = programs.data
  $scope.templates = templates.data
  $scope.questions = questions.data
  $scope.contests = {loot:{prize:'',category:''}}
  # console.log $scope.templates

  $scope.qaSelection = []

  $scope.checkActive = (start, end) ->
    now = new Date().getTime()
    start = new Date(start).getTime()
    end = new Date(end).getTime()
    # console.log moment(now).format('LLL')
    # console.log moment(end).format('LLL')
    # console.log "=============="
    return now < end

  $scope.landingContest = ->
    $scope.contests.owner = Auth.getCurrentUser().email
    $scope.contests.loot.category = "gem-red"
    $scope.contests.participant = []
    $scope.contests.participant.push(Auth.getCurrentUser())
    $scope.contests.fee = $scope.addFeeTax($scope.contests.fee)
    $http.post("/api/contest",
        $scope.contests
      ).success((data, status, headers, config) ->
        # console.log $scope.programList
        # console.log $scope.templates
        # console.log $scope.questions

        # console.log data
        $scope.template_ids = []
        for template in $scope.templates
          if template.program == data.program #&& template.active == true
            $scope.template_ids.push(template._id)
            # console.log template._id

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
    { title: 2 },
    { title: 3 },
    { title: 4 },
    { title: 5 },
    { title: 6 },
    { title: 7 },
    { title: 8 },
    { title: 9 },
    { title: 10 },
    { title: 11 },
    { title: 12 },
    { title: 13 },
    { title: 14 },
    { title: 15 },
    { title: 16 },
    { title: 17 },
    { title: 18 },
    { title: 19 },
    { title: 20 }
  ]

  $scope.fees = [
    { title: 500 },
    { title: 1000 },
    { title: 1500 },
    { title: 2000 },
    { title: 2500 },
    { title: 3000 },
    { title: 3500 },
    { title: 4000 }
  ]

  # for fee in $scope.fees
  #   tax = (fee.title * 10) / 100
  #   fee.title = fee.title + tax

  $scope.prizes = [
    { title: 1, fee: 5000  },
    { title: 2, fee: 10000 },
    { title: 3, fee: 15000},
    { title: 4, fee: 20000 },
    { title: 5, fee: 30000 }
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

  $scope.addFeeTax = (fee) ->
    tax = (fee * 10) / 100
    parseInt(fee) + parseInt(tax)

  $scope.calPrize = () ->
    # console.log "sdsdsddsdsds"
    # console.log parseInt(
    #   parseInt($scope.contests.fee) * parseInt($scope.contests.max_player)
    # )
    tax = parseInt($scope.contests.fee) * parseInt($scope.contests.max_player) * 10 / 100
    $scope.contests.loot.prize = parseInt(parseInt($scope.contests.fee) * parseInt($scope.contests.max_player))

  $scope.finishNewContest = () ->
    window.location.href = '/dashboard'

  $scope.doneProcessing =  ->
    # console.log $scope.newContestQuestion

  $scope.unlessEmpty = () ->
    return false if $scope.qaSelection == undefined
    return false if $scope.contest == undefined
    return false if $scope.contest.ques == undefined

    # console.log $scope.contest.ques
    # console.log $scope.qaSelection
    if $scope.contest.ques.length == $scope.qaSelection.length
      # console.log "xxxxx"
      return true

  $scope.addScore = ->
    counter = 0
    for q,i in $scope.contest.ques
      for a in q.answers
        # console.log a
        # console.log a.is_correct
        # console.log $scope.qaSelection[i]
        if a.title == $scope.qaSelection[i] && a.is_correct
          # console.log "=============================================fuck"
          counter += 1

    $timeout ->
      # console.log counter
      $scope.contest.player = [{
        uid: Auth.getCurrentUser()._id,
        name: Auth.getCurrentUser().email,
        score: counter,
        answers: $scope.qaSelection
      }]

      $http.put("/api/contest/#{$scope.contest.id}",
        $scope.contest
      ).success (data) ->
        # console.log data
      $scope.createNewStep = '3'
    , 300

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    # console.log index
    $scope.qaShowAns[index] = true
