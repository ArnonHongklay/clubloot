
'use strict'

_ = require 'lodash'
User = require '../user/user.model'

exports.getFreeLoot = (req, res, next) ->
  User.findById req.params.id, (err, user) ->
    console.log "------------------------------------------"
    user.free_loot = false
    counter = 0
    baseCoins = 2000
    previousDay = 0
    for day, index in user.free_loot_log
      if index > 0
        if day.date.getDate() - previousDay == 1 && previousDay != 0
          counter = counter + 1
        else
          counter = 1
        previousDay = day.date.getDate()

    user.free_loot_log.push { date: new Date() }
    bonus = counter * 200
    console.log user.coins
    console.log "====="
    user.coins = user.coins + baseCoins + bonus
    user.save

    console.log user.coins

    user.save (err) ->
      data = { user: user, freeCoins: baseCoins + bonus }
      res.json data

handleError = (res, err) ->
  res.status(500).json err
