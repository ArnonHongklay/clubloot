'use strict'

express = require 'express'
controller = require './program.controller'

multiparty = require 'connect-multiparty'
multipartyMiddleware = multiparty()

router = express.Router()

router.get '/', controller.index

router.get '/:id', controller.show
router.post '/', controller.create
router.put '/:id', controller.update
router.patch '/:id', controller.update
router.delete '/:id', controller.destroy

router.post '/uploads', multipartyMiddleware, controller.upload

module.exports = router
