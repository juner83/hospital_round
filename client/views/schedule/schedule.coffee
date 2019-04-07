FlowRouter.route '/schedule', action: ->
  BlazeLayout.render 'schedule',
    content: 'schedule',
    hasHeader: true
    hasFooter: true
  return

Template.schedule.events
  'click [name=goToHome]': (evt, inst) ->
    mUtils.GoMain()
