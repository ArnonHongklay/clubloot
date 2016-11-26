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
    templateUrl: 'app/admin/system/announcements/announcements.html'
    controller: 'AdminSystemAnnouncementsCtrl'

  .state 'AdminSystem.dailyLoot',
    url: '/dailyLoot'
    templateUrl: 'app/admin/system/dailyLoot/dailyLoot.html'
    controller: 'AdminSystemDailyLootCtrl'

  .state 'AdminSystem.programming',
    url: '/programming'
    templateUrl: 'app/admin/system/programming/programming.html'
    controller: 'ProgrammingCtrl'

  .state 'AdminSystem.programming.activeTemplate',
    url: '/activeTemplate'
    templateUrl: 'app/admin/system/programming/active.template.html'
    controller: 'ActiveTemplateCtrl'

  .state 'AdminSystem.programming.expiredTemplate',
    url: '/expiredTemplate'
    templateUrl: 'app/admin/system/programming/expired.template.html'
    controller: 'ExpiredTemplateCtrl'

  .state 'AdminSystem.programming.programList',
    url: '/programList'
    templateUrl: 'app/admin/system/programming/program.list.html'
    controller: 'ProgramListCtrl'

  .state 'AdminSystem.programming.AddNewProgram',
    url: '/AddNewProgram'
    templateUrl: 'app/admin/system/programming/add.new.program.html'
    controller: 'AddNewProgramCtrl'

  .state 'AdminSystem.programming.AddNewTemplate',
    url: '/AddNewTemplate'
    templateUrl: 'app/admin/system/programming/add.new.template.html'
    controller: 'AddNewTemplateCtrl'

  .state 'AdminSystem.programming.question',
    url: '/question/:id'
    templateUrl: 'app/admin/system/programming/question.html'
    controller: 'QuestionCtrl'
    resolve:
      id: ($http, $state, $stateParams) ->
        console.log $stateParams.id
        $http.get "/api/templates/#{$stateParams.id}/questions"

  .state 'AdminSystem.ledger',
    url: '/ledger'
    templateUrl: 'app/admin/system/ledger/ledger.html'
    controller: 'AdminSystemLedgerCtrl'

  .state 'AdminSystem.prizes',
    url: '/prizes'
    templateUrl: 'app/admin/system/prizes/prizes.html'
    controller: 'AdminSystemPrizesCtrl'
    resolve:
      prize: ($http, $state, $stateParams) ->
        $http.get "/api/prize"

  .state 'AdminSystem.taxes',
    url: '/taxes'
    templateUrl: 'app/admin/system/taxes/taxes.html'
    controller: 'AdminSystemTaxCtrl'

  .state 'AdminSystem.gems',
    url: '/gems'
    templateUrl: 'app/admin/system/gems/gems.html'
    controller: 'AdminSystemGemCtrl'
    resolve:
      gems: ($http, $stateParams) ->
        $http.get "/api/gem_conversion"
      buckets: ($http, $stateParams) ->
        $http.get "/api/coin_package"

  .state 'AdminSystem.winners',
    url: '/winners'
    templateUrl: 'app/admin/system/winners/winners.html'
    controller: 'AdminSystemWinnerCtrl'
    resolve:
      winners: ($http, $stateParams) ->
        $http.get "/api/winner_log"

  .state 'AdminSystem.users',
    url: '/users'
    templateUrl: 'app/admin/system/users/users.html'
    controller: 'AdminSystemUserCtrl'
    resolve:
      user: ($http, $stateParams) ->
        $http.get "/api/users/all"

  .state 'AdminSystem.freeloot',
    url: '/free_loot'
    templateUrl: 'app/admin/system/dailyloot/free_loot.html'
    controller: 'AdminSystemFreeLootCtrl'
    resolve:
      freeLoot: ($http, $stateParams) ->
        $http.get "/api/daily_loot"
