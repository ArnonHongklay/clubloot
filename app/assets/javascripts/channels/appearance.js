App.appearance = App.cable.subscriptions.create("AppearanceChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {}
});
