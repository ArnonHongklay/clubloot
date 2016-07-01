'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket) ->
  console.log "PrizeCtrl"


  $scope.goDashboard = () ->
    window.location.href = "/dashboard"