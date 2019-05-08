FlowRouter.route '/patientList', name: '/patientList', action: ->
  BlazeLayout.render 'main',
    content: 'patientList',
    hasHeader: true
    hasFooter: true
  return

FlowRouter.route '/temp', name: '/temp', action: ->
  BlazeLayout.render 'main',
    content: 'patientList',
    hasHeader: true
    hasFooter: true
  return

Template.patientList.onCreated ->
  Meteor.loginWithPassword('95610268', '95610268')
  mDefine.cstInfo.set null
  inst = @
  datacontext = inst.data
  datacontext.condition = new ReactiveVar({
    where: {},
    options: {
      skip: 0
      limit: mDefine.cst_psize
      sort:
        병실: 1
    }
  })

  inst.subscribe 'pub_customers', ->
    datacontext.pageInfo = new ReactiveVar({
      total: CollectionCustomers.find().count()
      pageArray: do ->
        arr = []
        i = 0
        size = Math.floor( (CollectionCustomers.find().count()-1) / mDefine.cst_psize) + 1
        while i < size
          arr.push (i+1)
          i++
        return arr
      curPage: 1
    })

Template.patientList.onRendered ->

Template.patientList.helpers
  lists: ->
    if Template.instance().subscriptionsReady()
      datacontext = Template.instance().data
      cond = datacontext.condition.get()
      CollectionCustomers.find(cond.where, cond.options)
  번호: (index) -> return index+1
  completed: -> if @isCompleted then return "round_completed"
  회진일: -> mUtils.getStringYMDFromDate(new Date()) + " " + mUtils.getWeekday(mUtils.dateFormat())
  진료과: -> Meteor.user()?.profile.진료과
  주치의: -> Meteor.user()?.profile.이름
  isTemp: -> FlowRouter.getRouteName() is '/temp'


  #페이징
  page: ->
    if Template.instance().subscriptionsReady()
      datacontext = Template.instance().data
      datacontext?.pageInfo?.get()?.pageArray
  selected: (_index) ->
    if Template.instance().subscriptionsReady()
      datacontext = Template.instance().data
      cl curPage = datacontext.pageInfo.get().curPage
      if _index is curPage then return "selected"
  #페이징

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

#  페이징
  'click .page_num': (evt, inst) ->
    pageNo = $(evt.target).attr('data-val')
    datacontext = inst.data
    cond = datacontext.condition.get()
    cond.options.skip = ( (pageNo-1) * mDefine.cst_psize )
    datacontext.condition.set cond
    pageInfo = datacontext.pageInfo.get()
    pageInfo.curPage = parseInt pageNo
    datacontext.pageInfo.set pageInfo

  'keyup [name="inpBedNo"]': (evt, inst) ->
    cl value = $(evt.target).val()
    cl _id = $(evt.target).attr('data-id')
    if evt.keyCode is 13
      Meteor.call 'saveBedNo', _id, value, (err, rslt) ->
        if err then alert err
        else cl '저장되었습니다.'
