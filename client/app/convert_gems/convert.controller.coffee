'use strict'

angular.module 'clublootApp'
.controller 'ConvertGemsCtrl', ($scope, $http, socket, $timeout, gems) ->
  console.log "ConvertGemsCtrl"
  $scope.showModal = false
  $scope.gems = gems.data[0]

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
      if $scope.currentGem.emerald < $scope.gems.diamond.rate
        $scope.alertText  = "You need more Emerald"

    else if type == "emerald"
      rate = 20000
      $scope.titleText = "Convert Sapphire to Emerald"
      if $scope.currentGem.sapphire < $scope.gems.emerald.rate
        $scope.alertText = "You need more Sapphire"

    else if type == "sapphire"
      rate = 10000
      $scope.titleText = "Convert Ruby to Sapphire"
      if $scope.currentGem.ruby < $scope.gems.sapphire.rate
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
    coinFee = 0
    gemMinus = 0
    subType = ''
    console.log $scope.mirorCurrent = $scope.currentGem
    if type == "diamond"
      subType = "emerald"
      coinFee = 30000
      $scope.currentGem.diamond = $scope.currentGem.diamond + 1
      $scope.currentGem.emerald = $scope.currentGem.emerald - $scope.gems.diamond.rate
      $scope.currentGem.coins   = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.diamond.rate

    else if type == "emerald"
      subType = "sapphire"
      coinFee = 20000
      $scope.currentGem.emerald  = $scope.currentGem.emerald + 1
      $scope.currentGem.sapphire = $scope.currentGem.sapphire - $scope.gems.emerald.rate
      $scope.currentGem.coins   = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.emerald.rate

    else if type == "sapphire"
      subType = "ruby"
      coinFee = 10000
      $scope.currentGem.sapphire = $scope.currentGem.sapphire + 1
      $scope.currentGem.ruby = $scope.currentGem.ruby - $scope.gems.sapphire.rate
      $scope.currentGem.coins   = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.sapphire.rate
    $scope.$apply()
    $(".value-box-added."+type+" .num-noti").html("+1")
    $(".value-box-added."+subType+" .num-noti").html("-"+gemMinus)
    $(".value-box-added.coins .num-noti").html("-"+coinFee)

    $(".value-box-added."+type+" .num-noti").addClass("plus show")
    $(".value-box-added."+subType+" .num-noti").addClass("minus show")
    $(".value-box-added.coins .num-noti").addClass("minus show")

    $(".value-box-added."+type).addClass('changed')
    $(".value-box-added."+type).addClass('shake-rotate shake-constant')
    $timeout ->
      $(".value-box-added."+type).removeClass('shake-rotate shake-constant')
    , 1000
    $timeout ->
      $(".value-box-added.coins .num-noti").removeClass("minus show")
      $(".value-box-added."+type).removeClass('changed')
      $(".value-box-added."+type+" .num-noti").removeClass("plus show")
      $(".value-box-added."+subType+" .num-noti").removeClass("minus show")
    , 2000

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"