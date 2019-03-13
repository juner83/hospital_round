FlowRouter.route '/moveToBad', action: ->
  BlazeLayout.render 'main',
    content: 'moveToBad'
  return

Template.moveToBad.onCreated ->
Template.moveToBad.onRendered ->
  Meteor.setTimeout ->
    FlowRouter.go '/movedConfirm'
  , 1000 * 3
Template.moveToBad.helpers
Template.moveToBad.events

