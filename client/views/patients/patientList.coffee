FlowRouter.route '/patientList', action: ->
  BlazeLayout.render 'main', content: 'patientList'
  return

Template.patientList.onCreated ->
Template.patientList.onRendered ->
Template.patientList.helpers
Template.patientList.events
