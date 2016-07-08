'use strict'

angular.module 'clublootApp'
.controller 'AddCoinCtrl', ($scope, $http, socket) ->
  console.log "AddCoinCtrl"


  $scope.goDashboard = () ->
    window.location.href = "/dashboard"