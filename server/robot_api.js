import {Meteor} from "meteor/meteor";

var net = require('net');
var robot_client = new net.Socket();
var tts_client = new net.Socket();
const streamer = new Meteor.Streamer('ep_sungmo');
// if (Meteor.isServer) {
streamer.allowRead('all');
streamer.allowWrite('all');

sendStreamMessage = function(message) {
  streamer.emit('message', message);
  console.log('me: ' + message);
};

// function that reconnect the client to the server
function reconnect_robot () {
  setTimeout(() => {
    robot_client.removeAllListeners() // the important line that enables you to reopen a connection
    connect_robot()
  }, 1000)
}

function reconnect_tts () {
  setTimeout(() => {
    tts_client.removeAllListeners() // the important line that enables you to reopen a connection
    connect_tts()
  }, 1000)
}


function connect_robot() {
  // console.log("new client")
  robot_client.connect(
    5019,
    "127.0.0.1",
    () => {
      console.log("Connected")
      robot_client.write("Hello, server! Love, Client.")
      // var obj = {command: "SPEED", speed: "50"};
      // robot_client.write(JSON.stringify(obj));
    }
  )

  robot_client.on("data", data => {
    console.log('Received: ' + data);

    var rcvObject = JSON.parse(data);
    console.log(rcvObject.command);
    //로봇베드도착 -> 완료알림수신(회진서버) -> client 에 전달
    if(rcvObject.command === 'STATE' && rcvObject.result === 'success') {
      sendStreamMessage('robot_arrival_to_customer_bed');
    }
  })

  robot_client.on("close", () => {
    console.log("Connection closed")
    reconnect_robot()
  })

  robot_client.on("end", () => {
    console.log("Connection ended")
    reconnect_robot()
  })

  robot_client.on("error", console.error)
}

function connect_tts() {
  // console.log("new client")
  tts_client.connect(
    23564,
    "127.0.0.1",
    () => {
      console.log("Connected")
      tts_client.write("Hello, server! Love, Client.")
    }
  )

  tts_client.on("data", data => {
    console.log('Received: ' + data);

    var rcvObject = JSON.parse(data);
    console.log(rcvObject.command);
  })

  tts_client.on("close", () => {
    console.log("Connection closed")
    reconnect_tts()
  })

  tts_client.on("end", () => {
    console.log("Connection ended")
    reconnect_tts()
  })

  tts_client.on("error", console.error)
}


Meteor.startup(() => {
  if(mDefine.robot_socket) {
    connect_robot()
  }
  if(mDefine.tts_socket) {
    connect_tts()
  }
});

Meteor.methods({
  robot_move: function (_room, _bed) {
    try {
      var obj = { command: "MOVE", roomNumber: _room, bedNumber: _bed };
      cl(JSON.stringify(obj));
      if(mDefine.robot_socket) {
        cl('in block')
        robot_client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_pause: function () {
    try {
      var obj = { command: "PAUSE" };
      cl(JSON.stringify(obj));
      if(mDefine.robot_socket) {
        cl('in block')
        robot_client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_resume: function () {
    try {
      var obj = { command: "RESUME" };
      cl(JSON.stringify(obj));
      if(mDefine.robot_socket) {
        cl('in block')
        robot_client.write(JSON.stringify(obj));
      }
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  robot_shunt: function (_direction) {
    try {
      var obj = { command: "SHUNT", direction: _direction };
      cl(JSON.stringify(obj));
      if(mDefine.robot_socket) {
        cl('in block')
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
      var _speed = Meteor.user().profile.로봇속도;
      if(_updown === 'up') {
        _speed = _speed + 10;
        if (_speed >= 100) {_speed = 100}
      } else {
        _speed = _speed - 10;
        if (_speed <= 10) {_speed = 10}
      }
      var obj = { command: "SPEED", linearSpeed: _speed.toString(), angularSpeed: _speed.toString()  };
      cl(JSON.stringify(obj));
      if(mDefine.robot_socket) {
        cl('in block')
        robot_client.write(JSON.stringify(obj));
      }
      Meteor.users.update({_id: Meteor.userId()}, {$set: {'profile.로봇속도': _speed}})
      return "done"
    } catch (e) {
      cl("error code #1001" +e);
      throw new Meteor.Error(e)
    }
  },
  tts_call: function (_msg) {
    try {
      //todo 1. 현재 로그인 의사의 속도를 알아내고, 2. up/down에 따라 10씩 올리거나 내림
      // var utf8 = encodeURI(_msg); //%aa%bb
      // var param = utf8.replace(/\%/gi, '-');  //-aa-bb
      // param = param.substring(1, param.length)
      // cl("tts_call:"+ _msg + " -> " + param);   //aa-bb
      cl("tts_call: " + _msg);   //aa-bb
      if(mDefine.tts_socket) {
        tts_client.write(_msg);
      }
      return "done"
    } catch (e) {
      cl("error code #1002" +e);
      throw new Meteor.Error(e)
    }
  },
});