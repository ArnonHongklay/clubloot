'use strict'

angular.module 'clublootApp'
.controller 'AddNewProgramCtrl', ($scope, $http, Upload, Auth, User, $timeout) ->
  # upload later on form submit or something similar

  $scope.categories = [
    { title: 'xxx', name: 'yyyy' },
  ]

  $scope.submit = ->
    console.log $scope.image_program
    if $scope.adminProgram.file.$valid and $scope.image_program
      $scope.upload $scope.image_program
    else
      swal("Not found!!")

  $scope.upload = (file) ->
    console.log file
    Upload.upload(
      url: '/api/program/uploads'
      method: 'POST',
      data: $scope.program
      file: file
    ).then ((resp) ->
      console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data
      $scope.program.image = resp.data
      console.log $scope.program
      $http.post("/api/program",
          $scope.program
        ).success((data, status, headers, config) ->
          swal("program #{data.name} created")
        ).error((data, status, headers, config) ->
          swal("Not found!!")
        )
    ), ((resp) ->
      console.log 'Error status: ' + resp.status
    ), (evt) ->
      progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
      console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name
