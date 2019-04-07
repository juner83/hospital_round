Template.header.events
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    mUtils.GoMain()
    #    if confirm "홈으로 이동시 로그아웃 됩니다. 홈으로 이동하시겠습니까?"
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->

