FlowRouter.route '/login', action: ->
  BlazeLayout.render 'main', content: 'login'
  return

Template.login.onCreated ->
Template.login.onRendered ->
Template.login.helpers
Template.login.events
  'click .round_m_photo': (evt, inst) ->
    Meteor.loginWithPassword('admin', 'admin123@')
    FlowRouter.go '/patientList'
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
#    if confirm "홈으로 이동시 로그아웃 됩니다. 홈으로 이동하시겠습니까?"
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->
