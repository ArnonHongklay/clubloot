
/**
Broadcast updates to client when the model changes
 */

(function() {
  'use strict';
  var onRemove, onSave, thing;

  thing = require('./thing.model');

  exports.register = function(socket) {
    thing.schema.post('save', function(doc) {
      return onSave(socket, doc);
    });
    return thing.schema.post('remove', function(doc) {
      return onRemove(socket, doc);
    });
  };

  onSave = function(socket, doc, cb) {
    return socket.emit('thing:save', doc);
  };

  onRemove = function(socket, doc, cb) {
    return socket.emit('thing:remove', doc);
  };

}).call(this);

//# sourceMappingURL=thing.socket.js.map
