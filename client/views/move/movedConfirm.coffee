FlowRouter.route '/movedConfirm', action: ->
  BlazeLayout.render 'main',
    content: 'movedConfirm'
  return

Template.movedConfirm.onCreated ->
Template.movedConfirm.onRendered ->
Template.movedConfirm.helpers
Template.movedConfirm.events
  'click [name=btnCancle]': (evt, inst) ->
    FlowRouter.go '/patientList'
  'click [name=btnGo]': (evt, inst) ->
    FlowRouter.go '/patientDetail'

