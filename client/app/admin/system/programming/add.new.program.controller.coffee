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

  $scope.submit = (file) ->
    file.upload = Upload.upload(
      url: '/api/program'
      data:
        contest: $scope.program
        file: file)
    file.upload.then ((response) ->
      $timeout ->
        file.result = response.data

      console.log response
      #
      # $http.get('/api/prize').success((data) ->
      #   swal("added!")
      #   $scope.prizes = data
      #   $scope.prize = ""
      # )
    ), ((response) ->
      if response.status > 0
        $scope.errorMsg = response.status + ': ' + response.data
    ), (evt) ->
      # Math.min is to fix IE which reports 200% sometimes
      file.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total))
