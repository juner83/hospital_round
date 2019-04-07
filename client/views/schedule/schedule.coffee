FlowRouter.route '/schedule', action: ->
  BlazeLayout.render 'schedule',
    content: 'schedule',
    hasHeader: true
    hasFooter: true
  return
