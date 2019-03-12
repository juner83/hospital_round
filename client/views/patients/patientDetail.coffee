FlowRouter.route '/patientDetail', action: ->
  BlazeLayout.render 'main', content: 'patientDetail'
  return

Template.patientDetail.onCreated ->
Template.patientDetail.onRendered ->
Template.patientDetail.helpers
Template.patientDetail.events
