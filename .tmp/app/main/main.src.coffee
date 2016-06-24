'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'

'use strict'

angular.module 'clublootApp'
.controller 'MainCtrl', ($scope, $http, socket) ->
  $('body').css({background: '#fff'})

  $scope.awesomeThings = []

  $http.get('/api/things').success (awesomeThings) ->
    $scope.awesomeThings = awesomeThings
    socket.syncUpdates 'thing', $scope.awesomeThings

  $scope.addThing = ->
    return if $scope.newThing is ''
    $http.post '/api/things',
      name: $scope.newThing

    $scope.newThing = ''

  $scope.deleteThing = (thing) ->
    $http.delete '/api/things/' + thing._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'

  $scope.setFilter = (value) ->
    if value == 'live'
      $scope.live = true
      $scope.upcoming = false
    else
      $scope.live = false
      $scope.upcoming = true

  $scope.setFilter('live')
