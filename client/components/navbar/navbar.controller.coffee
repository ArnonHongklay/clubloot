'use strict'

angular.module 'clublootApp'
.controller 'NavbarCtrl', ($scope, $location, Auth, $http, $rootScope, $timeout) ->
  $scope.menu = [
    {
      title: 'Dashboard'
      link: '/'
    },
    {
      title: 'Contests',
      link: '/contest'
    },
    {
      title: 'Prizes',
      link: '/prize'
    }

  ]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.CurrentUser =  Auth.getCurrentUser()
  $rootScope.currentUser = Auth.getCurrentUser()

  console.log "================="
  console.log $scope.getCurrentUser()


  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.getFreeLoot = () ->
    id = $scope.CurrentUser._id
    $http.put("/api/daily_loot/#{id}/getfreeloot",
        id: id
      ).success((data, status, headers, config) ->
        $rootScope.freeLootToday = data.freeCoins
        $rootScope.showDailyLoot = true

        $scope.CurrentUser = data.user
        $rootScope.currentUser = data.user

      ).error((data, status, headers, config) ->

      )
  $timeout ->
    if Auth.getCurrentUser()
      $http.get("/api/users/#{Auth.getCurrentUser()._id}").success (data) =>
        console.log data
        $scope.getFreeLoot() if data.free_loot
  , 300

