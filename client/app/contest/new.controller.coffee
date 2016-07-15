'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket) ->
  console.log "NewContestCtrl"

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

  $scope.unlessEmpty = () ->
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
