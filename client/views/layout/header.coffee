Template.header.events
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    mUtils.GoMain()
    #    if confirm "홈으로 이동시 로그아웃 됩니다. 홈으로 이동하시겠습니까?"
    # FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    # location.reload()
    # Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->

  'click [name=reqVideo]': (evt, inst) ->
#    mUtils.CallTTS '협진을 요청하겠습니다. 잠시만 기다리십시오.'
    Meteor.call 'reqVideoSync', (err, rslt) ->
      if err then alert err
      else
        cl '협진요청 완료'
