'use strict'

angular.module 'clublootApp'
.controller 'QuestionCtrl', ($scope, $stateParams, $http, $timeout, $window, Auth, User, id) ->
  # $scope.data      = id.data
  $scope.questions = id.data

  $scope.check = ->
    $(".check-true").checked = true

  $scope.setAns = (q_id, a_id) ->
    # console.log q_id
    # console.log a_id
    for que in $scope.questions
      if que._id == q_id
        for ans in que.answers
          if ans._id == a_id
            ans.is_correct = true
          else
            ans.is_correct = false
          console.log ans


  $scope.chooseQuestion = (q_id) ->
    # console.log $scope.questions
    for que in $scope.questions
      if que._id == q_id
        # console.log que.answers
        $http.put("/api/templates/#{$stateParams.id}/questions/#{que._id}",
            que
          ).success((data, status, headers, config) ->
            console.log que = data
          ).error((data, status, headers, config) ->
            swal("Not found!!")
          )
