#moment = require('moment')  #add momentjs:moment
#_ = require "underscore"

if Meteor.isServer
  @syncCall = Meteor.wrapAsync(Meteor.call, Meteor)
  @CollectionError = new Mongo.Collection 'error' #Collection for error logging

  Meteor.methods
    'console.log': (msg) ->
#      msg = "### #{if __file? then __file}/#{if __function? then __function}/#{if __line? then __line} $$$ #{msg}"
      console.log msg
    'throwError': (err) -> # err: thrown err object
      if typeof err is 'string'
        err = strMessage: err
      err.createdAt = new Date()
      err.__filename = __filename
      err.__function = __function
      err.__line = __line
      CollectionError.insert err

### Debug Info Usage
  err.createdAt = new Date()
  err.strMessage = err.toString()
  err.__filename = __filename
  err.__function = __function
  err.__line = __line
###
Object.defineProperty global, '__stack', get: ->
  orig = Error.prepareStackTrace

  Error.prepareStackTrace = (_, stack) ->
    stack

  err = new Error
  Error.captureStackTrace err, arguments.callee
  stack = err.stack
  Error.prepareStackTrace = orig
  stack

Object.defineProperty global, '__line', get: ->
  __stack[1].getLineNumber()
Object.defineProperty global, '__function', get: ->
  __stack[1].getFunctionName()

@isTestMode = do -> if process?.env?.IS_TEST_MODE is 'true' then true else false

@cl = (msg) ->
  if Meteor.isClient
#    return msg
    console.log msg
#    Meteor.call 'console.log', msg
  else
    console.log msg
#    Meteor.call 'console.log', msg
#    serverLog msg
#    return msg

# Date prototyping
@Date.prototype.addSeconds = (s) ->
  @setSeconds @getSeconds() + s
  return @
@Date.prototype.addMinutes = (m) ->
  @setMinutes @getMinutes() + m
  return @
@Date.prototype.addHours = (h) ->
  @setHours @getHours() + h
  return @
@Date.prototype.addDates = (d) ->
  @setDate @getDate() + d
  return @
@Date.prototype.addMonths = (value) ->
  n = @getDate()
  @setDate 1
  @setMonth @getMonth() + value
  @setDate Math.min(n, @getDaysInMonth())
  return @
@Date.prototype.addYears = (years) ->
  n = @getDate()
  @setDate 1
  @setMonth @getMonth() + (years*12)
  @setDate Math.min(n, @getDaysInMonth())
  return @

Date.isLeapYear = (year) ->
  year % 4 == 0 and year % 100 != 0 or year % 400 == 0
Date.getDaysInMonth = (year, month) ->
  [
    31
    if Date.isLeapYear(year) then 29 else 28
    31
    30
    31
    30
    31
    31
    30
    31
    30
    31
  ][month]
@Date.prototype.isLeapYear = ->
  Date.isLeapYear @getFullYear()
@Date.prototype.getDaysInMonth = ->
  Date.getDaysInMonth @getFullYear(), @getMonth()
Date.prototype.clone = -> return new Date @getTime()

@CheckTimer = class
  ### jwjin/1508210653
  checkTime = new CheckTimer()
  ...logic...
  checkTime.log 'check place 1'
  ...logic...
  checkTime.log 'check place 2'
  ...
  This will display a time taken by logic as it's name
  ###

  constructor: -> @lastTime = new Date()
  log: (name) ->
    now = new Date()
    cl "#{name}: #{now.getTime() - @lastTime.getTime()}"
    @lastTime = now
    return
#throw Error with log on DB
@throwError = (err) ->
  Meteor.call 'throwError', err #err object or string for message

testHome = ->
  window.parent.postMessage 'goHome', '*'
  # 버튼 클릭 하셨을 때 이부분 호출
  return

testTTS = (_msg) ->
  parameterObj =
    'type': 'TTS'
    'parameter': _msg
  ttsStrtoSend = JSON.stringify(parameterObj)
  window.parent.postMessage ttsStrtoSend, '*'
  return

OnScreenKeyboard = (isEnable, languageCode) ->
  msg = 'OnScreenKeyboard' + '$' + isEnable + '^' + languageCode
  window.parent.postMessage msg, '*'
  return

voiceCommand = (_msg) ->
  parameterObj =
    'type': 'voiceCommand'
    'parameter': _msg
  str = JSON.stringify(parameterObj)
  window.parent.postMessage str, '*'

