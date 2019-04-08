var net = require('net');
var robot_client = new net.Socket();
var tts_client = new net.Socket();

Meteor.startup(() => {
  //todo client reconnect 에 대한 부분도 구현해야함
  if(mDefine.robot_socket) {
    robot_client.connect(5019, '127.0.0.1', function () {
      console.log('Connected');
      var obj = {command: "SPEED", speed: "50"};
      client.write(JSON.stringify(obj));
    });
    robot_client.on('data', function (data) {
      console.log('Received: ' + data);

      var rcvObject = JSON.parse(data);
      console.log(rcvObject.command);

      //robot_client.destroy(); // kill client after server's response
    });

    robot_client.on('close', function () {
      console.log('Connection closed');
    });
  }
  if(mDefine.tts_socket) {
    cl('tts_socket is requested')
    try {
      tts_client.connect(23564, '127.0.0.1', function () {
        console.log('Connected');
        // var obj = {command: "SPEED", speed: "50"};
        // client.write(JSON.stringify(obj));
      });
      tts_client.on('data', function (data) {
        console.log('Received: ' + data);
  
        var rcvObject = JSON.parse(data);
        console.log(rcvObject.command);
  
        //tts_client.destroy(); // kill client after server's response
      });
  
      tts_client.on('close', function () {
        console.log('Connection closed');
      });
  
    } catch (e) {
      console.log('tts_socket disconnected')
    }
  }
});

Meteor.methods({
  robot_move: function (_room, _bed) {
    try {
      var obj = { command: "MOVE", roomNumber: _room, bedNumber: _bed };
      if(mDefine.robot_socket) {
        robot_client.write(JSON.stringify(obj));
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
        // robot_client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_avoid: function (_direction) {

  },
  tts_call: function (_msg) {
    try {
      //todo 1. 현재 로그인 의사의 속도를 알아내고, 2. up/down에 따라 10씩 올리거나 내림
      var unicode = mUtils.convertStringToUnicode(_msg)
      console.log(unicode)
      console.log(_msg)
      if(mDefine.tts_socket) {
        tts_client.write(unicode);
      }
      return "done"
    } catch (e) {
      cl("error code #1002" +e);
      throw new Meteor.Error(e)
    }
  },
});