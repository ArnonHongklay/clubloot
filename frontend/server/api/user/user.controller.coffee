'use strict'

_ = require 'lodash'

User = require './user.model'
Contest = require '../contest/contest.model'
WinnerLog = require './winner_log/winner_log.model'

passport = require 'passport'
config = require '../../config/environment'
SigninLog = require '../signin_log/signin_log.model'
jwt = require 'jsonwebtoken'

DateDiff =
  inDays: (d1, d2) ->
    t2 = d2.getTime()
    t1 = d1.getTime()
    parseInt (t2 - t1) / (24 * 3600 * 1000)
  inWeeks: (d1, d2) ->
    t2 = d2.getTime()
    t1 = d1.getTime()
    parseInt (t2 - t1) / (24 * 3600 * 1000 * 7)
  inMonths: (d1, d2) ->
    d1Y = d1.getFullYear()
    d2Y = d2.getFullYear()
    d1M = d1.getMonth()
    d2M = d2.getMonth()
    d2M + 12 * d2Y - (d1M + 12 * d1Y)
  inYears: (d1, d2) ->
    d2.getFullYear() - d1.getFullYear()

validationError = (res, err) ->
  res.status(422).json err

###*
Get list of users
restriction: 'admin'
###
exports.index = (req, res) ->
  User.find {}, '-salt -hashedPassword', (err, users) ->
    return res.status(500).json err  if err
    res.status(200).json users

###*
Creates a new user
###
exports.create = (req, res, next) ->
  console.log req.body
  newUser = new User(req.body)
  newUser.provider = 'local'
  newUser.role = 'user'
  newUser.last_seen = ''
  newUser.save (err, user) ->
    return validationError(res, err) if err
    token = jwt.sign(
      _id: user._id
    , config.secrets.session,
      expiresInMinutes: 60 * 5
    )
    res.json token: token

###*
Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id
  User.findById userId, (err, user) ->
    # console.log user
    if user
      today = new Date()

      unless user.last_seen
        console.log "last_seen1"
        SigninLog.create {user_id: user._id, created_at: today}, (err, SigninLog) ->
          user.last_seen = new Date()
          user.save()
          console.log SigninLog
      if user.last_seen
        unless user.last_seen.setHours(0,0,0,0) == today.setHours(0,0,0,0)
          console.log "last_seen2"
          SigninLog.create {user_id: user._id, created_at: today}, (err, SigninLog) ->
            console.log SigninLog
            user.last_seen = new Date()
            user.save()

      if user.free_loot_log.length > 0
        prevDay = user.free_loot_log[user.free_loot_log.length-1].date

        freeStatus = DateDiff.inDays(prevDay, today)
        if freeStatus > 0
          user.free_loot = true

    return next(err)  if err
    return res.status(401).end()  unless user
    res.json user

###*
Get a single user
###

exports.update = (req, res) ->
  User.findById req.params.id, (err, user) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless user

    # console.log "xxxxx"
    # console.log user
    # console.log req.body
    updated = _.merge(user, req.body)
    user.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json user

handleError = (res, err) ->
  res.status(500).json err


# exports.updateWinner = (req, res) ->
#   User.findById req.params.id, (err, user) ->
#     return handleError(res, err) if err
#     return res.status(404).end() unless user
#
#     updated = _.merge(user, req.body)
#     user.save (err) ->
#       return handleError(res, err)  if err
#       res.status(200).json user
#
# handleError = (res, err) ->
#   res.status(500).json err
#
# exports.updateJoined = (req, res) ->
#   # console.log req.params
#   User.findById req.params.id, (err, user) ->
#     return handleError(res, err) if err
#     return res.status(404).end() unless user
#
#     updated = _.merge(user, req.body)
#     user.save (err) ->
#       return handleError(res, err)  if err
#       res.status(200).json user
#
# handleError = (res, err) ->
#   res.status(500).json err

###*
Deletes a user
restriction: 'admin'
###
exports.destroy = (req, res) ->
  User.findByIdAndRemove req.params.id, (err, user) ->
    return res.status(500).json err  if err
    res.status(204).end()

###*
Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String(req.body.oldPassword)
  newPass = String(req.body.newPassword)
  User.findById userId, (err, user) ->
    if user.authenticate(oldPass)
      user.password = newPass
      user.save (err) ->
        return validationError(res, err)  if err
        res.status(200).end()

    else
      res.status(403).end()

###*
Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err)  if err
    return res.status(401).end() unless user
    return res.json user

exports.showContests = (req, res, next) ->
  console.log "show contest"
  console.log req.params
  # console.log req.body

  userId = req.params.id
  status = req.params.status

  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err)  if err
    return res.status(401).end() unless user
    # console.log user
    if status == 'active'
      Contest.where('player.uid').equals(user._id).where('stage').in(['upcoming', 'live']).exec (err, contest) ->
        return res.json contest
    else if status == 'completed'
      Contest.where('player.uid').equals(user._id).where('stage').equals('close').exec (err, contest) ->
        return res.json contest
    else if status == 'Won'
      WinnerLog.where('user_id').equals(user._id).select('contest_id').exec (err, won) ->
        # Contest.where('player.uid').equals(user._id).exec (err, contest) ->
        return res.json won

    else if status == 'hosting'
      Contest.where('owner').equals(user.email).exec (err, contest) ->
        return res.json contest
    else if status == 'participating'
      Contest.where('player.uid').equals(user._id).exec (err, contest) ->
        return res.json contest

exports.showTransactions = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err)  if err
    return res.status(401).end() unless user
    return res.json user

exports.accounting = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
  , '-salt -hashedPassword', (err, user) -> # don't ever give out the password or salt
    return next(err)  if err
    return res.status(401).end() unless user
    return res.json user

###*
Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'
  return
