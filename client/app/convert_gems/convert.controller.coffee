'use strict'

angular.module 'clublootApp'
.controller 'ConvertGemsCtrl', ($scope, $http, socket) ->
  console.log "ConvertGemsCtrl"
  $scope.showModal = false

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"