angular.module 'clublootApp'
.controller 'AdminSystemAnnouncementsCtrl', ($scope, Auth, $http, $state, messages) ->
  $('.datetimepicker').datetimepicker()
  $scope.newMessage = {message:'', publish_time:'', postBy:''}

  $scope.messages = messages.data

  console.log $scope.messages

  $scope.saveMessage = () ->
    $scope.newMessage.postBy = Auth.getCurrentUser().email
    $http.post("/api/broadcast",
      $scope.newMessage
    ).success((data, status, headers, config) ->

      console.log data
      swal("Announcements created")
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )


  $scope.checkTextLenght = () ->
    if $scope.newMessage.message.length >= 400
      $scope.newMessage.message = $scope.newMessage.message.substring(0, 400)