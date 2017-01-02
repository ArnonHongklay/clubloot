angular.module 'clublootApp'
.controller 'AdminSystemPrizesCtrl', ($scope, $http, $state, prize, $modal) ->
  $scope.prizes = prize.data

  $scope.add = ->
    console.log $scope.prize
    $http.post("/api/prize",
      $scope.prize
    ).success((data, status, headers, config) ->
      $scope.reload()
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.edit = (id) ->
    for prize in $scope.prizes
      if prize._id == id
        $scope.prizeEdit = prize

    $modal.open(
      templateUrl: 'myModal.html'
      controller: 'ModalDialogController'
      resolve:
        prizes: ($http, $stateParams) ->
          return $scope.prizeEdit
      ).result.then (->
      # alert 'OK'
      return
    ), ->
      # alert 'Cancel'
      return
    return

  $scope.remove = (id) ->
    $http.delete("/api/prize/#{id}").success((data) ->
      $scope.reload()
    ).error((data) ->
      swal("remove error! #{data}")
    )

  $scope.reload = ->
    $http.get("/api/prize").success((data) ->
      $scope.prizes = data
    )

.controller 'ModalDialogController', ($scope, $modalInstance, prizes, $http) ->
  $scope.prizeEdit = prizes
  $scope.ok = ->
    $http.put("/api/prize/#{$scope.prizeEdit._id}", $scope.prizeEdit).success (data) ->
      $modalInstance.close()

    return
  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
    return
