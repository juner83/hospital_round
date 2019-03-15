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
    FlowRouter.go '/html/main/round_main.html'
    location.reload()
    Meteor.logout()
