'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'contest',
    url: '/contest'
    templateUrl: 'app/contest/contest.html'
    controller: 'ContestCtrl'
    resolve:
      contests: ($http, $stateParams) ->
        $http.get "/api/templates/program"

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
      contests: ($http, $stateParams) ->
        $http.get "/api/templates/program"
