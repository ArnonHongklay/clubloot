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


  $scope.checkActive = (time) ->
    console.log new Date(time)+":::::"+ new Date()
    t2 = new Date(time).getTime()
    t1 = new Date().getTime()
    a = parseFloat (t2 - t1) / (24 * 3600 * 1000)
    return a > 0


  $scope.loadList()
