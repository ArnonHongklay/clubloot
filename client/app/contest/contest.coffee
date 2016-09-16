'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'contest',
    url: '/contest'
    templateUrl: 'app/contest/contest.html'
    controller: 'ContestCtrl'
    resolve:
      contests: ($http, $stateParams, $state) ->
        console.log $state
        $http.get "/api/contest/program"

  .state 'contestnew',
    url: '/contest/new'
    templateUrl: 'app/contest/new.html'
    controller: 'NewContestCtrl'
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      questions: ($http, $stateParams) ->
        $http.get "/api/questions"
      programs: ($http, $stateParams) ->
        $http.get "/api/templates/program"

  .state 'contestshow',
    url: '/contest/:contest'
    templateUrl: 'app/contest/show.html'
    controller: 'ContestShowCtrl'
    resolve:
      program: ($http, $stateParams) ->
        $http.get "/api/contest/program"
      contest: ($http, $stateParams) ->
        $http.get "/api/contest/program/#{$stateParams.contest}"

  .state 'question',
    url: '/question/:contest/'
    templateUrl: 'app/contest/question.html'
    controller: 'QuestionCtrl'
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      contest: ($http, $stateParams) ->
        $http.get "/api/contest/#{$stateParams.contest}"
