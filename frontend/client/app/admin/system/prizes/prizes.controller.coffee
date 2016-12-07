angular.module 'clublootApp'
.controller 'AdminSystemPrizesCtrl', ($scope, $http, $state, prize) ->
  $scope.prizes = prize.data

  $scope.add = ->
    $http.post("/api/prize",
      $scope.prize
    ).success((data, status, headers, config) ->
      $scope.reload()
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

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
