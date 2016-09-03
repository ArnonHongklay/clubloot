'use strict'

angular.module 'clublootApp'
.controller 'ProgramListCtrl', ($scope, $http, Auth, User) ->

  $http.get("/api/program",
      null
    ).success((data, status, headers, config) ->
      $scope.programList = data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )
