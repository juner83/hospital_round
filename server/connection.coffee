#todo 임시 조치, 클라이언트 연결이 끊기면 모든 의사 로그아웃처리
Meteor.onConnection (_connection) ->
  _connection.onClose () ->
    cl 'connection closed'
    Meteor.users.find().forEach (_user) ->
      Meteor.users.update _id: _user._id,
        $set:
          'services.resume.loginTokens': []
