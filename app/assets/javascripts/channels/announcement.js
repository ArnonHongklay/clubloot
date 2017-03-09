App.announcement = App.cable.subscriptions.create("AnnouncementChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    // return alert(data['message']);
    console.log(data);
    // $('.sameheight-item').html(data['message']);
  },
  speak: function(publish, description) {
    return this.perform('speak', {
      publish: publish,
      description: description
    });
  },
  getAnnouncement: function(data) {
    return this.perform('get_announcement', {
      token: data
    })
  }
});
