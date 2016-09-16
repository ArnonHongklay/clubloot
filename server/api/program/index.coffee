'use strict'

express = require 'express'
controller = require './program.controller'

multiparty = require 'connect-multiparty'
multipartyMiddleware = multiparty()

router = express.Router()

router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', controller.create
router.post '/uploads', multipartyMiddleware, controller.upload

module.exports = router
