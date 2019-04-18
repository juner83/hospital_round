FlowRouter.route '/patientList', action: ->
  BlazeLayout.render 'main',
    content: 'patientList',
    hasHeader: true
    hasFooter: true
  return

Template.patientList.onCreated ->
  mDefine.cstInfo.set null
  inst = @
  inst.subscribe 'pub_customers'

Template.patientList.onRendered ->
Template.patientList.helpers
  lists: -> CollectionCustomers.find()
  번호: (index) -> return index+1


Template.patientList.events
  'click [name=move]': (evt, inst) ->
    evt.preventDefault()
    cst_id = $('input[name=radio_patientList]:checked').attr("data-id")
    if cst_id then mDefine.cstInfo.set CollectionCustomers.findOne(_id: cst_id)
    else
      mDefine.cstInfo.set CollectionCustomers.findOne(_id: '1')
  'click [name=end]': (evt, inst) ->
    evt.preventDefault()
    mDefine.cstInfo.set null
    FlowRouter.go "/roundEnd"
  'click [name=tts_test_btn]': (evt, inst) ->
    cl msg = $("[name=tts_test_inp]").val()
    Meteor.call 'tts_call', msg, (err, rslt) ->
      if err then alert err
      else
        cl 'TTS전송 완료'
#  'click [name=robot_move]': (evt, inst) ->
#    Meteor.call 'robot_move',