FlowRouter.route '/voiceEmr', action: ->
  BlazeLayout.render 'main',
    content: 'voiceEmr'
    hasHeader: true
    hasFooter: true
  return

Template.voiceEmr.onCreated ->
  inst = @
  inst.subscribe 'pub_voiceEMRs', mDefine.cstInfo.get()?._id
  datacontext = inst.data
  datacontext.selData = new ReactiveVar()
  datacontext.curData = new ReactiveVar({})

Template.voiceEmr.onRendered ->
Template.voiceEmr.helpers
  cstInfo: -> if (info=mDefine.cstInfo.get())? then return info
  emrs: -> CollectionVoiceEMRs.find({}, {sort: yymmdd: 1})
  selData: -> Template.instance().data?.selData.get()
  curData: -> Template.instance().data?.curData.get()
Template.voiceEmr.events
  'click [name=btnPastEMR]': (evt, inst) ->
    _id = $(evt.target).attr('data-id')
    datacontext = inst.data
    datacontext.selData.set CollectionVoiceEMRs.findOne(_id: _id)
    $('#popup').css('display', 'block')
    $('#emr_pop_1').css('display', 'block')
  'click [name=btnClosePastPopup]': (evt, inst) ->
    $('#popup').css('display', 'none')
    $('.pop03').css('display', 'none')
  'click [name=btnGetPastPopup]': (evt, inst) ->
    $('#popup').css('display', 'none')
    $('.pop03').css('display', 'none')
    datacontext = inst.data
    datacontext.curData.set datacontext.selData.get()
  'click [name=btnInsertPopup]': (evt, inst) ->
    $('#popup').css('display', 'block')
    $('#emr_pop_2').css('display', 'block')
  'click [name=btnSaveCurData]': (evt, inst) ->
    $('.pop03').css('display', 'none')
    $('#dim').css('display', 'block')
  'click [name=goToCstList]': ->
    FlowRouter.go '/patientList'
  'click [name=goToNextCst]': (evt, inst) ->
    Meteor.call 'moveToNextCst', (err, rslt) ->
      if err then alert err
      else
        cl rslt
        mDefine.cstInfo.set rslt
        FlowRouter.go '/moveToBed'

  'click [name=insert_write]': (evt, inst) ->
    $('[name=insert_textarea]').focus()
  'click [name=insert_mic]': (evt, inst) ->
    #버튼은 비활성화, 마이크 버튼 누르면 변경
  'click [name=insert_save]': (evt, inst) ->
    field = $('[name=pop_emr]:checked').attr('id')
    value = $('[name=insert_textarea]').val()
    unless field?.length > 0 then return alert("입력항목을 선택해주세요.")
    datacontext = inst.data
    curData = datacontext.curData.get()
    curData[field] = value
    datacontext.curData.set curData
    $('#popup').css('display', 'none')
    $('.pop03').css('display', 'none')
  'click [name=pop_emr]': (evt, inst) ->
    field = $('[name=pop_emr]:checked').attr('id')
    value = $('[name=insert_textarea]').val()
    datacontext = inst.data
    curData = datacontext.curData.get()
#    cl curData[field]
    $('[name=insert_textarea]').val(curData[field])