'use strict'

angular.module 'clublootApp'
.controller 'AddNewProgramCtrl', ($scope, $http, Upload, Auth, User, $timeout) ->
  # upload later on form submit or something similar

  $scope.categories = [
    { title: 'Talent', name: 'talent' },
    { title: 'Competition', name: 'competition' },
    { title: 'Dating', name: 'dating' },
    { title: 'Cooking', name: 'cooking' },
    { title: 'Lifestyle', name: 'lifestyle' },
    { title: 'Awards', name: 'awards' },
  ]

  $scope.submit = ->
    # console.log $scope.image_program
    if $scope.adminProgram.file.$valid and $scope.image_program
      $scope.upload $scope.image_program
    else
      $scope.no_image()

  $scope.no_image = ->
    $http.post("/api/program",
        $scope.program
      ).success((data, status, headers, config) ->
        swal("Program #{data.name} created")
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.upload = (file) ->
    # console.log file
    Upload.upload(
      url: '/api/program/uploads'
      method: 'POST',
      data: $scope.program
      file: file
    ).then ((resp) ->
      # console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data
      $scope.program.image = resp.data
      # console.log $scope.program
      $http.post("/api/program",
          $scope.program
        ).success((data, status, headers, config) ->
          swal("Program #{data.name} created")
        ).error((data, status, headers, config) ->
          swal("Not found!!")
        )
    ), ((resp) ->
      # console.log 'Error status: ' + resp.status
    ), (evt) ->
      progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
      # console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name
