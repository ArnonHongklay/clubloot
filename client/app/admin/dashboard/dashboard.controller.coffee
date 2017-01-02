angular.module 'clublootApp'
.controller 'AdminDashboardCtrl', ($scope, $http, socket, player, tournament, contests, rich) ->
  $scope.player     = player.data.player
  $scope.tournament = tournament.data.tournament
  $scope.programs   = contests.data
  $scope.rich       = rich.data
  #
  # $('#ex2').bootstrapSlider()
