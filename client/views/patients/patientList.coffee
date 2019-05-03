FlowRouter.route '/patientList', name: '/patientList', action: ->
  BlazeLayout.render 'main',
    content: 'patientList',
    hasHeader: true
    hasFooter: true
  return

Template.patientList.onCreated ->
  Meteor.loginWithPassword('95610268', '95610268')
  mDefine.cstInfo.set null
  inst = @
  inst.subscribe 'pub_customers'

Template.patientList.onRendered ->
Template.patientList.helpers
  lists: -> CollectionCustomers.find()
  번호: (index) -> return index+1
  completed: -> if @isCompleted then return "round_completed"
  총환자: -> CollectionCustomers.find().count()
  완료환자: -> CollectionCustomers.find(isCompleted: true).count()

Template.patientList.events
  'click [name=move]': (evt, inst) ->
    evt.preventDefault()
    cst_id = $('input[name=radio_patientList]:checked').attr("data-id")
    if cst_id then mDefine.cstInfo.set CollectionCustomers.findOne(_id: cst_id)
    else
      mDefine.cstInfo.set CollectionCustomers.findOne(isCompleted: false)
    FlowRouter.go "/moveToBed"
  'click [name=end]': (evt, inst) ->
    evt.preventDefault()
    mDefine.cstInfo.set null
    FlowRouter.go "/roundEnd"
  'click [name=tts_test_btn]': (evt, inst) ->
    cl msg = $("[name=tts_test_inp]").val()
    mUtils.fr_tts msg
  'click [name=keyon_test_btn]': (evt, inst) ->
    cl 'keyOn'
    mUtils.fr_keyOn()
  'click [name=keyoff_test_btn]': (evt, inst) ->
    cl 'keyOff'
    mUtils.fr_keyOff()

  'click .doctor_photo': (evt, inst) ->
    Meteor.call 'dataBatch', (err, rslt) ->
      if err then alert err
      else cl rslt

  'click [name=reset_isCompleted]': (evt, inst) ->
    Meteor.call 'resetIsCompleted', (err, rslt) ->
      if err then alert err
      else
        cl '회진여부 초기화 완료'