'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket, prizes) ->
  $scope.prizes = prizes.data

  for prize in $scope.prizes
    if prize.price >= 0 && prize.price <= 10
      prize.tier = 1
    else if prize.price >= 11 && prize.price <= 25
      prize.tier = 2
    else if prize.price >= 26 && prize.price <= 50
      prize.tier = 3
    else if prize.price >= 51 && prize.price <= 100
      prize.tier = 4
    else
      prize.tier = 5

  $scope.c_prize = selected: {}

  # $scope.clickPrize = (prize) ->
  #   $scope.c_prize.selected[prize._id]

  $scope.getMyPrize = ->
    swal('Please selected some prize') if $scope.c_prize.selected.length <= 0
    swal('Please check agree') unless $scope.agree


  $scope.goDashboard = () ->
    window.location.href = "/dashboard"
