'use strict'

_ = require 'lodash'
Prize  = require '../prize/prize.model'
Ledger = require './ledger.model'

exports.index = (req, res) ->
  Ledger.find (err, ledgers) ->
    return handleError(res, err) if err
    res.status(200).json ledgers

exports.create = (req, res) ->
  params = req.body

  Ledger.create {
    action: params['action']
    user: {
      id: params['user']._id,
      name: "#{params['user'].first_name} #{params['user'].last_name}",
      email: params['user'].email
    }
    transaction: params['transaction']
    balance: {
      diamonds:   params['user'].diamonds
      emeralds:   params['user'].emeralds
      sapphires:  params['user'].sapphires
      rubies:     params['user'].rubies
      coins:      params['user'].coins
    }
  }, (err, ledger) ->
    return handleError(res, err) if err
    res.status(201).json ledger

exports.show = (req, res) ->
  Ledger.findById req.params.id, (err, ledgers) ->
    return handleError(res, err) if err
    return res.status(404).end() unless ledgers
    res.json ledgers

exports.complete = (req, res) ->
  Ledger.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    prize.transaction.status = 'completed'
    prize.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json prize
