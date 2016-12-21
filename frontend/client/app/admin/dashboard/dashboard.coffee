'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Admindashboard',
    url: '/admin/dashboard'
    templateUrl: 'app/admin/dashboard/dashboard.html'
    controller: 'AdminDashboardCtrl'
    resolve:
      player: ($http, $stateParams, $state) ->
        $http.get "/dashboard/player"
      tournament: ($http, $stateParams, $state) ->
        $http.get "/dashboard/tournament"
      contests: ($http, $stateParams, $state) ->
        $http.get "/dashboard/contests"
      rich: ($http, $stateParams, $state) ->
        $http.get "/dashboard/rich"
