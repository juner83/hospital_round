# 오늘 년원일
@mDefine =
  schedule_psize: 2 #나의스케쥴 페이자당 카드갯수
  cst_psize: 7  #환자리스트 페이지당 환자명수
  result_psize: 4  #결과리스트 페이지당 갯수
#  server_id: Meteor.uuid()
  robot_socket: true  #로봇소켓연결시 true, 해제시 false
  tts_socket: false #tts_socket 연결시 true, 해제시 false
  stt_uri: 'puzzle-ai.com:9223'
  # stt_uri: '121.135.148.170:9223'
  bridgeUrl: "https://wisecaresmr01.com:29000"
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
  cstInfo: new ReactiveVar()  #환자정보 CollectionCustomers.findOne()
