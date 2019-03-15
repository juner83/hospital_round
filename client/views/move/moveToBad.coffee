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
  고객명: -> return mDefine.cstInfo.get()?.이름
Template.moveToBad.events

