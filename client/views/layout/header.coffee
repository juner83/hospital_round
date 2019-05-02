@tt = new Transcription
@dictate = new Dictate(
  server: "wss://#{mDefine.stt_uri}/client/ws/speech"
  serverStatus: "wss://#{mDefine.stt_uri}/client/ws/status"
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
  console.log text
  # $('#round_trans_area').val text
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
  $('#round_trans_area').val ''
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

Template.header.onCreated ->
#  init();
  inst = @
  datacontext = inst.data
  datacontext.isRecording = new ReactiveVar()
  datacontext.isRecording.set false

Template.header.onRendered ->
  window.parent.postMessage 'stt_init', '*'

  addEvent = (element, eventName, callback) ->
    if element.addEventListener
      element.addEventListener eventName, callback, false
    return

  addEvent document, 'keypress', (e) ->
    e = e or window.event
    # use e.keyCode
    if e.keyCode is 43
      $("[name=insert_mic]").click()
      str = $('#round_trans_area').val().replace(/\+/gi, '')
      $('#round_trans_area').val(str)
    return

  messagesHandler = (evt) ->
    cl 'message is comming from parent'
    #{type: "stt_text", value: "음성변환text"}
    #{type: "stt_command", value: "음성변환text"}
    if evt.data?.type is "stt_text"
      console.log(evt.data.value)
      $('#round_trans_area').val evt.data.value
    else if evt.data?.type is "stt_command"
      cl 'stt_command 응답 :::'
      console.log(evt.data.value)
      Meteor.call 'getVoiceCommand', evt.data.value, (err, rslt) ->
        if err then alert err
        else
          cl answer = rslt?.data?.data?.answerInfo?.answer
          qid_1 = rslt?.data?.data?.answerInfo?.qid_1
          if qid_1?.length > 0 and (qid_1 is '회진')
            switch FlowRouter.getRouteName()
              when '/patientList'
                switch answer
                  when 'PAGE_PATIENT' then $('[name=move]').click()
                  when 'PAGE_VOICEEMR' then $('[name=voiceEmr]').click()
                  when 'PAGE_ROUNDS_START' then $('[name=move]').click()
                  when 'PAGE_ROUNDS_END' then $('[name=end]').click()
              when '/patientDetail'
                switch answer
                  when 'PAGE_PATIENTLIST' then FlowRouter.go '/patientList'
                  when 'PAGE_VOICEEMR' then $('[name=voiceEmr]').click()
                  when 'PAGE_ROUNDS_TEAM' then $('[name=reqVideo]').click()
              when '/voiceEmr'
                switch answer
                  when 'PAGE_PATIENT' then FlowRouter.go '/patientDetail'
                  when 'SAVE_VOICEEMR' then $('[name=btnSaveCurData]').click()
                  when 'PAGE_ROUNDS_TEAM' then $('[name=reqVideo]').click()
              when '/roundEnd'
                switch answer
                  when 'CANCEL_ROUNDS' then FlowRouter.go '/patientList'
                  when 'END_ROUNDS' then $('[name=btnRoundEnd]').click()
              else mUtils.fr_tts("현재페이지에서는 사용할 수 있는 음성 명령어가 없습니다.")
          else mUtils.fr_tts("음성명령어가 제대로 인식되지 않았습니다. 다시 이용 바랍니다.")
  addEvent window, 'message', messagesHandler, false

clickedFlag = false
Template.header.events
  'click [name=btnRoundEnd]': (evt, inst) ->
    evt.preventDefault()
    FlowRouter.go '/Sungmo_round_0317/1_Main/round_main.html'
    location.reload()
#    Meteor.call 'serverLogout', Meteor.user()._id, (err, rslt) ->
    mUtils.fr_home()

  'click [name=reqVideo]': (evt, inst) ->
#    mUtils.CallTTS '협진을 요청하겠습니다. 잠시만 기다리십시오.'
    mUtils.fr_tts '협진을 요청중입니다. 잠시만 기다려 주십시오.'
    Meteor.call 'reqVideoSync', (err, rslt) ->
      if err then alert err
      else
        cl '협진요청 완료'

  'click [name=voiceEmr]': (evt, inst) ->
    cl cstInfo = mDefine.cstInfo.get()
    unless cstInfo then Meteor.call 'setDefaultCstInfo', (err, rslt) ->
      mDefine.cstInfo.set rslt
      FlowRouter.go '/voiceEmr'
    else FlowRouter.go '/voiceEmr'

  'click [name=voiceCommand]': (evt, inst) ->
#    datacontext = inst.data
    mUtils.fr_tts(' ')
    x = document.getElementById("myAudio")
    x.play()
#    startListening();
#    datacontext.isRecording.set true
    window.parent.postMessage 'stt_command', '*'

#    cl clickedFlag
#    if clickedFlag
#      clickedFlag = false
#      $('[name=insert_textarea]').focus()
##      custom_cancel();
#      datacontext.isRecording.set false
##      window.parent.postMessage 'stt_stop', '*'
#      cl text = tt.toString()
#      Meteor.call 'getVoiceCommand', text, (err, rslt) ->
#        if err then alert err
#        else
#          #todo 페이지별 음성커맨드 동작 수행
#          cl "@@@@@@@@@@@@"
#          cl rslt
#
#    else
#      x = document.getElementById("myAudio")
#      x.play()
#      clickedFlag = true
##      startListening();
#      datacontext.isRecording.set true
#      window.parent.postMessage 'stt_command', '*'
