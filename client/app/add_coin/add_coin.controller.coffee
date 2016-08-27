'use strict'

angular.module 'clublootApp'
.controller 'AddCoinCtrl', ($scope, $http, socket, buckets) ->
  console.log "AddCoinCtrl"

  $scope.people = [
    { name: "John1"},
    { name: "John2"},
    { name: "John3"},
    { name: "John4"},
    { name: "John5"}
    ]

  $scope.buckets = buckets.data

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"