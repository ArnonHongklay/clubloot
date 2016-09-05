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

  $('#add_template').on 'shown.bs.modal', ->
    $('#myInput').focus()
    return

  # $scope.programList = {}
  $http.get("/api/program",
      null
    ).success((data, status, headers, config) ->
      $scope.programList = data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.submit = ->
    # console.log $scope.template
    # return if Object.keys($scope.template).length < 6

    currentdate = new Date()
    start_time = new Date($scope.template.start_time)
    end_time = new Date($scope.template.end_time)

    $scope.template.active = start_time > currentdate
    $scope.template.active = end_time < currentdate

    $http.post("/api/templates",
        $scope.template
      ).success((data, status, headers, config) ->
        # $scope.programList.push(data)
        $('#showModal').click()

        # console.log data
        $scope.data_question = data

        $scope.number_questions = data.number_questions
        $scope.number_answers   = data.number_answers

        # console.log $scope.number_questions
        # console.log $scope.number_answers

        # ans = 0
        # que = 0
        #
        $scope.questions = new Array()
        # question = new Object()
        #
        # while que < $scope.number_questions
        #   console.log que
        #   answers = new Array()
        #   while ans < $scope.number_answers
        #     answers.push({que: que, title: ans++})
        #
        #   $scope.questions.push({title: que, answers: answers})
        #   que += 1
        #
        # console.log $scope.questions
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.setProgram = (option) ->
    $scope.template.program = option.name

  $scope.setQuestion = (option) ->
    $scope.template.number_questions = option.number
  $scope.setAnswer = (option) ->
    $scope.template.number_answers = option.number

  $scope.getNumber = (num) ->
    new Array(num)

  $scope.add_question = ->
    console.log $scope.questions
