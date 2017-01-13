
angular.module 'clublootApp'
.controller 'AdminUserPrizesCtrl', ($scope, $http, socket, prizes) ->
  $scope.menuActive = 'Prizes'
  $scope.prizes = prizes.data

  $scope.complete = (id) ->
    $http.put("/api/ledgers/#{id}/complete").success (data) ->
      for prize in $scope.prizes
        if prize._id == data._id
          $.extend prize, data
