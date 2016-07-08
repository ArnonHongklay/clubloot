'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'prize',
    url: '/prize'
    templateUrl: 'app/prize/prize.html'
    controller: 'PrizeCtrl'
