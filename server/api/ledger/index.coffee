'use strict'

express = require 'express'
controller = require './ledger.controller'

router = express.Router()

router.get '/',                 controller.index
router.post '/',                controller.create
router.get '/:id',              controller.show
router.put '/:id/complete',     controller.complete

module.exports = router
