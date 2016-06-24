'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'contest',
    url: '/contest'
    templateUrl: 'app/contest/contest.html'
    controller: 'ContestCtrl'
  .state 'contestshow',
    url: '/contest/:contest'
    templateUrl: 'app/contest/show.html'
    controller: 'ContestShowCtrl'

'use strict'

angular.module 'clublootApp'
.controller 'ContestCtrl', ($scope, $http, socket) ->
  $('.item-show').css 'display', 'none'
  $('.item-hover').css 'display', 'block'

  $scope.hoverIn = (elm) ->
    $('.show-' + elm + '> .item-show').css 'display', 'block'
    $('.show-' + elm + '> .item-hover').css 'display', 'none'
    return
  $scope.hoverOut = (elm) ->
    $('.show-' + elm + '> .item-show').css 'display', 'none'
    $('.show-' + elm + '> .item-hover').css 'display', 'block'
    return
