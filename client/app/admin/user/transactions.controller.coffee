
angular.module 'clublootApp'
.controller 'AdminUserTransactionsCtrl', ($scope, $http, socket, transactions, $modal) ->
  $scope.menuActive = 'Transactions'
  $scope.transactions = transactions.data

  $scope.transactionDetail = (transaction)->
    $modal.open(
      templateUrl: 'ModalTransactionsCtrl.html'
      controller: 'ModalTransactionsCtrl'
      resolve:
        transactions: ($http, $stateParams) ->
          return transaction
    )

.controller 'ModalTransactionsCtrl', ($scope, $http, socket, transactions) ->
  $scope.transactions = transactions
