'use strict'

angular.module 'clublootApp'
.controller 'AddNewTemplateCtrl', ($scope, $http, Auth, User) ->
  $scope.template = {}
  $scope.items = []

  i = 1
  while i < 20
    $scope.items.push({number: i})
    i++

  $('.datetimepicker').datetimepicker()

  $('#myModal').on 'shown.bs.modal', ->
    $('#myInput').focus()
    return

  $http.get("/api/program",
      null
    ).success((data, status, headers, config) ->
      $scope.programList = data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.submit = ->
    console.log $scope.template

  $scope.setProgram = (option) ->
    $scope.template.program = option.name

  $scope.setQuestion = (option) ->
    $scope.template.number_questions = option.number
  $scope.setAnswer = (option) ->
    $scope.template.number_answers = option.number
