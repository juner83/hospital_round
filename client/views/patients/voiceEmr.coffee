tt = new Transcription
dictate = new Dictate(
  server: 'wss://puzzle-ai.com:8021/client/ws/speech'
  serverStatus: 'wss://puzzle-ai.com:8021/client/ws/status'
  recorderWorkerPath: '/js/stt/recorderWorker.js'
  onReadyForSpeech: ->
    __message 'READY FOR SPEECH'
    __status '녹취중입니다'
    return
  onEndOfSpeech: ->
    __message 'END OF SPEECH'
    __status '녹취가 종료되었습니다'
    return
  onEndOfSession: ->
    __message 'END OF SESSION'
    __status '세션이 종료되었습니다'
    return
  onServerStatus: (json) ->
    __serverStatus json.num_workers_available + ':' + json.num_requests_processed
    if json.num_workers_available == 0
      $('#buttonStart').prop 'disabled', true
      $('#serverStatusBar').addClass 'highlight'
    else
      $('#buttonStart').prop 'disabled', false
      $('#serverStatusBar').removeClass 'highlight'
    return
  onPartialResults: (hypos) ->
# TODO: demo the case where there are more hypos
    tt.add hypos[0].transcript, false
    __updateTranscript tt.toString()
    return
  onResults: (hypos) ->
# TODO: demo the case where there are more results
    tt.add hypos[0].transcript, true
    __updateTranscript tt.toString()
    # diff() is defined only in diff.html
    if typeof diff == 'function'
      diff()
    return
  onError: (code, data) ->
    __error code, data
    __status 'Viga: ' + code
    dictate.cancel()
    return
  onEvent: (code, data) ->
    __message code, data
    return
)
# Private methods (called from the callbacks)

__message = (code, data) ->
  cl "__message" + code + data
#  log.innerHTML = 'msg: ' + code + ': ' + (data or '') + '\n' + log.innerHTML
  return

__error = (code, data) ->
  cl "__error" + code + data
#  log.innerHTML = 'ERR: ' + code + ': ' + (data or '') + '\n' + log.innerHTML
  return

__status = (msg) ->
  cl "__status" + msg
#  statusBar.innerHTML = msg
  return

__serverStatus = (msg) ->
  cl "__serverStatus" + msg
#  serverStatusBar.innerHTML = msg
  return

__updateTranscript = (text) ->
  text_ori = text
  text_split = text.split(' ')
  i = undefined
  i = 0
  while i < text_split.length
    if !text_split[i].match('/^[A-Za-z]+$/')
      text_split[i] = text_split[i].charAt(0).toUpperCase() + text_split[i].slice(1).toLowerCase()
    if text_split[i].length <= 2
      text_split[i] = text_split[i].toLowerCase()
    if text_split[i].toUpperCase() == 'EGD' or text_split[i].toUpperCase() == 'IV'
      text_split[i] = text_split[i].toUpperCase()
    i++
  text = text_split.join(' ')
  text = text.replace(/미리 그람/gi, 'mg').replace(/증상 에/gi, '증상에').replace(/전처치 로/gi, '전처치로').replace(/식 도/gi, '식도').replace(/오십/gi, '50').replace(/십\ /gi, '10 ').replace(/오/gi, '5').replace(/퍼센트/gi, '%')
  text = text
  console.log text
  $('#round_trans_area').val text
  return

# Public methods (called from the GUI)

toggleLog = ->
#  $(log).toggle()
  return

clearLog = ->
#  log.innerHTML = ''
  return

clearTranscription = ->
  tt = new Transcription
  $('#trans').val ''
  return

startListening = ->
  cl 'startListening'
  dictate.startListening()
  return

stopListening = ->
  dictate.stopListening()
  return

custom_cancel = ->
  dictate.cancel()
  return

init = ->
  dictate.init()
  return

showConfig = ->
  pp = JSON.stringify(dictate.getConfig(), undefined, 2)
#  log.innerHTML = pp + '\n' + log.innerHTML
#  $(log).show()
  return


# ---
# generated by js2coffee 2.2.0
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
  init()  #STT init

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
    stopListening();
  'click [name=insert_mic]': (evt, inst) ->
    #버튼은 비활성화, 마이크 버튼 누르면 변경
    custom_cancel(); #cancle()은 함수 충돌인지 호출시 오류가나서 이름을 변경함, 이걸 넣어줘야 멈췄다 재실행 할때 되더라(이유모름 내부적으로 그렇게 하길래)
    startListening();
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