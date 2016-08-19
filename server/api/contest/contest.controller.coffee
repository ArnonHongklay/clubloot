
'use strict'

_ = require 'lodash'
Contest = require './contest.model'

# Get list of contests
exports.index = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests



# Get a single contest
exports.show = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

# Creates a new contest in the DB.
exports.create = (req, res) ->
  Contest.create req.body, (err, contest) ->
    return handleError(res, err)  if err
    res.status(201).json contest

# Updates an existing contest in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

# Deletes a contest from the DB.
exports.destroy = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    contest.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
