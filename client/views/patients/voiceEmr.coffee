FlowRouter.route '/voiceEmr', action: ->
  BlazeLayout.render 'main',
    content: 'voiceEmr'
    hasHeader: true
    hasFooter: true
  return

Template.voiceEmr.onCreated ->
Template.voiceEmr.onRendered ->
Template.voiceEmr.helpers
  cstInfo: -> if (info=mDefine.cstInfo.get())? then return info
Template.voiceEmr.events
  'click img': (e, t) ->
    FlowRouter.go '/roundEnd'
#    if confirm "회진을 종료하겠습니까?"
#      FlowRouter.go '/roundEnd'
#    else
#      FlowRouter.go '/patientList'
