FlowRouter.route '/login', action: ->
  BlazeLayout.render 'main', content: 'login'
  return

Template.login.onCreated ->
Template.login.onRendered ->
Template.login.helpers
Template.login.events
#  'click [name=btnLogin]': (evt, inst) ->
#    Meteor.loginWithPassword('admin', 'admin123@')
  'click .bg-card-tagging': (evt, inst) ->
    person = prompt('Please enter your password', '*********')
    if person != null
      Meteor.loginWithPassword('admin', 'admin123@')
      FlowRouter.go '/patientList'