@mUtils =
  fr_home: -> testHome()
  fr_tts: (_msg) -> testTTS(_msg)
  fr_tts_stop: (_msg) -> window.parent.postMessage 'stt_stopspeech', '*'
  fr_keyOn: -> OnScreenKeyboard(true, "ko-kr")
  fr_keyOff: -> OnScreenKeyboard(false, "ko-kr")
  fr_voiceCommand: (_msg) -> voiceCommand(_msg)
  getWeekday: (_yyyymmdd) ->
    date = new Date("#{_yyyymmdd.substring(0,4)}-#{_yyyymmdd.substring(4,6)}-#{_yyyymmdd.substring(6,8)}")
    switch date.getDay()
      when 1 then "월요일"
      when 2 then "화요일"
      when 3 then "수요일"
      when 4 then "목요일"
      when 5 then "금요일"
      when 6 then "토요일"
      when 0 then "일요일"

  dateFormat: ->
    date = new Date
    year = date.getFullYear()
    #yyyy
    month = 1 + date.getMonth()
    #M
    month = if month >= 10 then month else '0' + month
    # month 두자리로 저장
    day = date.getDate()
    #d
    day = if day >= 10 then day else '0' + day
    #day 두자리로 저장
    year + '' + month + '' + day

  getGroup_ids: (userInfo) ->
    #admin / company / center 의 userInfo를 넘기면 하위의 gruop_ids를 찾아서 [] return
    unless userInfo then userInfo = Meteor.user() #파람 없으면 현재 로그인 정보로 치환
    switch userInfo?.profile?.authority
      when 'admin' or 'sc'
        return userInfo.profile.group_ids
      when 'company'
        group_ids = []
        userInfo.profile.company_ids.forEach (company_id) ->
          CollectionGroups.find(p_id: company_id).forEach (group) ->
            group_ids.push group._id
        return group_ids
      when 'center'
        group_ids = []
        userInfo.profile.center_ids.forEach (center_id) ->
          CollectionCompanies.find(p_id: center_id).forEach (company) ->
            CollectionGroups.find(p_id: company._id).forEach (group) ->
              group_ids.push group._id
        return group_ids
      else []
#      else throw new Meteor.Error userInfo, 'getGroup_ids authority error'

  nullCheckDefault: (param, defaultType) ->
    if param?
      if (typeof param) is 'number' then return param.toString()
      else return param
    else
      switch defaultType
        when 'string' then return ''
        when 'array' then return []
        when 'object' then return {}
  getPadNumber: (n, length, char) ->
    # 0 padding / n: nunber, length: target length, char: pad character
    char = char or '0'
    n = n + ''
    if n.length >= length then n else new Array(length - (n.length) + 1).join(char) + n
  getRandomPaddedNumber: (n) ->
    # n: length (first padding with 0. ex> 001)
    # return typeof number
    add = 1
    max = 12 - add
    # 12 is the min safe number Math.random() can generate without it starting to pad the end with zeros.
    if n > max
      return generate(max) + generate(n - max)
    max = 10 ** (n + add)
    min = max / 10
    # Math.pow(10, n) basically
    number = Math.floor(Math.random() * (max - min + 1)) + min
    ('' + number).substring add
  getRandomNumber: (min, max) ->
    # min to max(exclude) / return typeof number
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min)) + min
  exist: (_obj) ->
    #return true when exist or return false
    if typeof _obj is 'number' then return true
    else return _obj? and !!_obj and !!Object.keys(_obj).length
  checkArgs: (condition, args) ->
    if !condition or (do -> return true for str in args when condition.hasOwnProperty(str) is false) then throw new Meteor.Error condition, 'method arguments error'
  getStringYMFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatYM)
  getStringYMDFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatYMD)
  getStringYMDdotFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatYMDdot)
  getStringMDHMFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatMDHM)
  getStringMDFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatMD)
  getStringHMSFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatHMS)
  getStringHFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatH)
  getStringMFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatM)
  getStringHMFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormatHM)
  getStringYMDHMSFromDate: (_date) ->
    return moment(_date).format(mDefine.timeFormat)
  getStringYMDHMSFromDate2: (_date) ->
    return moment(_date).format(mDefine.timeFormatYMDHMS2)
  getDateFromString: (_date) ->
    return moment(_date, mDefine.timeFormat).toDate()

