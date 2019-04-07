Meteor.methods
  reqDoctorInfos: (hospital_id, doctor_id) ->
    try
      HTTP.call 'POST', "#{mDefine.bridgeUrl}/gateway/IN2002S00", {
        data: {}
      }, (err, rslt) ->
        if err
          cl err
        else
          cl rslt
          rslt.forEach (_doc) -> CollectionDoctors.insert _doc
    catch e
      cl e
    return

  reqCustomerInfos: (hospital_id, doctor_id) ->
    try
      HTTP.call 'GET', "#{mDefine.bridgeUrl}/gateway/IN2002S00", (err, rslt) ->
        if err
          cl err
        else
          cl rslt
          rslt.forEach (_doc) -> CollectionDoctors.insert _doc
    catch e
      cl e
    return

  reqVideo: ->
    try
      HTTP.get 'http://127.0.0.1:1111/Conference/Start', (resp) ->
        cl resp
        if resp.code? and (resp.code is 'ECONNREFUSED')
          throw new Meteor.Error '비디오 서버연결 이상으로 협진 진행이 불가합니다. #4001'
        else
          cl 'video request complete'
    catch e
      throw new Meteor.Error '비디오 서버연결 이상으로 협진 진행이 불가합니다. #4001'
    return