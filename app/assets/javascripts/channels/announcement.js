App.announcement = App.cable.subscriptions.create("AnnouncementChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data);
    // $('#messages').removeClass('hidden');
    // return $('#messages').append(this.renderMessage(data));
  },
  renderMessage: function(data) {
    // return '<p> <b>' + data.user + ': </b>' + data.message + '</p>';
  }
});
