'use strict'

express = require 'express'
controller = require './winner_log.controller'

router = express.Router()

router.get '/', controller.index
router.get '/today', controller.today
router.get '/:id', controller.show
router.post '/', controller.create
router.post '/set', controller.set
router.put '/:id', controller.update
router.delete '/:id', controller.destroy


module.exports = router
