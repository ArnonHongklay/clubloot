
angular.module 'clublootApp'
.controller 'AdminUserTransactionsCtrl', ($scope, $http, socket, transactions) ->
  $scope.transactions = transactions.data

  console.log $scope.transactions
