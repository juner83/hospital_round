
FlowRouter.route '/moveToBed', action: ->
  BlazeLayout.render 'main',
    content: 'moveToBed'
  return

Template.moveToBed.onCreated ->
#  inst = @
#  datacontext = inst.data
#  datacontext.moveEnd = new ReactiveVar()
Template.moveToBed.onRendered ->
  Meteor.setTimeout ->
    FlowRouter.go '/movedConfirm'
  , 1000 * 3
Template.moveToBed.helpers
  고객명: -> return mDefine.cstInfo.get()?.이름
Template.moveToBed.events
  'click .fo_move_er': (evt, inst) ->
    $('.move_wrap').css('display', 'none')
    $('.avoid_wrap').css('display', 'block')
  'click .btn_reround': (evt, inst) ->
    $('.move_wrap').css('display', 'block')
    $('.avoid_wrap').css('display', 'none')
  'click .fo_move>.left': (evt, inst) ->
    cl "robot speed 10% up"
    Meteor.call 'robot_speed', "down", (err, rslt) ->
#    todo 조정된후 현재값을 보여주는것도 있으면 좋겠음.

  'click .fo_move>.right': (evt, inst) ->
    cl "robot speed 10% down"
    Meteor.call 'robot_speed', "up", (err, rslt) ->
