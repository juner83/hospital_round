param = {}
tempRes = undefined
tempCode = {}

commonAjaxGet = (param, cbFunc) ->
  commonAjax 'Get', param, cbFunc

commonAjaxPost = (param, cbFunc) ->
  commonAjax 'Post', param, cbFunc

commonAjax = (method, param) ->
  e = undefined
  result = undefined
  try
    result = HTTP.call('POST', 'http://121.135.148.170:29000/' + 'bridge' + method, data: param)
  catch _error
    e = _error
    throw new (Meteor.Error)('Data API. #Bridge')
  result

tempCode.hospital = '015'
# 기관코드
tempCode.dutplcecd = '2050000000'
# 근무지부서코드
tempCode.fromdd = '20180101'
# 유효시작일자
Meteor.methods dataBatch: ->
  cl 'methods/dataBatch'
  CollectionCustomers.remove({})
  CollectionResults.remove({})
  CollectionVoiceEMRs.remove({})
  try
# 1. 의사ID 획득(하드코딩)
    doctorIds = [ 95610268 ]
    # 1-1. 의사정보 획득
    doctorIds.forEach (row, idx) ->
      param =
        'hospital_id': tempCode.hospital
        'submit_id': 'DRZUM00499'
        'business_id': 'sz'
        'dutplceinstcd': '015'
        'userid': row
        'dutplcecd': tempCode.dutplcecd
        'fromdd': tempCode.fromdd
      #의사정보
      tempRes = dataModel.doctor(commonAjaxGet(param))
      cl 'doctor Info'
      # 2. 의사별 환자리스트 획득(환자정보저장) - 환자별 경과 기록지
      param =
        'hospital_id': tempCode.hospital
        'submit_id': 'DRARC20000'
        'business_id': 'mr'
        'instcd': '015'
        'userid': row
        'dutplcecd': tempCode.dutplcecd
        'orddd': mUtils.dateFormat()
      tempRes = dataModel.patient(commonAjaxGet(param), row)
      cl 'patients Info'
      return
  catch e
    throw new (Meteor.Error)(e.message)
  try
# 4. 나의스케쥴 리스트 획득 / 저장 - TODO 실시간
  catch e
    throw new (Meteor.Error)(e.message)
  'data batch complete'
dataModel =
  doctor: (data) ->
# 환자리스트 데이터 리모델링
    tempData = {}
    try
      tempData = JSON.parse(data.content)
      tempData = tempData.root
    catch e
#      cl e
      tempData = data.content.root;
    unless (_user = tempData.ret.users) then return
    _username = _user.userid.toString()
    if Meteor.users.find(username: _username).count() > 0
      Meteor.users.update username: _user.userid.toString(),
        $set:
          이름: _user.usernm
          진료과: _user.dutplcenm
          부서: _user.posdeptnm
          병원명: _user.posinstnm
    else
      options = {}
      options.username = _username
      options.password = _username
      options.profile = dataSchema 'profile',
        이름: _user.usernm
        진료과: _user.dutplcenm
        부서: _user.posdeptnm
        병원명: _user.posinstnm
      Accounts.createUser options
    return { 'doctor': tempData.ret.users }
  patient: (data, doctor_username) ->
# 환자리스트 데이터 리모델링
    tempData = {}
    try
      tempData = JSON.parse(data.content)
      tempData = tempData.root.tmp
    catch e
      cl(e)
      tempData = data.content.root.tmp
    reData = []
    if tempData.patlist
      if Array.isArray(tempData.patlist)
        tempData.patlist.forEach (row, idx) ->
          reData.push dataFormat.patient(row, doctor_username)
          return
      else
        reData.push dataFormat.patient(tempData.patlist)
    # 3. 환자별 경과 기록지

    reData.forEach (row, idx) ->
      unless row?.등록번호 then return
      param =
        'hospital_id': tempCode.hospital
        'submit_id': 'DRARC20001'
        'business_id': 'mr'
        'instcd': '015'
        'pid': row.등록번호
      tempResult = dataModel.result(commonAjaxGet(param))
      row.result = tempResult.result
      row.voiceEMR = tempResult.voiceEMR
      return
    reData = 'customer': reData
    reData
  schedule: (data) ->
# 스케줄 데이터 리모델링
    tempData = {}
    try
      tempData = JSON.parse(data.content)
      tempData = tempData.root.tmp
    catch e
      tempData = data.content.root.tmp
    reData = []
    if tempData.list
      if Array.isArray(tempData.list)
        tempData.list.forEach (row, idx) ->
          reData.push dataFormat.schedule(row)
          return
      else
        reData.push dataFormat.schedule(tempData.list)
    console.log 'Schedule : ', 'schedule': reData
    { 'schedule': reData }
  result: (data) ->
