'use strict'

angular.module 'clublootApp'
.controller 'QuestionCtrl', ($scope, $http, Auth, User) ->

  $http.get("/api/templates",
      null
    ).success((data, status, headers, config) ->
      $scope.questions = data[0].questions
      console.log data[0].questions
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )
