
angular.module 'clublootApp'
.controller 'AdminUserTransactionsCtrl', ($scope, $http, socket) ->
  # console.log "AdminUserTransactionsCtrl"
  $scope.transactions = [
    {id: 1, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 2, status: 'minus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 3, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 4, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 5, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 6, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 7, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 8, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 9, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 10, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 11, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 12, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 13, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 14, status: 'minus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 15, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 16, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 17, status: 'minus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 18, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
    {id: 19, status: 'plus', screenName: 'Date Time', transaction: 'Transaction#', description: 'Description', amount: 'amount'},
  ]
