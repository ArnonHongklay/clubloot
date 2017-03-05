App.announcement = App.cable.subscriptions.create "AnnouncementChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log data
    $('#messages').removeClass 'hidden'
    $('#messages').append @renderMessage(data)

  renderMessage: (data) ->
    '<p> <b>' + data.user + ': </b>' + data.message + '</p>'
