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
    controller: 'ProgrammingCtrl'

  .state 'AdminSystem.programming.activeTemplate',
    url: '/activeTemplate'
    templateUrl: 'app/admin/system/active.template.html'
    controller: 'ActiveTemplateCtrl'

  .state 'AdminSystem.programming.expiredTemplate',
    url: '/expiredTemplate'
    templateUrl: 'app/admin/system/expired.template.html'
    controller: 'ExpiredTemplateCtrl'

  .state 'AdminSystem.programming.programList',
    url: '/programList'
    templateUrl: 'app/admin/system/program.list.html'
    controller: 'ProgramListCtrl'

  .state 'AdminSystem.programming.AddNewProgram',
    url: '/AddNewProgram'
    templateUrl: 'app/admin/system/add.new.program.html'
    controller: 'AddNewProgramCtrl'

  .state 'AdminSystem.programming.AddNewTemplate',
    url: '/AddNewTemplate'
    templateUrl: 'app/admin/system/add.new.template.html'
    controller: 'AddNewTemplateCtrl'

  .state 'AdminSystem.question',
    url: '/question'
    templateUrl: 'app/admin/system/question.html'
    controller: 'QuestionCtrl'

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
    resolve:
      gems: ($http, $stateParams) ->
        $http.get "/api/gem_conversion"
      buckets: ($http, $stateParams) ->
        $http.get "/api/coin_package"

  .state 'AdminSystem.users',
    url: '/users'
    templateUrl: 'app/admin/system/users.html'
    controller: 'AdminSystemCtrl'

  .state 'AdminSystem.freeloot',
    url: '/free_loot'
    templateUrl: 'app/admin/system/free_loot.html'
    controller: 'AdminSystemFreeLootCtrl'
    resolve:
      freeLoot: ($http, $stateParams) ->
        $http.get "/api/daily_loot"

