FlowRouter.route '/voiceEmr', action: ->
  BlazeLayout.render 'main',
    content: 'voiceEmr'
  return

Template.voiceEmr.onCreated ->
Template.voiceEmr.onRendered ->
Template.voiceEmr.helpers
Template.voiceEmr.events
  'click img': (e, t) ->
    FlowRouter.go '/roundEnd'
#    if confirm "회진을 종료하겠습니까?"
#      FlowRouter.go '/roundEnd'
#    else
#      FlowRouter.go '/patientList'
