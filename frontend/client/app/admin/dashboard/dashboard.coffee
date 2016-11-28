'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Admindashboard',
    url: '/admin/dashboard'
    templateUrl: 'app/admin/dashboard/dashboard.html'
    controller: 'AdminDashboardCtrl'
