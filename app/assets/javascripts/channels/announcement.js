App.announcement = App.cable.subscriptions.create({
  channel: "AnnouncementChannel",
  token: "T3QPTX3RN95P8N9MG85AFXUKCRK6MHQJ"
}, {
  connected: function() {
    this.show('T3QPTX3RN95P8N9MG85AFXUKCRK6MHQJ')
  },
  disconnected: function() {

  },
  received: function(data) {
    // console.log(data);
  },
  show: function(data) {
    return this.perform('show', {
      token: data
    });
  },
  destroy: function(token, announcement) {
    return this.perform('destroy', {
      token: token,
      announcement: announcement
    });
  }
});
