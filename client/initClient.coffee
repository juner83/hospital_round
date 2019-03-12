Meteor.startup ->
#  @CollectionMessagesTmp = new Mongo.Collection null
#  @streamer = new Meteor.Streamer('chat')
#  interval = null;
#  Tracker.autorun ->
#    if Meteor.userId()
#      interval = Meteor.setInterval ->
#        unless UserStatus.isMonitoring() then libClient.startMonitor()
#        if UserStatus.isMonitoring()
#          if UserStatus.lastActivity()?
#            Meteor.call 'setLastActivityDiff', (err, rslt) ->
#              if err then cl err
#      , @mDefine.lastActivityCheckTime
#    else
#      Meteor.clearInterval(interval)