'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket, prizes, Auth) ->
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

  $scope.checkPrize = (selected) ->
    sum = 0
    for prize in selected
      sum += parseInt(prize.price)
    sum

  $scope.getMyPrize = ->
    if $scope.c_prize.selected.length == 0 or $scope.c_prize.selected.length == undefined
      swal('Please selected some prize')
      return
    unless $scope.agree
      swal('Please check agree')
      return

    sumOfPrize = $scope.checkPrize($scope.c_prize.selected)
    if Auth.getCurrentUser().diamonds < sumOfPrize
      swal('need more diamonds')
      return
    else
      Auth.getCurrentUser().diamonds = Auth.getCurrentUser().diamonds - sumOfPrize
      $http.put("/api/users/#{Auth.getCurrentUser()._id}", Auth.getCurrentUser()).success (data) ->
        $http.post("/api/ledgers",
          { user_id: Auth.getCurrentUser()._id, transaction: 'prize', amount: sumOfPrize, balance: Auth.getCurrentUser().diamonds }
        ).success((data, status, headers, config) ->
          console.log data
        ).error((data, status, headers, config) ->
          swal("Not found!!")
        )

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"
