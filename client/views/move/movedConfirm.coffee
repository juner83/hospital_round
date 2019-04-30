FlowRouter.route '/movedConfirm', name: '/movedConfirm', action: ->
  BlazeLayout.render 'main',
    content: 'movedConfirm'
  return

Template.movedConfirm.onCreated ->
Template.movedConfirm.onRendered ->
  mUtils.fr_tts mDefine.cstInfo.get()?.이름+'님의 회진 장소에 도착했습니다. 회진을 진행하시겠습니까?'

Template.movedConfirm.helpers
  고객명: -> return mDefine.cstInfo.get()?.이름
Template.movedConfirm.events
  'click [name=btnCancle]': (evt, inst) ->
    FlowRouter.go '/patientList'
  'click [name=btnGo]': (evt, inst) ->
    FlowRouter.go '/patientDetail'

