'use strict'

angular.module 'clublootApp'
.controller 'SignupCtrl', ($scope, Auth, $location, $window) ->
  $('body').css({background: '#50ACC4'})
  $scope.user = {}
  $scope.errors = {}
  $scope.register = (form) ->
    # console.log "form"
    $scope.submitted = true

    if form.$valid
      # Account created, redirect to home
      Auth.createUser
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
        birthday: $scope.user.dob
        username: $scope.user.username
      .then ->
        $location.path '/'

      .catch (err) ->
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
