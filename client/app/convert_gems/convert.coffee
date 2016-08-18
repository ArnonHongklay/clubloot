'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'convert_gems',
    url: '/convert_gems'
    templateUrl: 'app/convert_gems/convert.html'
    controller: 'ConvertGemsCtrl'
