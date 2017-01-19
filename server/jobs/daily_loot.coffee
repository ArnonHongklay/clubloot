User = require '../api/user/user.model'
Conomy = require '../api/conomy_log/conomy_log.model'
Template = require '../api/template/template.model'
Contest  = require '../api/contest/contest.model'
schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()
# rule.minute = new (schedule.Range)(0, 59, 1)
# rule.hour = 23


# j = schedule.scheduleJob(rule, ->
#   # console.log "Can get more free coins"
#   User.find (err, users) ->
#     users.forEach (user) ->
#       user.free_loot = true
#       user.save()
#       return
#     return

# )
rule.second = 59
rule.hour = 23
rule.minute = 59
k = schedule.scheduleJob(rule, ->
  console.log rule
  economy = 0
  User.find {}, (err, players) ->
    for p in players
      c = p.coins
      r = p.rubies * 100
      s = p.sapphires * 500
      e = p.emeralds * 2500
      d = p.diamonds * 12500
      all = c+r+s+e+d
      console.log "ALL #{all}"
      economy = economy + all
    console.log economy
    console.log "============-------"
    Conomy.create {
      coins: economy
      created_at: new Date()
      }, (err, winnerlog) ->
        # console.log "callback"
  return
)



myContest =
  start: (contest) ->
    s_time = ''
    e_time = ''
    Template.findById contest.template_id, (err, template) ->
      s_time = template.start_time
      e_time = template.end_time
      program_image = template.program_image
      console.log "11111111111111"
      Contest.findById contest._id, (err, contest) ->
        console.log contest.status
        return if contest.status == "cancel" || contest.status == "live"
        console.log "22222222222222222"
        current_time = new Date().getTime()
        contest.start_time = s_time.getTime()
        contest.end_time   = e_time.getTime()
        contest.program_image = template.program_image
        console.log "current:#{current_time}"
        console.log "n:"

        if current_time > e_time.getTime()
          console.log "777777777777777777777777799999999999999999999"
          contest.program_image = template.program_image
          if contest.participant.length < contest.max_player
            for user in contest.participant
              User.findById user._id, (err, user) ->
                user.coins = user.coins + contest.fee
                user.save()
            contest.status = "cancel"
            contest.stage = "cancel"
            contest.save()
          else
            contest.status = "live"
            contest.stage = "live"
            contest.save()


rule2 = new schedule.RecurrenceRule()
rule2.minute = new (schedule.Range)(0, 59, 1)
j = schedule.scheduleJob(rule2, ->
  console.log new Date, 'The 30th second of the minute.'
  start = new Date()
  s = start.setHours(0,0,0,0)
  end = new Date()
  e = end.setHours(23,59,59,999)
  Contest.find({ end_time: {$gte: s, $lt: e} }).exec (err, contests) ->
    for contest in contests
      myContest.start(contest)

  return
)

