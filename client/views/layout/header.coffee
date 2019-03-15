Template.header.events
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    if confirm "홈으로 이동시 로그아웃 됩니다. 홈으로 이동하시겠습니까?"
      FlowRouter.go '/html/main/round_main.html'
      location.reload()
      Meteor.logout()

