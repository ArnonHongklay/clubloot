'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    resolve:
      contests: ($http, $stateParams, $state) ->
        $http.get '/api/contest'

  .state 'won',
    url: '/won'
    templateUrl: 'app/main/won.html'
    controller: 'WonCtrl'
    resolve:
      contests: ($http, $stateParams, $state) ->
        $http.get '/api/contest'
