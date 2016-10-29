'use strict'
angular.module 'clublootApp'
.directive 'countDown', ->
  link: (scope, element, attributes, ctrl) ->
    date = new Date(attributes.countDown)

    cc = date.getFullYear() + '/' +
        (date.getMonth() + 1) + '/' +
         date.getDate() + ' ' +
         date.getHours() + ':' +
         date.getMinutes() + ':' +
         date.getSeconds()

    element.countdown cc, (event) ->
      $(this).text event.strftime('%H:%M:%S')
      return
