(function() {
  'use strict';
  angular.module('clublootApp').config(function($stateProvider) {
    return $stateProvider.state('contest', {
      url: '/contest',
      templateUrl: 'app/contest/contest.html',
      controller: 'ContestCtrl'
    }).state('contestshow', {
      url: '/contest/:contest',
      templateUrl: 'app/contest/show.html',
      controller: 'ContestShowCtrl'
    });
  });

  'use strict';

  angular.module('clublootApp').controller('ContestCtrl', function($scope, $http, socket) {
    $('.item-show').css('display', 'none');
    $('.item-hover').css('display', 'block');
    $scope.hoverIn = function(elm) {
      $('.show-' + elm + '> .item-show').css('display', 'block');
      $('.show-' + elm + '> .item-hover').css('display', 'none');
    };
    $scope.hoverOut = function(elm) {
      $('.show-' + elm + '> .item-show').css('display', 'none');
      $('.show-' + elm + '> .item-hover').css('display', 'block');
    };
    return $scope.selectContest = function(contest) {
      return window.location.href = "contest/" + contest;
    };
  });

}).call(this);

//# sourceMappingURL=contest.js.map
