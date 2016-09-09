'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket) ->
  console.log "NewContestCtrl"

  $scope.loadList = ->
    $http.get("/api/program",
        null
      ).success((data, status, headers, config) ->
        $scope.programList = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.loadList()

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
    console.log $scope.contests
    for q in $scope.newContestQuestion
      if q.ans == ''
        return false
    return true

  $scope.openAns = (index) ->
    if $scope.newContestQuestion[index].showAns == true
      $scope.newContestQuestion[index].showAns = false
      return
    for q in $scope.newContestQuestion
      q.showAns = false


    $scope.newContestQuestion[index].showAns = true
