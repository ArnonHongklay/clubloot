'use strict'

angular.module 'clublootApp'
.controller 'NavbarCtrl', ($scope, $location, Auth, $http, $rootScope) ->
  console.log Auth.getCurrentUser()
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
        console.log "---------------"
        console.log data
        $rootScope.freeLootToday = data.freeCoins
        $rootScope.showDailyLoot = true
      ).error((data, status, headers, config) ->

      )

  if Auth.getCurrentUser()
    console.log "8888888888888888"
    console.log Auth.getCurrentUser()
    $http.get("/api/users/#{Auth.getCurrentUser()._id}").success (data) =>
      console.log data
      $scope.getFreeLoot() if data.free_loot

