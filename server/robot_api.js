var net = require('net');
var client = new net.Socket();

Meteor.startup(() => {
  //todo client reconnect 에 대한 부분도 구현해야함
  if(mDefine.robot_socket) {
    client.connect(5019, '127.0.0.1', function () {
      console.log('Connected');
      var obj = {command: "SPEED", speed: "50"};
      client.write(JSON.stringify(obj));
    });
    client.on('data', function (data) {
      console.log('Received: ' + data);

      var rcvObject = JSON.parse(data);
      console.log(rcvObject.command);

      //client.destroy(); // kill client after server's response
    });

    client.on('close', function () {
      console.log('Connection closed');
    });
  }
});

Meteor.methods({
  robot_move: function (_room, _bed) {
    try {
      var obj = { command: "MOVE", roomNumber: _room, bedNumber: _bed };
      if(mDefine.robot_socket) {
        client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_speed: function (_updown) {
    try {
      //todo 1. 현재 로그인 의사의 속도를 알아내고, 2. up/down에 따라 10씩 올리거나 내림
      var obj = { command: "SPEED", speed: "50" };
      if(mDefine.robot_socket) {
        client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_avoid: function (_direction) {

  }
});