'use strict'

angular.module 'clublootApp'
.controller 'AddNewTemplateCtrl', ($scope, $http, Auth, User) ->

  # $('#start-date').each ->
  #   $(this).datetimepicker 'clearDates'
  $('#start-date').each ->
    $(this).datepicker 'clearDates'
    return
  $('#start-time').datetimepicker()
  # $('#end-date').each ->
  #   $(this).datepicker 'clearDates'
  #   return
  # $('#end-time').each ->
  #   $(this).datetimepicker format: 'HH:mm'
  #   return

  $scope.number = 100;
  $scope.getNumber = (n) ->
    new Array(n)

  $http.get("/api/program",
      null
    ).success((data, status, headers, config) ->
      $scope.programList = data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.changeProgram = (option) ->
    console.log(option)
