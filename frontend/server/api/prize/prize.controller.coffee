'use strict'

_ = require 'lodash'
Prize = require './prize.model'

# Get list of prizes
exports.index = (req, res) ->
  Prize.find (err, prizes) ->
    return handleError(res, err)  if err
    res.status(200).json prizes

# Get a single prize
exports.show = (req, res) ->
  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    res.json prize

# Creates a new prize in the DB.
exports.create = (req, res) ->
  Prize.create req.body, (err, prize) ->
    return handleError(res, err)  if err
    res.status(201).json prize

# Updates an existing prize in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    updated = _.merge(prize, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json prize

# Deletes a prize from the DB.
exports.destroy = (req, res) ->
  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    prize.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
