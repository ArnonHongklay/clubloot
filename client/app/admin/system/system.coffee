'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'AdminSystem',
    url: '/admin/system'
    templateUrl: 'app/admin/system/system.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.announcements',
    url: '/announcements'
    templateUrl: 'app/admin/system/announcements.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.dailyLoot',
    url: '/dailyLoot'
    templateUrl: 'app/admin/system/dailyLoot.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.programming',
    url: '/programming'
    templateUrl: 'app/admin/system/programming.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.ladger',
    url: '/ladger'
    templateUrl: 'app/admin/system/ladger.html'
    controller: 'AdminSystemLadgerCtrl'

  .state 'AdminSystem.prizes',
    url: '/prizes'
    templateUrl: 'app/admin/system/prizes.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.taxes',
    url: '/taxes'
    templateUrl: 'app/admin/system/taxes.html'
    controller: 'AdminSystemTaxCtrl'

  .state 'AdminSystem.gems',
    url: '/gems'
    templateUrl: 'app/admin/system/gems.html'
    controller: 'AdminSystemGemCtrl'

  .state 'AdminSystem.users',
    url: '/users'
    templateUrl: 'app/admin/system/users.html'
    controller: 'AdminSystemCtrl'
