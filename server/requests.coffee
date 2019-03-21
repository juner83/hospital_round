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
