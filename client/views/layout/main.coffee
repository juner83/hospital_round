FlowRouter.route '/', action: (params, queryParams) ->
  FlowRouter.go '/patientList'
#  BlazeLayout.render 'main',
#    content: 'patientList',
#    hasHeader: true
#    hasFooter: true
  return

Template.main.onRendered ->

Template.main.helpers
#  hasHeader: (bool) -> return bool

Template.main.events
  # 인풋 타입 넘버일 경우 값 유효성 체크(테그 프로퍼티 min, max가 적용되지 않는 IE를 위한 이벤트 컨트롤)
  'keyup input[type=number]': (eve)->
    return inputNumberValueCheck eve
  'blur input[type=number]': (eve)->
    return inputNumberValueCheck eve
  'change input[type=number]': (eve)->
    return inputNumberValueCheck eve

  'click .btn-sort': (eve,ins)-> # 정렬버튼 클릭시
    condition = ins.data.condition.get()
    if !condition.sort then return # 컨디션이 세팅되지 않았거나 솔트가 없을 경우 리턴
    val = eve.currentTarget.getAttribute 'data-sort'
    sort = if condition.sort[val] == -1 then "#{val}": 1 else "#{val}": -1
    condition.sort = sort
    condition.skip = 0
    page = document.getElementById 'input-current-page'
    if page and page.value then page.value = 1
    ins.data.condition.set condition
    return

  'click #btn-day': (eve) -> # 기간 당일 버튼 클릭시
    setBtnClass eve
    setPeriod 1

  'click #btn-week': (eve) -> # 기간 일주일 버튼 클릭시
    setBtnClass eve
    setPeriod 7

  'click #btn-month': (eve) -> # 기간 한달 버튼 클릭시
    setBtnClass eve
    setPeriod 30

  'click #btn-3month': (eve) -> # 기간 3개월 버튼 클릭시
    setBtnClass eve
    setPeriod 90

  'click #btn-year': (eve) -> # 기간 1년 버튼 클릭시
    setBtnClass eve
    setPeriod 365

  'click #btn-month-scResult': (eve) -> # 기간 당일 버튼 클릭시 (실적관리 전용)
    setBtnClass eve
    setPeriodScResult 0

  'click #btn-3month-scResult': (eve) -> # 기간 3개월 버튼 클릭시 (실적관리 전용)
    setBtnClass eve
    setPeriodScResult 2

  'click #btn-6month-scResult': (eve) -> # 기간 6개월 버튼 클릭시 (실적관리 전용)
    setBtnClass eve
    setPeriodScResult 5

  'click #btn-year-scResult': (eve) -> # 기간 1년 버튼 클릭시 (실적관리 전용)
    setBtnClass eve
    setPeriodScResult 11

  'click #btn-5year': (eve) -> # 기간 5년 버튼 클릭시
    setBtnClass eve
    setPeriod 365 * 5

  'click #start_toggle': -> # ~부터 달력 아이콘
    $('#input-startDate').focus()

  'click #end_toggle': -> # ~까지 달력 아이콘
    $('#input-endDate').focus()