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
  datacontext.curData = new ReactiveVar()

Template.voiceEmr.onRendered ->
Template.voiceEmr.helpers
  cstInfo: -> if (info=mDefine.cstInfo.get())? then return info
  emrs: -> CollectionVoiceEMRs.find({}, {sort: yymmdd: 1})
  selData: -> Template.instance().data?.selData
  curData: -> Template.instance().data?.curData
Template.voiceEmr.events
  'click [name=btnPastEMR]': (evt, inst) ->
    _id = $(evt.target).attr('data-id')
    datacontext = inst.data
    datacontext.selData.set CollectionVoiceEMRs.findOne(_id: _id)
    $('#popup').css('display', 'block')
  'click [name=btnClosePastPopup]': (evt, inst) ->
    $('#popup').css('display', 'none')

