'use strict'

_ = require 'lodash'
WinnerLog = require './winner_log.model'

# Get list of contests
exports.index = (req, res) ->
  WinnerLog.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

# Get a single contest
exports.show = (req, res) ->
  WinnerLog.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

exports.set = (req, res) ->
  WinnerLog.remove {}, (err) ->
    console.log 'collection removed'
    return gem = {
      diamond:  { rate: 5 },
      emerald:  { rate: 5 },
      sapphire: { rate: 5 },
      ruby:     { rate: 100 }
    }

  WinnerLog.create gem, (err, gems) ->
    if err
      return handleError(err)
    # saved!
    res.json gems

# Creates a new contest in the DB.
exports.create = (req, res) ->
  WinnerLog.create req.body, (err, contest) ->
    return handleError(res, err)  if err
    res.status(201).json contest

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  WinnerLog.findById req.params.id, (err, WinnerLog) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless WinnerLog
    updated = _.merge(WinnerLog, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json WinnerLog

exports.destroy = (req, res) ->
  WinnerLog.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    contest.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
