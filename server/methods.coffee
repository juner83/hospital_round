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
      so: _emr.so
      a: _emr.a
      p: _emr.p
      주사: _emr.주사
      약처방: _emr.약처방
    CollectionVoiceEMRs.insert curEmr


  resetIsCompleted: ->
    cl 'methods/resetIsCompleted'
    CollectionCustomers.update isCompleted: true, {
        $set:
          isCompleted: false
      }, {
        multi: true
      }

