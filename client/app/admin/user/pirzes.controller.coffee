
angular.module 'clublootApp'
.controller 'AdminUserPrizesCtrl', ($scope, $http, socket, prizes, $modal) ->
  $scope.menuActive = 'Prizes'
  $scope.prizes = prizes.data

  $scope.complete = (id) ->
    $http.put("/api/ledgers/#{id}/complete").success (data) ->
      for prize in $scope.prizes
        if prize._id == data._id
          $.extend prize, data

  $scope.showDetail = (prize)->
    $modal.open(
      templateUrl: 'ModalPrizesCtrl.html'
      controller: 'ModalPrizesCtrl'
      resolve:
        prize: ($http, $stateParams) ->
          return prize
    )

.controller 'ModalPrizesCtrl', ($scope, prize) ->
  $scope.prize = prize
  console.log prize
