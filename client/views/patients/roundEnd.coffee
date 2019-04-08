FlowRouter.route '/roundEnd', action: ->
  BlazeLayout.render 'main',
    content: 'roundEnd',
    hasHeader: true
    hasFooter: true
  return

Template.roundEnd.onCreated ->
Template.roundEnd.onRendered ->
Template.roundEnd.helpers
Template.roundEnd.events
  'click [name=goDetail]': (evt, inst) ->
    FlowRouter.go '/patientDetail'
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    $("[name=roundEndPopup]").css('display', 'block')
  'click [name=confirmRoundEnd]': (evt, inst) ->
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->