#  replaceAll: (_string, _selector, _any) ->
#    revTest = _string.replace(/_selector/gi, _any); #selector -> regex로 변경 필요
#    return revTest

  formatBytes: (bytes, decimals) ->
#    usage: formatBytes(139328839)
    if(bytes == 0) then return '0 Byte'
    k = 1000
    dm = decimals + 1 || 3
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
    i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]

  getDateDiff: (date1, date2, interval) ->
    #usage: mydiff('date1', 'date2', 'days')
    second = 1000
    minute = second * 60
    hour = minute * 60
    day = hour * 24
    week = day * 7
    date1 = new Date(date1)
    date2 = new Date(date2)
    timediff = date2 - date1
    if isNaN(timediff)
      return NaN
    switch interval
      when 'years'
        return date2.getFullYear() - date1.getFullYear()
      when 'months'
        return date2.getFullYear() * 12 + date2.getMonth() - (date1.getFullYear() * 12 + date1.getMonth())
      when 'weeks'
        return Math.floor(timediff / week)
      when 'days'
        return Math.floor(timediff / day)
      when 'hours'
        return Math.floor(timediff / hour)
      when 'minutes'
        return Math.floor(timediff / minute)
      when 'seconds'
        return Math.floor(timediff / second)
      else
        return undefined

  getWellFormedDateString: (_digitString) ->
    tmp = _digitString.replace /-/g, ''
    rslt = tmp.substring 0,4
    rslt += '-'
    rslt += tmp.substring 4, 6
    rslt += '-'
    rslt += tmp.substring 6,8
    return rslt

  setConnectionPool: (status)->
    Meteor.setTimeout ->
      Meteor.call 'connectionPool', status, Router?.current()?.route?.name
    , 0

  isInt: (n) ->
  #return boolean
    n % 1 is 0

  log: ->
  #usage : Log().write('arg1', 'arg2')
    Log = Error
    Log.prototype.write = ->
      args = Array.prototype.slice.call arguments, 0
      suffix = if @lineNumber then 'line: ' + @lineNumber else 'stack: ' + @stack
      args.concat [suffix]

  isNumeric: (n) ->
    return !isNaN(parseFloat(n)) && isFinite(n)

  getClone: (_obj) ->
    # cannot clone function
    JSON.parse(JSON.stringify(_obj));

  getClass: (obj) ->
    if typeof obj is "undefined" then return "undefined"
    if obj is null then return "null"
    return Object.prototype.toString.call(obj).match(/^\[object\s(.*)\]$/)[1]

  getStartEndOfDate: (_date) ->
    strYMD = mUtils.getStringYMDFromDate _date
    return rslt =
      startAt: mUtils.getDateFromString(strYMD + ' 00:00:00')
      endAt: mUtils.getDateFromString(strYMD + ' 00:00:00').addDates(1)

  getObjectCounts: (_object) ->
    Object.keys(_object).length

  formatNumber: (str) ->
    unless str? then return ''
    str = str.toString()
    num = str.replace(/\,/gi, '')
    num.toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'

  hasOnlyDigits: (_val) ->
    if /^-?\d+\.?\d*$/.test _val then return true
    else return false

  formatStringToNumber: (str) ->
    unless str? then return ''
    num = str.replace(/\,/gi, '')
    parseInt(num)

  datePlusZeroWord: (_val) ->
    if _val.length < 2 then return '0' + _val
    else return _val

  stringToDateArray: (_str, _selector) ->
    arr = []
    temps = _str.split(_selector)
    temps.forEach (_string) ->
      arr.push new Date(_string.trim())
    return arr

  # get several times ago
  # Usage: timeSince new Date()
  # return: x minutes ago
  timeSince: (date) ->
    seconds = Math.floor((new Date - date) / 1000)
    interval = Math.floor(seconds / 31536000)
    if interval > 1
      return interval + ' years'
    interval = Math.floor(seconds / 2592000)
    if interval > 1
      return interval + ' months'
    interval = Math.floor(seconds / 86400)
    if interval > 1
      return interval + ' days'
    interval = Math.floor(seconds / 3600)
    if interval > 1
      return interval + ' hours'
    interval = Math.floor(seconds / 60)
    if interval > 1
      return interval + ' mins'
    return Math.floor(seconds) + ' seconds'

  # 2018.04.26 황준연
  # 데이트 포멧으로 인자를 전달해야 함.
  # 시작에서 종료시간까지 소요된 시간을 'hh:mm:ss' 문자열로 출력
  consumedTime: (startTime, endTime) ->
  # 시작 종료값을 거꾸로 넣었을 경우 처리
    if startTime > endTime
      temp = startTime
      startTime = endTime
      endTime = temp

    # 시작 종료값 밀리세컨드 전환
    startTime = startTime.getTime()
    endTime = endTime.getTime()
    conTime = endTime - startTime

    # 시:분:초 계산
    ms = conTime % 1000
    conTime = (conTime - ms) / 1000
    s = conTime % 60
    conTime = (conTime - s) / 60
    m = conTime % 60
    conTime = (conTime - m) / 60
    h = conTime % 60

    # 한자릿수 두 자릿수 문자열로 변경
    s = if s < 10 then '0' + s else '' + s
    m = if m < 10 then '0' + m else '' + m
    h = if h < 10 then '0' + h else '' + h

    # 결과 문자열 반환
    return h + ':' + m + ':' + s

  ###
    desc: 엑셀다운로드
    usage: mUtils.excelDownload(table_id, event)
  ###
  excelDownload: (table_id, event) ->
    #getting values of current time for generating the file name
    dt = new Date
    day = dt.getDate()
    month = dt.getMonth() + 1
    year = dt.getFullYear()
    hour = dt.getHours()
    mins = dt.getMinutes()
    postfix = day + '.' + month + '.' + year + '_' + hour + '.' + mins
    #creating a temporary HTML link element (they support setting file names)
    a = document.createElement('a')
    #getting data from our div that contains the HTML table
    data_type = 'data:application/vnd.ms-excel;charset=utf-8'
    table_div = document.getElementById(table_id)  ##가져오려는 타겟 table id
    table_html = table_div.outerHTML.replace(RegExp(' ', 'g'), '%20')
    a.href = data_type + ', ' + table_html
    #        a.charset="euc-kr"
    #setting the file name
    a.download = 'exported_table_' + postfix + '.xls'
    #triggering the function
    a.click()
    #just in case, prevent default behaviour
    return event.preventDefault()


