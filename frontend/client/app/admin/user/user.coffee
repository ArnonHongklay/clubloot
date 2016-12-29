'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Adminuser',
    url: '/admin/user'
    templateUrl: 'app/admin/user/user.html'
    controller: 'AdminUserCtrl'

  .state 'Adminuser.profile',
    url: '/:user_id'
    templateUrl: 'app/admin/user/profile.html'
    controller: 'AdminUserProfileCtrl'
    resolve:
      user: ($http, $stateParams) ->
        $http.get "/api/users/#{$stateParams.user_id}"


  .state 'Adminuser.contests',
    url: '/:user_id/contests'
    templateUrl: 'app/admin/user/contests.html'
    controller: 'AdminUserContestsCtrl'

  .state 'Adminuser.transactions',
    url: '/:user_id/transactions'
    templateUrl: 'app/admin/user/transactions.html'
    controller: 'AdminUserTransactionsCtrl'

  .state 'Adminuser.prizes',
    url: '/:user_id/prizes'
    templateUrl: 'app/admin/user/prizes.html'
    controller: 'AdminUserPrizesCtrl'

  .state 'Adminuser.notes',
    url: '/:user_id/notes'
    templateUrl: 'app/admin/user/notes.html'
    controller: 'AdminUserNotesCtrl'

  .state 'Adminuser.accounting',
    url: '/:user_id/accounting'
    templateUrl: 'app/admin/user/accounting.html'
    controller: 'AdminUserAccountingCtrl'
