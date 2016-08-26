'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Adminuser',
    url: '/admin/user'
    templateUrl: 'app/admin/user/profile.html'
    controller: 'AdminUserCtrl'
