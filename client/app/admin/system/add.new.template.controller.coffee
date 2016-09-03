'use strict'

angular.module 'clublootApp'
.controller 'AddNewTemplateCtrl', ($scope, $http, Auth, User) ->

  $('.input-daterange input').each ->
    $(this).datepicker 'clearDates'
    return
