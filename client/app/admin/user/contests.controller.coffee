
angular.module 'clublootApp'
.controller 'AdminUserContestsCtrl', ($scope, $http, socket) ->
  # console.log "AdminUserContestsCtrl"

  $scope.programList = [
    {
      name: 'Academy Awards'
      play: true
    },{
      name: 'Amazing Race'
      play: true
    },{
      name: 'Bachelor'
      play: true
    },{
      name: 'Bachelorette'
      play: true
    },{
      name: 'Big Brother'
      play: true
    },{
      name: 'Emmys'
      play: false
    },{
      name: 'Golden Globes'
      play: true
    },{
      name: 'Grammys'
      play: true
    },{
      name: 'Survivor'
      play: false
    }
  ]
