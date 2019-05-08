Meteor.methods
  serverLogout: (_id) ->
    Meteor.users.update _id: _id,
      $set:
        'services.resume.loginTokens': []
  setDefaultCstInfo: ->
    CollectionCustomers.findOne(isCompleted: false)
  moveToNextCst: () ->
    doctor_id = Meteor.user()?.username
    if doctor_id
      CollectionCustomers.findOne doctor_id: doctor_id, isCompleted: false
    else CollectionCustomers.findOne isCompleted: false
  reqVideoSync: ->
    syncCall = Meteor.wrapAsync(Meteor.call, Meteor)

    try
      result = syncCall 'reqVideo'
#      if result.code? and (result.code is 'ECONNREFUSED')
#        throw new Meteor.Error '비디오 서버연결 이상으로 협진 진행이 불가합니다. #4001'
#      else
#        cl 'video request complete'
    catch e
      throw new Meteor.Error '비디오 서버연결 이상으로 협진 진행이 불가합니다. #4001'

  getMySchedule: (_cst_id) ->
    unless _cst_id then _cst_id = '1'
    schedules = CollectionSchedules.find({customer_id: _cst_id},{sort: 진료일자: 1}).fetch()
    distinctData = _.uniq schedules, false, (_data) ->
      _data.진료일자
#    days = _.pluck distinctData, '진료일자'
    return {
      obj: {days: distinctData}
      arr: schedules
    }

  getMyScheduleByNo: (_regNo) ->
    unless _regNo then throw new Meteor.Error '바코드 인식 오류'
    schedules = []
    pushMan = (_data) ->  #_data = result.data.root.list
      if _data.length <= 0 then return
      unless _data.result then return
      if Array.isArray(_data.result)
        _data.result.forEach (_obj) ->
          obj = dataSchema 'schedule',
            customer_id: _regNo #고객명, 환자번호 등 참조
            병원기관기호: '015'  #012(서울성모)
            진료과코드: _obj.departmentCd   #2050000000
            진료과명: _obj.departmentNm    #[본관2층]정형외과
            doctor_id: _obj.doctorId # username
            의사명: _obj.doctorNm
            진료일자: _obj.visitDt    #20190310 yyyymmdd
            진료시간: _obj.visitTm    #1150     hhmm
            일정종류: _obj.visitKind    #진료, 수납, 검사예약, 주사, 약, 검사
            상태메시지: _obj.statusNm   #접수, 대기, 완료, 보류
            가셔야할곳: _obj.poiNm   #poiNM 사용
            수납여부: _obj.rcptNm    #수납/미수납
          schedules.push obj
      else
        obj = dataSchema 'schedule',
          customer_id: _regNo #고객명, 환자번호 등 참조
          병원기관기호: '015'  #012(서울성모)
          진료과코드: _data.result.departmentCd   #2050000000
          진료과명: _data.result.departmentNm    #[본관2층]정형외과
          doctor_id: _data.result.doctorId # username
          의사명: _data.result.doctorNm
          진료일자: _data.result.visitDt    #20190310 yyyymmdd
          진료시간: _data.result.visitTm    #1150     hhmm
          일정종류: _data.result.visitKind    #진료, 수납, 검사예약, 주사, 약, 검사
          상태메시지: _data.result.statusNm   #접수, 대기, 완료, 보류
          가셔야할곳: _data.result.poiNm   #poiNM 사용
          수납여부: _data.result.rcptNm    #수납/미수납
        schedules.push obj
    try
      param =
        "hospital_id" : "015"
        "submit_id" : "DRBPA13001"
        "business_id" : "mb"
        "ex_interface" : "MOB|015"
        "hospitalCd" : "015"
        "patientId" : _regNo
        "jobCd" : "TOD"
      result1 = HTTP.call('POST', 'http://121.135.148.170:29000/bridgeGet', data: param)
      Meteor.wrapAsync(pushMan(result1.data.root.list))
      param.jobCd = "RES"
      result2 = HTTP.call('POST', 'http://121.135.148.170:29000/bridgeGet', data: param)
      Meteor.wrapAsync(pushMan(result2.data.root.list))

    catch e
      throw new Meteor.Error e.message

#    cl schedules
#    schedules = CollectionSchedules.find({customer_id: _cst_id},{sort: 진료일자: 1}).fetch()
    distinctData = _.uniq schedules, false, (_data) ->
      _data.진료일자
#    days = _.pluck distinctData, '진료일자'
    return {
      obj: {days: distinctData}
      arr: schedules
    }

  getVoiceCommand: (_msg) ->
    try
      result = HTTP.call 'POST', 'http://localhost:64003/chat/message', {
        data: {
          "cid": "web_5c9c05de-f1ab-4a8f-ad58-850e571d6932",
          "type": "text",
          "msg": _msg
        }
      }
      # cl result
    catch e
      throw new Meteor.Error '음성커맨드 서버 오류. #5001'
    return result

  saveVoiceEmr: (_id, _emr) ->
    cl 'methods/saveVoiceEmr'
    CollectionCustomers.update _id: _id,
      $set:
        isCompleted: true
    cl _emr
    curEmr = dataSchema 'voiceEMR',
      customer_id: CollectionCustomers.findOne(_id: _id).등록번호
      yymmdd: mUtils.dateFormat()
      so: _emr.so or ""
      a: _emr.a or ""
      p: _emr.p or ""
      주사: _emr.주사 or ""
      약처방: _emr.약처방 or ""
    CollectionVoiceEMRs.insert curEmr


  resetIsCompleted: ->
    cl 'methods/resetIsCompleted'
    CollectionCustomers.update isCompleted: true, {
        $set:
          isCompleted: false
      }, {
        multi: true
      }

  saveBedNo: (cst_id, _bedNo) ->
    cl 'methods/saveBedNo'
    CollectionCustomers.update _id: cst_id,
      $set:
        침대번호: _bedNo
