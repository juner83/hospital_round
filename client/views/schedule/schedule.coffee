FlowRouter.route '/schedule', action: ->
  BlazeLayout.render 'schedule',
    content: 'schedule',
    hasHeader: true
    hasFooter: true
  return

Template.schedule.onCreated ->
  inst = @
#  inst.subscribe 'pub_voiceEMRs', mDefine.cstInfo.get()?._id
  datacontext = inst.data
  datacontext.selectedTab = new ReactiveVar('today')  #today/nextday
#  datacontext.selectedDay = mDefine.todayYYMMDD
  datacontext.condition = new ReactiveVar {
    where: {
      진료일자: mDefine.todayYYMMDD
    }
    options: {
      sort:
        진료일자: 1
        진료시간: 1
      skip: 0
      limit: mDefine.schedule_psize
    }
  }
  datacontext.curData = new ReactiveVar({})
  datacontext.CollectionNull = new Mongo.Collection null
  Meteor.call 'getMySchedule', mDefine.cstInfo.get()?._id, (err, rslt) ->
    if err then alert err
    else
      datacontext.curData.set rslt  #rslt = {obj:{}, arr:[]}
      rslt.arr.forEach (_obj) ->
        datacontext.CollectionNull.insert _obj

Template.schedule.onRendered ->
  inst = @
  datacontext = inst.data

Template.schedule.helpers
  dayInfo: ->
    today = Template.instance().data?.condition.get().where.진료일자
    weekday = mUtils.getWeekday today
    return "#{today?.substring(4,6)}월 #{today?.substring(6,8)}일 #{weekday}"
  isNext: ->  #미래일정이면 true, 오늘일정이면 false
    curTab = Template.instance().data?.selectedTab.get()
    if curTab is 'nextday' then return true
  hasData: ->
    Template.instance().data?.curData?.get().obj?.days?.length > 0
  _진료일자: ->
    day = @진료일자
    return "#{day.substring(4,6)}월 #{day.substring(6,8)}일"
  days: -> Template.instance().data.curData.get().obj.days
  datas: ->
    datacontext = Template.instance().data
#    cl datacontext.condition.get()
    datacontext.CollectionNull.find(datacontext.condition.get().where, datacontext.condition.get().options)
  _진료시분: -> return @진료시간.substring(0,2) + "시 " + @진료시간.substring(2,4) + "분"
  hasNext: -> #다음페이지 있으면 true
    datacontext = Template.instance().data
    condition = datacontext.condition.get()
    count = datacontext.CollectionNull.find(condition.where).count()
    if count > (condition.options.skip / mDefine.schedule_psize + 1) * mDefine.schedule_psize then return true
  hasPrev: -> #이전페이지 있으면 true
    datacontext = Template.instance().data
#    cl datacontext.condition.get().options.skip
    return !(datacontext.condition.get().options.skip is 0)

Template.schedule.events
  'click [name=goToHome]': (evt, inst) ->
    mUtils.GoMain()

  'click [name=today_tab]': (evt, inst) ->
    $('[name=today_tab]').children().attr('src', '/images/schedule/stab_today_h.png')
    $('[name=nextday_tab]').children().attr('src', '/images/schedule/stab_nextday.png')
    datacontext = inst.data
    datacontext.selectedTab.set 'today'
    condition = datacontext.condition.get()
    condition.where.진료일자 = mDefine.todayYYMMDD
    condition.options.skip = 0
    datacontext.condition.set condition

    mUtils.keyboardOn()

  'click [name=nextday_tab]': (evt, inst) ->
    $('[name=today_tab]').children().attr('src', '/images/schedule/stab_today.png')
    $('[name=nextday_tab]').children().attr('src', '/images/schedule/stab_nextday_h.png')
    datacontext = inst.data
    datacontext.selectedTab.set 'nextday'
    Meteor.setTimeout ->
      $("[name=dateTab]")[1].click()
    , 100

    mUtils.keyboardOff()

  'click [name=dateTab]': (evt, inst) ->
    selDate = $(evt.target).attr('data-day')
    datacontext = inst.data
    condition = datacontext.condition.get()
    condition.where.진료일자 = selDate
    condition.options.skip = 0
    datacontext.condition.set condition
    $("[name=dateTab]").removeClass('selected')
    $(evt.target).addClass('selected')

  'click .btn_bnext': (evt, inst) ->
    datacontext = inst.data
    condition = datacontext.condition.get()
    condition.options.skip = condition.options.skip + mDefine.schedule_psize
    datacontext.condition.set condition

  'click .btn_bprev': (evt, inst) ->
    datacontext = inst.data
    condition = datacontext.condition.get()
    condition.options.skip = condition.options.skip - mDefine.schedule_psize
    datacontext.condition.set condition
