Meteor.startup ->
  ##todo 추후 삭제, 개발용::refresh 등으로 인하여 선택한 환자정보가 날라갔을경우, default로 한명 선택
  unless mDefine.cstInfo.get()
    Meteor.call 'setDefaultCstInfo', (err, rslt) ->
      if err then alert err
      else
        mDefine.cstInfo.set(rslt)

  #오늘날짜 초기세팅 todo 시연용은 시연날짜로 하드코딩, 실제 today 로 변경 필요
  mDefine.todayYYMMDD = "20190423"

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