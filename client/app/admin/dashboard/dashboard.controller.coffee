angular.module 'clublootApp'
.controller 'AdminDashboardCtrl', ($scope, $http, socket, player, tournament, contests, rich, tax, allplayer, signinCount, winnerLogs) ->
  $scope.player     = player.data.player
  $scope.tournament = tournament.data.tournament
  $scope.programs   = contests.data
  $scope.rich       = rich.data
  $scope.allplayer  = allplayer.data
  $scope.winnerLogs = winnerLogs.data
  $scope.prize = 0
  today = moment(new Date()).format("YYYY/M/D")
  $scope.filterDate = {from: today, to: today}

  $scope.signinCount = signinCount.data.length
  $('.datetimepicker').datetimepicker()
  $scope.signinPercent = 0

  $scope.economy = 0

  $scope.tax = 0
  $scope.signinPercent = $scope.signinCount/$scope.player * 100

  $scope.filterToday = () ->
    $scope.filterDate = {from: today, to: today}
    $scope.getDataByDate()

  $scope.getDataByDate = () ->
    f = $scope.filterDate.from
    t = $scope.filterDate.to

    $http.post("/api/v2/dashboard/tournament_by_date", {fr: f, to: t }).success (data, status, headers, config) ->
      $scope.tournament = data.length

    $http.post("/api/v2/dashboard/allplayer_by_date", {fr: f, to: t }).success (data, status, headers, config) ->
      $scope.player = data.length

    $http.post("/api/signin_log/by_date", {fr: f, to: t }).success (data, status, headers, config) ->
      oneday = 1000 * 60 * 60 * 24
      start = new Date(f)
      end   = new Date(t)
      dayCount = Math.round((end-start)/oneday)
      dayCount +=1
      console.log data.length

      $scope.signinPercent = data.length/($scope.allplayer.length*dayCount) * 100

    $http.post("/api/tax/by_date", {fr: f, to: t }).success (data, status, headers, config) ->
      $scope.tax = 0
      for tax in data
        $scope.tax += tax.coin
    $http.post("/api/winner_log/by_date", {fr: f, to: t }).success (data, status, headers, config) ->
      $scope.prize = 0
      for w in data
        $scope.prize += w.prize

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

  $scope.filterToday()
