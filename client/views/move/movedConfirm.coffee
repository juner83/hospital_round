FlowRouter.route '/movedConfirm', action: ->
  BlazeLayout.render 'main',
    content: 'movedConfirm'
  return

Template.movedConfirm.onCreated ->
Template.movedConfirm.onRendered ->
Template.movedConfirm.helpers
  고객명: -> return mDefine.cstInfo.get()?.이름
Template.movedConfirm.events
  'click [name=btnCancle]': (evt, inst) ->
    FlowRouter.go '/patientList'
  'click [name=btnGo]': (evt, inst) ->
    FlowRouter.go '/patientDetail'