if Meteor.isClient
  _.extend @mUtils,
    getCurrrentPath: ->
      c = window.location.pathname
      b = c.slice 0, -1
      a = c.slice -1
      if b is '' then return '/'
      else
        if a is '/' then return b
        else return c
    cordovaDeviceType: ->
      if navigator.userAgent.match(/iPad/i) or navigator.userAgent.match(/iPhone/i)
        return 'i'
      if navigator.userAgent.match(/Android/i)
        return 'a'

#if Meteor.isServer
#  _.extend @mUtils,
#    convertBase64ToFileUrl: (_html) ->
## html 텍스트를 받아서 base64 이미지만 추려서 업로드하고 url로 변경해서 넣은 후 리턴
#      cheerio = require 'cheerio'
#      $ = cheerio.load _html
#      $('img').each (idx, img) ->
##    $(내용).find('img').each (idx, img) ->
#        baseStr = $(img).attr 'src'
#        file = mUtils.convertBase64ToBinary baseStr
#        if file is 'notBase64' then return
#        fileInfo =
#          name: ''  #base64라서 이름이 없다.
#          size: file.binary.length
#          type: file.type
#          dir: settings.public.fileServerDir
#
#        fileServer = DDP.connect settings.public.fileServerIpPort
#        fut = new (require('fibers/future'))()
#        fileServer.call 'upload', fileInfo ,file.binary, (err, rslt) ->
#          if err then alert err.reason
#          fut.return rslt.path
#        tmpPath = fut.wait()
#        $(img).attr 'src', "#{mDefine.fileServerMark}#{tmpPath}"
#      return $('body').html()
#
#    convertBase64ToBinary: (dataURI) ->
#      BASE64_MARKER = ';base64,'
#      base64Index = dataURI.indexOf(BASE64_MARKER)
#      if base64Index is -1 then return 'notBase64'
#      base64Index += BASE64_MARKER.length
#      base64 = dataURI.substring(base64Index)
#      type = dataURI.substring 0, base64Index
#      type = type.split('/')[1].split(';')[0]
#
#      raw = require('atob')(base64)
#      rawLength = raw.length
#      array = new Uint8Array(new ArrayBuffer(rawLength))
#      i = 0
#      while i < rawLength
#        array[i] = raw.charCodeAt(i)
#        i++
#      return {
#        binary: array
#        type: type
#      }