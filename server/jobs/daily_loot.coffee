User = require '../api/user/user.model'
Conomy = require '../api/conomy_log/conomy_log.model'
schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()
console.log "sdsdsdsdksldksldkslkdslkdsl999999999999999999999999999"
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
console.log "1234567890"
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

rule2 = new schedule.RecurrenceRule()
rule2.second = 30
rule2.hour = 2
rule2.minute = 3
j = schedule.scheduleJob(rule2, ->
  console.log new Date, 'The 30th second of the minute.'
  return
)