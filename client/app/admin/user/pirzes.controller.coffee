
angular.module 'clublootApp'
.controller 'AdminUserPrizesCtrl', ($scope, $http, socket, prizes, $modal) ->
  $scope.menuActive = 'Prizes'
  $scope.prizes = prizes.data

  $scope.editPrize = (prize)->
    $modal.open(
      templateUrl: 'ModalPrizesEdit.html'
      controller: 'ModalPrizesEdit'
      resolve:
        prize: ($http, $stateParams) ->
          return prize
    ).result.then (->
      $http.get("/api/ledgers").success (data) ->
        $scope.prizes = data
        console.log $scope.prizes
    )

  $scope.showDetail = (prize)->
    $modal.open(
      templateUrl: 'ModalPrizesCtrl.html'
      controller: 'ModalPrizesCtrl'
      resolve:
        prize: ($http, $stateParams) ->
          return prize
    )

.controller 'ModalPrizesEdit', ($scope, $http, prize, $modalInstance) ->
  $scope.prizesEdit = prize
  $scope.error = false

  $scope.submit = ->
    if !$scope.prizesEdit
      $scope.error = true
      return
    else
      if !$scope.prizesEdit.tracking_number || !$scope.prizesEdit.carrier
        $scope.error = true
        return
      else
        $scope.error = false
        $http.put("/api/ledgers/#{$scope.prizesEdit._id}/complete",
          $scope.prizesEdit
        ).success (data) ->
          console.log data

    $modalInstance.close()

.controller 'ModalPrizesCtrl', ($scope, prize) ->
  $scope.prize = prize
  console.log prize
