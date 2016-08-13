'use strict'

angular.module 'clublootApp'
.controller 'QuestionCtrl', ($scope, $http, Auth, User) ->

  $scope.questions = [
    {
      title: '[question_1]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },{
      title: '[question_2]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },{
      title: '[question_3]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },{
      title: '[question_4]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },{
      title: '[question_5]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },{
      title: '[question_6]'
      answers: [
        '[answer_1]'
        '[answer_2]'
        '[answer_3]'
        '[answer_4]'
      ]
    },
  ]
