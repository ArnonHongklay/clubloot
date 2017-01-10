angular.module 'clublootApp'
.controller 'AdminSystemPrizesCtrl', ($scope, $http, $state, prize, $modal, Upload, $timeout) ->
  $scope.prizes = prize.data

  # $scope.add = ->
  #   # console.log $scope.prize
  #   $http.post("/api/prize",
  #     $scope.prize
  #   ).success((data, status, headers, config) ->
  #     $scope.reload()
  #   ).error((data, status, headers, config) ->
  #     swal("Not found!!")
  #   )

  $scope.uploadPic = (file) ->
    swal {
      title: 'Are you sure?'
      type: 'warning'
      showCancelButton: true
    }, (isConfirm) ->
      if isConfirm
      # console.log file
        file.upload = Upload.upload(
          url: '/api/prize'
          data:
            prize: $scope.prize
            file: file)
        file.upload.then ((response) ->
          $timeout ->
            file.result = response.data

          $http.get('/api/prize').success((data) ->
            swal("added!")
            $scope.prizes = data
          # console.log data
            $scope.prize = ""
          )
        ), ((response) ->
          if response.status > 0
            $scope.errorMsg = response.status + ': ' + response.data
        ), (evt) ->
          # Math.min is to fix IE which reports 200% sometimes
          file.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total))

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
    swal {
      title: 'Are you sure?'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Continue anyway'
    }, (isConfirm) ->
      if isConfirm
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
