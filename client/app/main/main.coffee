'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    resolve:
      live_contests: ($http, $stateParams, $state) ->
        $http.get "/api/contest/program"
      upcomming_contests: ($http, $stateParams, $state) ->
        $http.get "/api/contest/program"
