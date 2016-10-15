'use strict'

User = require './user.model'
passport = require 'passport'
config = require '../../config/environment'
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
  newUser = new User(req.body)
  newUser.provider = 'local'
  newUser.role = 'user'
  newUser.save (err, user) ->
    return validationError(res, err)  if err
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
    console.log user
    if user
      if user.free_loot_log.length > 0
        prevDay = user.free_loot_log[user.free_loot_log.length-1].date
        today = new Date()
        freeStatus = DateDiff.inDays(prevDay, today)
        if freeStatus > 0
          user.free_loot = true
    return next(err)  if err
    return res.status(401).end()  unless user
    res.json user

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

###*
Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'
  return
