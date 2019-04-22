isNowRecording = new ReactiveVar(false)
Template.header.helpers
  nowRecording: -> isNowRecording.get()
Template.header.events
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
#    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->
    mUtils.fr_home()

  'click [name=reqVideo]': (evt, inst) ->
#    mUtils.CallTTS '협진을 요청하겠습니다. 잠시만 기다리십시오.'
    Meteor.call 'reqVideoSync', (err, rslt) ->
      if err then alert err
      else
        cl '협진요청 완료'

  'click [name=voiceEmr]': (evt, inst) ->
    cl cstInfo = mDefine.cstInfo.get()
    unless cstInfo then Meteor.call 'setDefaultCstInfo', (err, rslt) ->
      mDefine.cstInfo.set rslt
      FlowRouter.go '/voiceEmr'
    else FlowRouter.go '/voiceEmr'