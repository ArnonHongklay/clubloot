
angular.module 'clublootApp'
.controller 'AdminUserTransactionsCtrl', ($scope, $http, socket, transactions) ->
  $scope.menuActive = 'Transactions'
  $scope.transactions = transactions.data
