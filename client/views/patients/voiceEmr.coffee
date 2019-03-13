FlowRouter.route '/voiceEmr', action: ->
  BlazeLayout.render 'main',
    content: 'voiceEmr'
  return

Template.voiceEmr.onCreated ->
Template.voiceEmr.onRendered ->
Template.voiceEmr.helpers
Template.voiceEmr.events
