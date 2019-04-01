// Socket io client
const PORT = 10000;
let socket = require('socket.io-client')(`http://localhost:${PORT}`);

Meteor.startup(() => {
  socket.on('connect', function() {
    console.log('Client connected');
  });
  socket.on('disconnect', function() {
    console.log('Client disconnected');
  });

  socket.on('news', function (data) {
    console.log(data);
    socket.emit('my other event', { my: 'data' });
  });
});

Meteor.methods({
  req_send_api: function (_msg) {
    socket.emit('req_custom_msg', {msg: _msg})
  },
  robot_move: function (_data) {
    socket.emit(JSON.stringify(_data));
  }
});