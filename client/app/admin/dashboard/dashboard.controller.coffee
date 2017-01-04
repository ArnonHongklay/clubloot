angular.module 'clublootApp'
.controller 'AdminDashboardCtrl', ($scope, $http, socket, player, tournament, contests, rich, tax, allplayer, signinCount, winnerLogs) ->
  $scope.player     = player.data.player
  $scope.tournament = tournament.data.tournament
  $scope.programs   = contests.data
  $scope.rich       = rich.data
  $scope.allplayer  = allplayer.data
  $scope.winnerLogs = winnerLogs.data
  $scope.prize = 0

  $scope.signinCount = signinCount.data.length
  $scope.signinPercent = 0

  $scope.economy = 0

  $scope.tax = 0
  $scope.signinPercent = $scope.signinCount/$scope.player * 100

  for w in $scope.winnerLogs
    $scope.prize += w.prize

  for t in tax.data
    $scope.tax += t.coin

  for p in $scope.allplayer
    c = p.coins
    r = p.rubies * 100
    s = p.sapphires * 500
    e = p.emeralds * 2500
    d = p.diamonds * 12500
    all = c+r+s+e+d
    $scope.economy += all

  #
  # $('#ex2').bootstrapSlider()
