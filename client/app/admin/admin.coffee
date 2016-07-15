'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin',
    url: '/admin'
    templateUrl: 'app/admin/admin.html'
    controller: 'AdminCtrl'
  .state 'admin.programming',
    url: '/programming'
    templateUrl: 'app/admin/programming.html'
    controller: 'ProgrammingCtrl'
  .state 'admin.programming.activeTemplate',
    url: '/activeTemplate'
    templateUrl: 'app/admin/active.template.html'
    controller: 'ActiveTemplateCtrl'
  .state 'admin.programming.expiredTemplate',
    url: '/expiredTemplate'
    templateUrl: 'app/admin/expired.template.html'
    controller: 'ExpiredTemplateCtrl'
  .state 'admin.programming.programList',
    url: '/programList'
    templateUrl: 'app/admin/program.list.html'
    controller: 'ProgramListCtrl'
  .state 'admin.programming.AddNewProgram',
    url: '/AddNewProgram'
    templateUrl: 'app/admin/add.new.program.html'
    controller: 'AddNewProgramCtrl'
  .state 'admin.programming.AddNewTemplate',
    url: '/AddNewTemplate'
    templateUrl: 'app/admin/add.new.template.html'
    controller: 'AddNewTemplateCtrl'

  .state 'admin.question',
    url: '/question'
    templateUrl: 'app/admin/question.html'
    controller: 'QuestionCtrl'
