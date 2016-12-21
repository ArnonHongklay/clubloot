angular.module 'clublootApp'
.controller 'AdminSystemDailyLootCtrl', ($scope, $http, $state, signinCounts, winnerLogs, allWinnerLogs) ->
  console.log signinCounts
  console.log winnerLogs
  $scope.signinCounts = signinCounts.data.length
  $scope.todayClaimed = winnerLogs.data
  $scope.allClaimed = allWinnerLogs.data
  $scope.lootClaimed = 0

  $scope.data = [ {
    'key': 'Quantity'
    'bar': true
    'values': [
    ]
  } ]
  console.log $scope.data
  $scope.data[0].values = []
  for claimed in $scope.allClaimed
    $scope.data[0].values.push [new Date(claimed.created_at).getTime(), claimed.prize]
  console.log $scope.data
  for winner in winnerLogs.data
    $scope.lootClaimed = $scope.lootClaimed + winner.prize

  $scope.options = chart:
    type: 'historicalBarChart'
    height: 350
    margin:
      top: 20
      right: 20
      bottom: 65
      left: 50
    x: (d) ->
      d[0]
    y: (d) ->
      d[1] / 100000
    showValues: true
    valueFormat: (d) ->
      d3.format(',.1f') d
    duration: 100
    xAxis:
      axisLabel: 'X Axis'
      tickFormat: (d) ->
        d3.time.format('%x') new Date(d)
      rotateLabels: 30
      showMaxMin: false
    yAxis:
      axisLabel: 'Y Axis'
      axisLabelDistance: -10
      tickFormat: (d) ->
        d3.format(',.1f') d
    tooltip: keyFormatter: (d) ->
      d3.time.format('%x') new Date(d)
    zoom:
      enabled: true
      scaleExtent: [
        1
        10
      ]
      useFixedDomain: false
      useNiceScale: false
      horizontalOff: false
      verticalOff: true
      unzoomEventType: 'dblclick.zoom'






