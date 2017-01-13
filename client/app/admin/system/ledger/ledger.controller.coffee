angular.module 'clublootApp'
.controller 'AdminSystemLedgerCtrl', ($scope, $http, socket, $state, ledgers) ->
  # console.log "AdminSystemLedgerCtrl"
  $scope.ledgers = ledgers.data

  console.log $scope.ledgers

  $('#ex2').bootstrapSlider()

  $scope.selectLedger = (lad) ->
    $scope.showLedgerModal = lad
