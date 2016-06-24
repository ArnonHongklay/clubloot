(function() {
  'use strict';
  module.exports = {
    ip: process.env.OPENSHIFT_NODEJS_IP || process.env.IP || void 0,
    port: process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 8080,
    mongo: {
      uri: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || process.env.OPENSHIFT_MONGODB_DB_URL + process.env.OPENSHIFT_APP_NAME || 'mongodb://localhost/clubloot'
    }
  };

}).call(this);

//# sourceMappingURL=production.js.map
