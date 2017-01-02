User = require '../api/user/user.model'
schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

rule.minute = 59
rule.hour = 23

return

j = schedule.scheduleJob(rule, ->
  # console.log "Can get more free coins"
  User.find (err, users) ->
    users.forEach (user) ->
      user.free_loot = true
      user.save()
      return
    return

)
