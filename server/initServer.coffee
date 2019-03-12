Meteor.startup ->
  unless Meteor.users.findOne(username: 'admin')
    cl 'initServer/make admin'
    options = {}
    options.username = 'admin'
    options.password = 'admin123@'
    options.profile = dataSchema 'profile',
      authority: 'master'
      scName: 'master'
    Accounts.createUser options


