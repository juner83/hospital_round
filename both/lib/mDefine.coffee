@mDefine =
#  server_id: Meteor.uuid()
  robot_socket: false  #로봇소켓연결시 true, 해제시 false
  tts_socket: true #tts_socket 연결시 true, 해제시 false
  bridgeUrl: "https://IP:PORT"
  gateWayUrl: process.env.GATEWAY_URL
  monstroUrl: process.env.MONSTRO_URL
  passPhrase: '36365dc82aa463782466'
  fileServerMark: '_-_-_fileServerUrl_-_-_'
  timeFormat: 'YYYY-MM-DD HH:mm:ss'
  timeFormatMDHM: 'MM-DD HH:mm'
  timeFormatMD: 'MM-DD'
  timeFormatYM: 'YYYY-MM'
  timeFormatYMD: 'YYYY-MM-DD'
  timeFormatYMDdot: 'YYYY.MM.DD'
  timeFormatHMS: 'HH:mm:ss'
  timeFormatH: 'HH'
  timeFormatM: 'mm'
  timeFormatHM: 'HH:mm'
  timeFormatYMDHMS2: 'YYYYMMDDHHmmss'
  cstInfo: new ReactiveVar()
