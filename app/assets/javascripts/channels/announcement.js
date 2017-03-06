App.announcement = App.cable.subscriptions.create("AnnouncementChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    // return alert(data['message']);
    return $('#messages').append(data['message']);
  },
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});
