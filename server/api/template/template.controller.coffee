
'use strict'

_ = require 'lodash'
Template = require './template.model'

# Get list of templates
exports.index = (req, res) ->
  Template.find (err, templates) ->
    return handleError(res, err)  if err
    res.status(200).json templates



# Get a single template
exports.show = (req, res) ->
  Template.findById req.params.id, (err, template) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless template
    res.json template

# Creates a new template in the DB.
exports.create = (req, res) ->
  Template.create req.body, (err, template) ->
    return handleError(res, err)  if err
    res.status(201).json template

# Updates an existing template in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Template.findById req.params.id, (err, template) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless template
    updated = _.merge(template, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json template

# Deletes a template from the DB.
exports.destroy = (req, res) ->
  Template.findById req.params.id, (err, template) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless template
    template.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