# 검진결과 데이터 리모델링
    tempData = {}
    try
      tempData = JSON.parse(data.content)
      tempData = tempData.root.tmp
    catch e
      tempData = data.content.root.tmp
    reData =
      customer: {}
      result: []
      voiceEMR: []
    if tempData.patinfo
      reData.customer = dataFormat.patient_pod(tempData.patinfo)
    if tempData.reclist
      if Array.isArray(tempData.reclist)
        tempData.reclist.forEach (row, idx) ->
          reData.voiceEMR.push dataFormat.retVoiceEMR(row, tempData.prcplist, tempData.patinfo.pid)
          return
      else
        reData.voiceEMR.push dataFormat.retVoiceEMR(tempData.reclist, tempData.prcplist, tempData.patinfo.pid)

    if tempData.btlist
      if Array.isArray(tempData.btlist)
        tempData.btlist.forEach (row, idx) ->
          reData.result.push dataFormat.retResult('혈액검사', row, tempData.patinfo.pid)
          return
      else
        reData.result.push dataFormat.retResult('혈액검사', tempData.btlist, tempData.patinfo.pid)
    if tempData.bctlist
      if Array.isArray(tempData.bctlist)
        tempData.bctlist.forEach (row, idx) ->
          reData.result.push dataFormat.retResult('세균배양검사', row, tempData.patinfo.pid)
          return
      else
        reData.result.push dataFormat.retResult('세균배양검사', tempData.bctlist, tempData.patinfo.pid)
    if tempData.biopsylist
      if Array.isArray(tempData.biopsylist)
        tempData.biopsylist.forEach (row, idx) ->
          reData.result.push dataFormat.retResult('조직검사', row, tempData.patinfo.pid)
          return
      else
        reData.result.push dataFormat.retResult('조직검사', tempData.biopsylist, tempData.patinfo.pid)
    reData
dataFormat =
  patient_pod: (_cst) ->
    unless _cst.pid then return
    CollectionCustomers.update({등록번호: _cst.pid.toString()},{$set: {POD: _cst.pod.toString()}})
    return _cst

  patient: (data, doctor_username) ->
    tempData = {}
    unless data.roomcd?.split('-')[0] is '13' then return
    unless data.pid then return
    if CollectionCustomers.find(등록번호: data.pid).count() > 0
      cst = CollectionCustomers.findOne 등록번호: data.pid
    else
      cst = dataSchema 'customer'
    cst.doctor_id = doctor_username.toString()
    cst.병실 = if data.roomcd then data.roomcd.split('-')[1] else ''
#    cst.침대번호 = 'TODO_침대번호'
    cst.이름 = if data.hngnm then data.hngnm else ''
    cst.등록번호 = if data.pid then data.pid.toString() else ''
    cst.진단명 = if data.diagnm then data.diagnm else ''
    cst.수술명 = if data.opnm then data.opnm else ''
    cst.HOD = if data.hd then data.hd.toString() else ''
    cst.POD = if data.pod then data.pod.toString() else ''

    CollectionCustomers.upsert 등록번호: data.pid.toString(), cst
    return cst

  schedule: (data) ->
    tempData = {}
    tempData.customer_id = 'TODO_customer_id'
    tempData.병원기관기호 = if data.hospitalCd then data.hospitalCd else ''
    tempData.진료과코드 = if data.departmentCd then data.departmentCd else ''
    tempData.진료과명 = if data.departmentNm then data.departmentNm else ''
    tempData.doctor_id = if data.doctorId then 'TODO_' + data.doctorId else ''
    tempData.의사명 = if data.doctorNm then data.doctorNm else ''
    tempData.진료일자 = if data.visitDt then data.visitDt else ''
    tempData.진료시간 = if data.visitTm then data.visitTm else ''
    tempData.일정종류 = if data.visitKind then data.visitKind else ''
    tempData.상태메시지 = if data.statusNm then data.statusNm else ''
    tempData.가셔야할곳 = if data.poiNm then data.poiNm else ''
    tempData.수납여부 = if data.rcptNm then data.rcptNm else ''
    tempData
  retVoiceEMR: (data, prcplist, cst_pid) ->
    tempData = dataSchema 'voiceEMR'
    tempData.customer_id = cst_pid.toString()
    tempData.yymmdd = if data.recdd then data.recdd.toString() else ''
    tempData.so = if data.rec_so then data.rec_so else ''
    tempData.a = if data.rec_a then data.rec_a else ''
    tempData.p = if data.rec_p then data.rec_p else ''
    tempData.약처방 = ''
    # 약
    tempData.주사 = ''
    # 주사
    if Array.isArray(prcplist)
      prcplist.forEach (row, idx) ->
        if data.recdd == row.prcpdd
          if row.prcpclscd == 'A2'
# 약처방
            tempData.약처방 += row.prcpnm + ' ' + row.prcpdetl + '\n'
          else if row.prcpclscd == 'A6'
# 주사처방
            tempData.주사 += row.prcpnm + ' ' + row.prcpdetl + '\n'
        return
    else
      if data.recdd == prcplist.prcpdd
        if prcplist.prcpclscd == 'A2'
# 약처방
          tempData.약처방 += prcplist.prcpnm + ' ' + prcplist.prcpdetl + '\n'
        else if prcplist.prcpclscd == 'A6'
# 주사처방
          tempData.주사 += prcplist.prcpnm + ' ' + prcplist.prcpdetl + '\n'
    CollectionVoiceEMRs.insert tempData
    return tempData
  retResult: (type, data, cst_pid) ->
    tempData = dataSchema 'result'
    tempData.customer_id = cst_pid.toString()
    tempData.검사종류 = type
    tempData.진단일 = if data.prcpdd then data.prcpdd else ''
    tempData.보고일 = if data.reptdt then data.reptdt else ''
    tempData.검사명 = if data.testnm then data.testnm else ''
    tempData.결과 = if data.testrslt then data.testrslt else ''
    tempData.판정 = if data.judgmark then data.judgmark else ''
    tempData.단위 = if data.rsltunit then data.rsltunit else ''
    tempData.참고치 = if data.refinfo then data.refinfo else ''
    tempData.세부검체 = if data.detlspcnm then data.detlspcnm else ''
    if type is '조직검사' then tempData.진단일 = if data.testdd then data.testdd else ''
    CollectionResults.insert tempData
    return tempData