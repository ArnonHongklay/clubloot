'use strict'

express = require 'express'
controller = require './dashboard.controller'

router = express.Router()

router.get '/', controller.index
router.get '/player', controller.player
router.get '/allplayer', controller.allplayer
router.post '/allplayer_by_date', controller.allplayer_by_date
router.post '/conomy_by_date', controller.conomy_by_date
router.get '/signincount', controller.signincount

router.post '/tournament_by_date', controller.tournament_by_date
router.get '/tournament', controller.tournament
# router.get '/lootconomy', controller.lootconomy
# router.get '/logins', controller.logins

router.get '/contests', controller.upcoming_contest
router.get '/rich', controller.rich
module.exports = router
