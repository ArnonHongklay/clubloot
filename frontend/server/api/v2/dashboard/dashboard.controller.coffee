
'use strict'

_ = require 'lodash'
nodemailer = require 'nodemailer'
Player = require '../../user/user.model'
Contest = require '../../contest/contest.model'
Program = require '../../program/program.model'

exports.index = (req, res) ->
  Player.find (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players

exports.player = (req, res) ->
  Player.count (err, players) ->
    return handleError(res, err) if err
    res.status(200).json { player: players }

exports.tournament = (req, res) ->
  Contest.count (err, tournaments) ->
    return handleError(res, err) if err
    res.status(200).json { tournament: tournaments }

exports.rich = (req, res) ->
  Player.find (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players


exports.upcoming_contest = (req, res) ->
  # Contest.find (err, contests) ->
  #   return handleError(res, err) if err
  #   res.status(200).json contests

  bucket = []
  program = Program.find({}).select('name -_id')
  current_time = new Date().getTime()

  temp = 0
  program.exec (err, programs) ->
    return next(err) if err

    for program in programs
      # contest = Contest.findOne({program: program.name})
      total_contest = 0
      total_coin = 0

      contest = Contest.find program: program.name, (err, contests) ->
        if contests
          for contest, i in contests
            continue if contest.end_time == undefined
            e_time = contest.end_time.getTime()

            if current_time < e_time
              if i == 0
                temp = e_time
              else if temp > e_time
                temp = e_time

              total_contest += 1
              total_coin += contest.loot.prize

              if i == contests.length - 1
                console.log total_contest
                console.log total_coin
                # console.log contests.length
                c = {
                  contest
                  total: {
                    total_contest: total_contest
                    total_coin: total_coin
                  }
                }

                bucket.push(c)

    setTimeout (->
      console.log bucket
      render(res, bucket)
    ), 1000

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
