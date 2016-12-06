
'use strict'

_ = require 'lodash'
Contest  = require './contest.model'
Program  = require '../program/program.model'
Template = require '../template/template.model'
Question = require '../question/question.model'
WinnerLog = require '../winner_log/winner_log.model'
User     = require '../user/user.model'

schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

checkScore = (player, questions) ->
  score = 0
  for uAnswer, i in player.answers
    if questions[i].answers[uAnswer].is_correct == true
      # console.log score
      score = score + 1
  player.score = score
  score

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
        contest.end_time   = e_time.getTime()

        if current_time > s_time.getTime()
          contest.status = "runing"
          contest.stage = "runing"
          contest.save()
          # console.log "contest Start #{contest.status} #{contest._id}"
          return

      n_date = schedule.scheduleJob(e_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.start_time = s_time.getTime()
          contest.end_time   = e_time.getTime()

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
          contest.end_time   = e_time.getTime()
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
      # user.joinedContest = [ contest ]

      user.save()

      contest.participant.push(req.body)
      contest.player.push({ uid: req.body._id, name: req.body.email, score: 10 })

      contest.save (err) ->
        return handleError(res, err)  if err
        res.status(200).json contest

exports.joinContestCreated = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    # User.findById req.body._id, (err, user) ->
    #   # user.joinedContest = [ contest ]
    #   user.save()
      #
      # contest.save (err) ->
      #   return handleError(res, err)  if err
      #   res.status(200).json contest

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

  Template.findById req.params.id, (err, template) ->
    template.active = false
    template.save()

  Contest.update { template_id: req.params.id }, { status: 'close', stage: 'close' }, { multi: true }, (err, num) ->
    console.log num

  # console.log "xxx 1"
  Contest.find { template_id: req.params.id }, (err, contests) ->
    # console.log "xxx 2"
    for contest in contests
      # console.log "xxx 3"
      Contest.findById contest._id, (err, c) ->
        max_score = 0
        winner = {}
        for p in c.player
          User.findById p.uid, (err, user) ->
            for jc, i in user.joinedContest
              if i == user.joinedContest.length - 1 && jc._id == contest._id
                user.joinedContest.push contest
                user.save()

            if user.joinedContest.length == 0
              user.joinedContest.push contest
              user.save()


          Question.find { 'templates': req.params.id }, (err, questions) ->
            score = checkScore(p, questions)
            p.score = score

            if score > max_score
              winner = p
              max_score = score

            c.save()

        setTimeout (->
          # User.update { _id: winner.uid }, { wonContest: [ contest ] }, { multi: true }, (err, data) ->
          #   # console.log "Winner"
          #   console.log data
          User.findById winner.uid, (err, user) ->
            # console.log user
            if user.wonContest.length == 0
              user.wonContest.push contest
              user.save()
            else
              for won, i in user.wonContest
                if i == user.wonContest.length - 1 && won._id != contest._id
                  user.wonContest.push contest
                  user.save()

          WinnerLog.create {
            user_id: winner.uid,
            contest_id: c._id,
            template_id: req.params.id,
            score: winner.score,
            prize:  c.loot.prize
            }, (err, winnerlog) ->
              console.log "callback"
              # console.log winnerlog
          # return
        ), 5000


    res.status(200).json {success: true}

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
