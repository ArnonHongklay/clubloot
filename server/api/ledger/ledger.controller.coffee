'use strict'

_ = require 'lodash'
Ledger = require './ledger.model'

exports.index = (req, res) ->
  Ledger.find (err, ledgers) ->
    return handleError(res, err) if err
    res.status(200).json ledgers

exports.create = (req, res) ->
  Ledger.create req.body, (err, ledger) ->
    return handleError(res, err) if err
    res.status(201).json ledger

exports.show = (req, res) ->
  Ledger.findById req.params.id, (err, ledgers) ->
    return handleError(res, err) if err
    return res.status(404).end() unless ledgers
    res.json ledgers
