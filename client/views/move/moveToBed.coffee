@handlerRv = new ReactiveVar()

FlowRouter.route '/moveToBed', action: ->
  BlazeLayout.render 'main',
    content: 'moveToBed'
  return

Template.moveToBed.onCreated ->
#  inst = @
#  datacontext = inst.data
#  datacontext.moveEnd = new ReactiveVar()
Template.moveToBed.onRendered ->
  #todo 정해진시간(5분) 안에 도착완료 신호를 못받으면 초기화 하는 기능 필요
  #todo 도착신호를 서버에서 받아서 클라이언트에 전달하는기능 필요
  handlerRv.set Meteor.setTimeout ->
    FlowRouter.go '/movedConfirm'
  , 1000 * 5
  Meteor.call 'tts_call', mDefine.cstInfo.get()?.이름+'님의 회진을 위해 이동합니다.', (err, rslt) -> if err then alert err
  #todo 실제 시연할 룸넘버, 베드넘버 받아서 하드코딩
  Meteor.call 'robot_move', '101', '1', (err, rslt) -> if err then alert err
Template.moveToBed.helpers
  고객명: -> return mDefine.cstInfo.get()?.이름
Template.moveToBed.events
  'click .fo_move_er': (evt, inst) ->
    $('.move_wrap').css('display', 'none')
    $('.avoid_wrap').css('display', 'block')
    Meteor.clearTimeout(handlerRv.get())
    Meteor.call 'robot_pause', (err, rslt) -> if err then alert err
    Meteor.call 'tts_call', '응급상황 발생으로 기동중지 합니다. 좌우 화살표를 선택하여 회피방향을 설정해주십시오.', (err, rslt) -> if err then alert err

  'click [name=avoidLeft]': (evt, inst) ->
    Meteor.call 'robot_shunt', 'left', (err, rslt) -> if err then alert err
    Meteor.call 'tts_call', '로봇이 응급상황 회피중입니다. 응급상황 종료시까지 기다려주세요.', (err, rslt) -> if err then alert err

  'click [name=avoidRight]': (evt, inst) ->
    Meteor.call 'robot_shunt', 'right', (err, rslt) -> if err then alert err
    Meteor.call 'tts_call', '로봇이 응급상황 회피중입니다. 응급상황 종료시까지 기다려주세요.', (err, rslt) -> if err then alert err

  'click [name=avoidEnd]': (evt, inst) ->
    $('.move_wrap').css('display', 'block')
    $('.avoid_wrap').css('display', 'none')
    Meteor.call 'robot_resume', (err, rslt) -> if err then alert err
    Meteor.call 'tts_call', '응급상황이 해제되어 회진을 재개합니다.', (err, rslt) -> if err then alert err

    #todo 도착신호를 서버에서 받아서 클라이언트에 전달하는기능 필요
    handlerRv.set Meteor.setTimeout ->
      FlowRouter.go '/movedConfirm'
    , 1000 * 5

  'click .fo_move>.left': (evt, inst) ->
    cl "robot speed 10% down"
    Meteor.call 'robot_speed', "down", (err, rslt) ->
#    todo 조정된후 현재값을 보여주는것도 있으면 좋겠음.
  'click .fo_move>.right': (evt, inst) ->
    cl "robot speed 10% up"
    Meteor.call 'robot_speed', "up", (err, rslt) ->
