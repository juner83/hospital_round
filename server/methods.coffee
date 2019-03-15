Meteor.methods
  serverLogout: (_id) ->
    Meteor.users.update _id: _id,
      $set:
        'services.resume.loginTokens': []
