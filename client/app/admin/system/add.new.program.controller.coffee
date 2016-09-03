'use strict'

angular.module 'clublootApp'
.controller 'AddNewProgramCtrl', ($scope, $http, Upload, Auth, User, $timeout) ->
  # upload later on form submit or something similar

  $scope.categories = [
    { title: 'xxx', name: 'yyyy' },
    { title: 'xxx', name: 'yyyy' },
    { title: 'xxx', name: 'yyyy' },
    { title: 'xxx', name: 'yyyy' },
    { title: 'xxx', name: 'yyyy' },
  ]

  $scope.submit = ->
    console.log $scope.form.file
    if $scope.form.file.$valid and $scope.file
      $scope.upload $scope.file
    return

  $scope.upload = (file) ->
    console.log file
    Upload.upload(
      url: 'upload/url'
      data:
        file: file
        'name': $scope.name
        'category': $scope.category).then ((resp) ->
      console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data
      return
    ), ((resp) ->
      console.log 'Error status: ' + resp.status
      return
    ), (evt) ->
      progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
      console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name
      return
    return

  $scope.uploadFiles = (files) ->
    if files and files.length
      i = 0
      while i < files.length
        #Upload.upload({..., data: {file: files[i]}, ...})...;
        i++
      # or send them all together for HTML5 browsers:
      #Upload.upload({..., data: {file: files}, ...})...;
    return
