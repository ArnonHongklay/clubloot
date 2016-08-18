'use strict'

angular.module 'clublootApp'
.controller 'ConvertGemsCtrl', ($scope, $http, socket) ->
  console.log "ConvertGemsCtrl"
  $scope.showModal = false

  $scope.currentGem = {diamond: 5, emerald: 4, sapphire: 25, ruby: 55, coins: 100000}
  $scope.mirorCurrent = $scope.currentGem
  $scope.titleText = ""
  $scope.alertText = ""

  $scope.convertGem = (type)->
    $(".value-box-added").removeClass('changed')
    rate = 0
    if type == "diamond"
      rate = 30000
      $scope.titleText = "Convert Emerald to Diamond"
      if $scope.currentGem.emerald < 5
        $scope.alertText  = "You need more Emerald"

    else if type == "emerald"
      rate = 20000
      $scope.titleText = "Convert Sapphire to Emerald"
      if $scope.currentGem.sapphire < 5
        $scope.alertText = "You need more Sapphire"

    else if type == "sapphire"
      rate = 10000
      $scope.titleText = "Convert Ruby to Sapphire"
      if $scope.currentGem.ruby < 5
        $scope.alertText = "You need more Ruby"

    if $scope.currentGem.coins < rate
      $scope.alertText = "You need more Coins"

    if $scope.alertText != ""
      swal {
        title: 'Something wrong'
        text: $scope.alertText
        type: 'warning'
        confirmButtonColor: '#50ACC4'
        confirmButtonText: 'OK'
      }, ->
        $scope.alertText = ""
        return
    else
      swal {
        title: 'Are you sure?'
        text: $scope.titleText
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#50ACC4'
        confirmButtonText: 'convert'
        html: false
      }, ->
        $scope.alertText = ""
        $scope.confirmConvert(type)
        return

  $scope.confirmConvert = (type) ->
    console.log $scope.mirorCurrent = $scope.currentGem
    if type == "diamond"
      $scope.currentGem.diamond = $scope.currentGem.diamond + 1
      $scope.currentGem.emerald = $scope.currentGem.emerald - 5
      $scope.currentGem.coins   = $scope.currentGem.coins - 30000
      $(".value-box-added."+type).addClass('changed')

    else if type == "emerald"
      $scope.currentGem.emerald  = $scope.currentGem.emerald + 1
      $scope.currentGem.sapphire = $scope.currentGem.sapphire - 5
      $scope.currentGem.coins   = $scope.currentGem.coins - 20000
      $(".value-box-added."+type).addClass('changed')

    else if type == "sapphire"
      $scope.currentGem.sapphire = $scope.currentGem.sapphire + 1
      $scope.currentGem.ruby = $scope.currentGem.ruby - 5
      $scope.currentGem.coins   = $scope.currentGem.coins - 10000
      $(".value-box-added."+type).addClass('changed')
    $scope.$apply()

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"