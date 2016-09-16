'use strict'

express = require 'express'
controller = require './contest.controller'

router = express.Router()

router.get '/', controller.index
router.get '/program', controller.findProgramActive
router.get '/program/:id', controller.show
router.get '/program/:name/all', controller.findAllProgram
router.get '/:id', controller.show

router.post '/', controller.create
router.put  '/:id', controller.updateQuestion
router.put '/:id/join', controller.joinContest

module.exports = router
