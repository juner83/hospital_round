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

