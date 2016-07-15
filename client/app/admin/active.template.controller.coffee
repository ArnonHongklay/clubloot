'use strict'

angular.module 'clublootApp'
.controller 'ActiveTemplateCtrl', ($scope, $http, Auth, User) ->
  console.log 'ActiveTemplateCtrl'

  $scope.activeTemplate = [
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    },
    {
      name: 'The Bachelorette – Season 10 – Episode 2'
      game: 'Bachelorette'
      created: '05/10/2016 08:00 PM'
      updated: '05/10/2016 10:00 PM'
    }
  ]
