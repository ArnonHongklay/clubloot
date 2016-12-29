'use strict'

express = require 'express'
controller = require './dashboard.controller'

router = express.Router()

router.get '/', controller.index
router.get '/player', controller.player
router.get '/tournament', controller.tournament
# router.get '/lootconomy', controller.lootconomy
# router.get '/logins', controller.logins

router.get '/contests', controller.upcoming_contest
router.get '/rich', controller.rich
module.exports = router
