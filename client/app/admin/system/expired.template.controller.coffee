'use strict'

angular.module 'clublootApp'
.controller 'ExpiredTemplateCtrl', ($scope, $http, Auth, User) ->
  console.log 'ExpiredTemplateCtrl'

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.expiredTemplate = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.loadList()
