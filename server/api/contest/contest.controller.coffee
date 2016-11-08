
'use strict'

_ = require 'lodash'
Contest  = require './contest.model'
Program  = require '../program/program.model'
Template = require '../template/template.model'
User     = require '../user/user.model'

schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

myContest =
  start: (contest) ->
    console.log "ioemit"
    console.log "ioemit"
    console.log "emit"
    console.log "start schedule"
    s_time = ''
    e_time = ''
    Template.findById contest.template_id, (err, template) ->
      console.log template
      s_time = template.start_time
      e_time = template.end_time

      console.log s_time
      console.log e_time

      n_date = schedule.scheduleJob(e_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.status = "finish"
          contest.save()
          console.log "contest Finish"
          return
      )

      s_date = schedule.scheduleJob(s_time, ->
        Contest.findById contest._id, (err, contest) ->
          if contest.participant.length < contest.max_player
            for user in contest.participant
              User.findById user._id, (err, user) ->
                user.coins = user.coins + contest.fee
                user.save()
                console.log user
            n_date.cancel()
            contest.status = "cancel"
            contest.save()
          else
            contest.status = "runing"
            contest.save()

          console.log contest
        return
      )

# Get list of contests
exports.index = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

exports.live = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

exports.upcoming = (req, res) ->
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
    myContest.start(contest)
    res.status(201).json contest

exports.joinContest = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    console.log contest.participant
    console.log "======================================="
    console.log req.body

    User.findById req.body._id, (err, user) ->
      user.coins = user.coins - contest.fee
      user.save()

      contest.participant.push(req.body)
      contest.player.push({ uid: req.body._id, name: req.body.email, score: 10 })

      console.log "======================================="
      console.log contest
      contest.save (err) ->
        return handleError(res, err)  if err
        res.status(200).json contest

exports.updateQuestion = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    console.log "============================================"
    console.log contest
    console.log req.body

    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.joinPlayer = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    # contest.player.push(req.body.player)

    console.log req.body.player
    contest.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.findAllProgram = (req, res) ->
  Contest.find (err, contests) ->
    bucket = []
    for contest in contests
      # console.log contest.program
      if contest.program == req.params.name
        bucket.push(contest)

    setTimeout (->
      console.log bucket
      render(res, bucket)
    ), 100

exports.findProgramActive = (req, res) ->
  bucket = []
  program = Program.find({}).select('name -_id')
  program.exec (err, programs) ->
    if err
      return next(err)

    for program in programs
      console.log program
      contest = Contest.findOne({program: program.name})
      contest.exec (err, temp) ->
        console.log temp
        if temp
          bucket.push(temp)

    setTimeout (->
      console.log bucket
      render(res, bucket)
    ), 100

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
