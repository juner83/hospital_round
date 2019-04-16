Meteor.methods
  serverLogout: (_id) ->
    Meteor.users.update _id: _id,
      $set:
        'services.resume.loginTokens': []
  setDefaultCstInfo: ->
    CollectionCustomers.findOne _id: '1'
  moveToNextCst: ->
    CollectionCustomers.findOne _id: '2'
  reqVideoSync: ->
    syncCall = Meteor.wrapAsync(Meteor.call, Meteor)

    try
      result = syncCall 'reqVideo'
      if result.code? and (result.code is 'ECONNREFUSED')
        throw new Meteor.Error '비디오 서버연결 이상으로 협진 진행이 불가합니다. #4001'
      else
        cl 'video request complete'
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
