'use strict'

angular.module 'clublootApp'
.controller 'ActiveTemplateCtrl', ($scope, $http, Auth, User) ->
  console.log 'ActiveTemplateCtrl'

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.activeTemplate = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.loadList()
