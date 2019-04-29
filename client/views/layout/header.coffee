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
  text = text.replace(/미리 그람/gi, 'mg').replace(/증상 에/gi, '증상에').replace(/전처치 로/gi, '전처치로').replace(/식 도/gi, '식도').replace(/오십/gi, '50').replace(/십\ /gi, '10 ').replace(/오/gi, '5').replace(/퍼센트/gi, '%')
  text = text
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
  init();
  inst = @
  datacontext = inst.data
  datacontext.isRecording = new ReactiveVar()
  datacontext.isRecording.set false
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
    datacontext = inst.data
    cl clickedFlag
    if clickedFlag
      clickedFlag = false
      $('[name=insert_textarea]').focus()
      custom_cancel();
      datacontext.isRecording.set false
      window.parent.postMessage 'stt_stop', '*'
      cl text = tt.toString()
      Meteor.call 'getVoiceCommand', text, (err, rslt) ->
        if err then alert err
        else
          #todo 페이지별 음성커맨드 동작 수행 
          cl "@@@@@@@@@@@@"
          cl rslt

    else
      x = document.getElementById("myAudio")
      x.play()
      clickedFlag = true
      startListening();
      datacontext.isRecording.set true
      window.parent.postMessage 'stt_start', '*'
