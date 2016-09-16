'use strict'

express = require 'express'
controller = require './contest.controller'

router = express.Router()

router.get '/', controller.index
router.get '/program', controller.findProgramActive
router.get '/program/:id', controller.show
router.get '/program/:name/all', controller.findAllProgram

router.post '/', controller.create
router.put  '/:id', controller.updateQuestion

module.exports = router
