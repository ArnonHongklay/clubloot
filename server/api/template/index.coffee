'use strict'

express = require 'express'
controller = require './template.controller'

router = express.Router()

router.get '/', controller.index
router.get '/program', controller.findProgramActive

router.get '/:id', controller.show
router.post '/', controller.create
router.put '/:id', controller.update
router.post '/:id/questions', controller.create_question
router.put '/:id/questions/:q', controller.update_question
router.get '/:id/questions', controller.find_question_by_templates
router.patch '/:id', controller.update
router.delete '/:id', controller.destroy

module.exports = router
