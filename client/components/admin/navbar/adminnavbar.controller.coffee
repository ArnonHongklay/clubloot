'use strict'

angular.module 'clublootApp'
.controller 'AdminNavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [
    {
      title: 'Dashboard'
      link: '/admin/dashboard'
    },
    {
      title: 'Services',
      link: '/admin/service'
    },
    {
      title: 'System',
      link: '/admin/system'
    }
  ]

  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()
