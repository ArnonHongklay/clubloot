'use strict'

angular.module 'clublootApp'
.controller 'ActiveTemplateCtrl', ($scope, $http, Auth, User, moment) ->
  # console.log 'ActiveTemplateCtrl'

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.activeTemplate = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.checkActive = (start, end) ->
    now = new Date().getTime()
    start = new Date(start).getTime()
    end = new Date(end).getTime()
    # console.log moment(now).format('LLL')
    # console.log moment(end).format('LLL')
    # console.log "=============="
    return now < end

  $scope.loadList()
