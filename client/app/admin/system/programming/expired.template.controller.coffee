'use strict'

angular.module 'clublootApp'
.controller 'ExpiredTemplateCtrl', ($scope, $http, Auth, User, moment) ->
  # console.log 'ExpiredTemplateCtrl'

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.expiredTemplate = data
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
    return now > end

  $scope.loadList()
