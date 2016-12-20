
'use strict'

_ = require 'lodash'
nodemailer = require 'nodemailer'
Player = require '../api/user/user.model'
Contest = require '../api/contest/contest.model'

exports.index = (req, res) ->
  Player.find (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players

exports.player = (req, res) ->
  Player.count (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players


exports.upcoming_contest = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err) if err
    res.status(200).json contests

handleError = (res, err) ->
  res.status(500).json err
