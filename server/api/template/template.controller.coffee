
'use strict'

_ = require 'lodash'
Template = require './template.model'

# Get list of templates
exports.index = (req, res) ->
  Template.find (err, templates) ->
    return handleError(res, err)  if err
    res.status(200).json templates

exports.create = (req, res) ->
  Template.create req.body, (err, template) ->
    return handleError(res, err)  if err
    res.status(201).json template
