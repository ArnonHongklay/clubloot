###*
Main application routes
###

'use strict'

errors = require './components/errors'
path = require 'path'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/things',          require './api/thing'
  app.use '/api/program',         require './api/program'
  app.use '/api/templates',       require './api/template'
  app.use '/api/questions',       require './api/question'
  app.use '/api/contest',         require './api/contest'
  app.use '/api/users',           require './api/user'
  app.use '/api/gem_conversion',  require './api/gem_conversion'
  app.use '/api/coin_package',    require './api/coin_package'
  app.use '/api/daily_loot',      require './api/daily_loot'
  app.use '/api/prize',           require './api/prize'
  app.use '/api/winner_log',      require './api/winner_log'
  app.use '/auth',                require './auth'

  # All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*').get errors[404]

  # All other routes should redirect to the index.html
  app.route('/*').get (req, res) ->
    res.sendFile path.resolve(app.get('appPath') + '/index.html')