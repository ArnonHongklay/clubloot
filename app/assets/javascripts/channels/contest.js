App.contest = App.cable.subscriptions.create("ContestChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data);
  },
  // show: function(message) {
  //   return this.perform(data);
  // }
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});
