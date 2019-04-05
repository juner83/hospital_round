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
    Meteor.call 'robot_move', "101", "1", (err, rslt) ->
      if err then alert "로봇서버와 연결이 끊겨 기동이 불가합니다. 관리자에게 연락바랍니다. 오류코드: #1001"
      else
        FlowRouter.go "/moveToBad"
  'click [name=end]': (evt, inst) ->
    evt.preventDefault()
    mDefine.cstInfo.set null
    FlowRouter.go "/roundEnd"

#  'click [name=robot_move]': (evt, inst) ->
#    Meteor.call 'robot_move',