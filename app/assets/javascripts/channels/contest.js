App.contest = App.cable.subscriptions.create("ContestChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {}
});
