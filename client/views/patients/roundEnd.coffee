FlowRouter.route '/roundEnd', name: '/roundEnd', action: ->
  BlazeLayout.render 'main',
    content: 'roundEnd',
    hasHeader: true
    hasFooter: true
  return

Template.roundEnd.onCreated ->
  inst = @
  inst.subscribe 'pub_customers'

Template.roundEnd.onRendered ->
Template.roundEnd.helpers
  총환자: -> CollectionCustomers.find().count()
  완료환자: -> CollectionCustomers.find(isCompleted: true).count()
Template.roundEnd.events
  'click [name=goDetail]': (evt, inst) ->
    FlowRouter.go '/patientDetail'
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    $("[name=roundEndPopup]").css('display', 'block')
    mUtils.fr_tts '정상적으로 처리되었습니다. 감사합니다.'

  'click [name=confirmRoundEnd]': (evt, inst) ->
    Meteor.call 'robot_move', '0', '0', (err, rslt) -> if err then alert err
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
#    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->
    mUtils.fr_home()