'use strict'

angular.module 'clublootApp'
.controller 'AddNewTemplateCtrl', ($scope, $http, Auth, User) ->
  $scope.template = {}
  $scope.items = []

  i = 1
  while i <= 20
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

  $scope.setProgram = (option) ->
    $scope.template.program = option.name

  $scope.setQuestion = (option) ->
    $scope.template.number_questions = option.number
  $scope.setAnswer = (option) ->
    $scope.template.number_answers = option.number

  $scope.getNumber = (num) ->
    new Array(num)

  $scope.submit = ->
    console.log $scope.template
    return if Object.keys($scope.template).length < 6

    currentdate = new Date()
    start_time = new Date($scope.template.start_time)
    end_time = new Date($scope.template.end_time)

    console.log "fuck time #{start_time}"
    console.log "fuck end time #{end_time}"

    $scope.template.active = start_time > currentdate
    $scope.template.active = end_time < currentdate

    $http.post("/api/templates",
        $scope.template
      ).success((data, status, headers, config) ->
        # $scope.programList.push(data)
        $('#showModal').click()
        $scope.data_question = data
        $scope.number_questions = data.number_questions
        $scope.number_answers   = data.number_answers
        $scope.questions = new Array()

      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.add_question = ->
    # console.log $scope.data_question
    # console.log $scope.questions

    $scope.data_question.questions = $scope.questions
    $.each $scope.data_question.questions, (index, value) ->
      $scope.data_question.questions[index].answers = $.map value.answers, (v, i) ->
        [v]
      for answer, a_index in $scope.data_question.questions[index].answers
        $scope.data_question.questions[index].answers[a_index].is_correct = false

    console.log $scope.data_question.questions

    $http.post("/api/templates/#{$scope.data_question._id}/questions",
        $scope.data_question.questions
      ).success((data, status, headers, config) ->
        # $scope.programList = data
        console.log "fuck"
        console.log data
        $('#add_template').modal('hide')
        swal {
          title: 'template created'
          type: 'success'
          confirmButtonText: 'Ok'
          closeOnConfirm: true
        }, ->
          window.location.href = "/admin/system/programming/activeTemplate"
          return

      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )
