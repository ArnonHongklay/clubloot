'use strict'

express = require 'express'
controller = require './daily.controller'

router = express.Router()

router.put '/:id/getfreeloot', controller.getFreeLoot

module.exports = router
