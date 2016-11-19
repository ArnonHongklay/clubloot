
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
    s_time = ''
    e_time = ''
    Template.findById contest.template_id, (err, template) ->
      s_time = template.start_time
      e_time = template.end_time

      Contest.findById contest._id, (err, contest) ->
        current_time = new Date().getTime()
        contest.start_time = s_time.getTime()

        if current_time > s_time.getTime()
          contest.status = "runing"
          contest.stage = "runing"
          contest.save()
          # console.log "contest Start #{contest.status} #{contest._id}"
          return

      n_date = schedule.scheduleJob(e_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.start_time = s_time.getTime()

          if contest.participant.length < contest.max_player
            for user in contest.participant
              User.findById user._id, (err, user) ->
                user.coins = user.coins + contest.fee
                user.save()
            contest.status = "cancel"
            contest.stage = "cancel"
            contest.save()
          else
            contest.status = "finish"
            contest.stage = "finish"
            contest.save()
        return
      )

      s_date = schedule.scheduleJob(s_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.start_time = s_time.getTime()
          contest.status = "runing"
          contest.stage = "runing"
          contest.save()
        return
      )

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
    # console.log contest
    myContest.start(contest)
    res.status(201).json contest

exports.joinContest = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    User.findById req.body._id, (err, user) ->
      user.coins = user.coins - contest.fee
      user.save()

      contest.participant.push(req.body)
      contest.player.push({ uid: req.body._id, name: req.body.email, score: 10 })

      contest.save (err) ->
        return handleError(res, err)  if err
        res.status(200).json contest

exports.updateQuestion = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.joinPlayer = (req, res) ->
  player = req.body.player
  Contest.findById req.params.id, (err, contest) ->
    pre = contest
    for p in pre.player
      if p.uid == player.uid
        p.answers = player.answers
    contest = pre
    contest.save()
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    contest.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.findAllProgram = (req, res) ->
  Contest.find (err, contests) ->
    bucket = []
    for contest in contests
      if contest.program == req.params.name
        bucket.push(contest)

    setTimeout (->
      render(res, bucket)
    ), 100

exports.findByTemplates = (req, res) ->
  # console.log "test #{req.params.id}"
  Contest.update { template_id: req.params.id }, { status: 'close', stage: 'close' }, { multi: true }, (err, num) ->
    # console.log num
    return

exports.findProgramActive = (req, res) ->
  bucket = []
  program = Program.find({}).select('name -_id')
  program.exec (err, programs) ->
    if err
      return next(err)

    for program in programs
      contest = Contest.findOne({program: program.name})
      contest.exec (err, temp) ->
        if temp
          bucket.push(temp)

    setTimeout (->
      render(res, bucket)
    ), 100

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
