FlowRouter.route '/patientDetail', name: '/patientDetail', action: ->
  BlazeLayout.render 'main',
    content: 'patientDetail'
    hasHeader: true
    hasFooter: true
  return

Template.patientDetail.onCreated ->
  inst = @
  datacontext = inst.data
  datacontext.condition = new ReactiveVar({
    where: {},
    options: {
      skip: 0
      limit: mDefine.result_psize
      sort:
        진단일: -1
    }
  })

  inst.subscribe 'pub_pacs', mDefine.cstInfo.get()?.등록번호
  inst.subscribe 'pub_results', mDefine.cstInfo.get()?.등록번호, ->
    datacontext.pageInfo = new ReactiveVar({
      total: CollectionResults.find().count()
      pageArray: do ->
        arr = []
        i = 0
        size = Math.floor( (CollectionResults.find(검사종류:'혈액검사').count()-1) / mDefine.result_psize) + 1
#        if size is 1 then return []
        while i < size
          arr.push (i+1)
          i++
        return arr
      curPage: 1
    })


Template.patientDetail.onRendered ->
  ##tab control
  inst = @
  data = inst.data
  $(document).ready ->
    $('.tab_contents').hide()
    $('.tab_contents:first').show()
    $('ul.tabs li').click ->
      #paging
      pageInfo = data.pageInfo.get()
      name = this.innerText
      pageInfo.pageArray = do ->
        arr = []
        i = 0
        size = Math.floor( (CollectionResults.find(검사종류:name).count()-1) / mDefine.result_psize) + 1
        #        if size is 1 then return []
        while i < size
          arr.push (i+1)
          i++
        return arr
      data.pageInfo.set pageInfo

      #tab control
      activeTab = $(this).attr('rel')
      if activeTab
        $('ul.tabs li').removeClass 'active'
        $(this).addClass 'active'
        $('.tab_contents').hide()
        $('#' + activeTab).fadeIn()
      return
    return


Template.patientDetail.helpers
  cstInfo: -> if (info=mDefine.cstInfo.get())? then return info
  검사: (param) ->
    if Template.instance().subscriptionsReady()
      data = Template.instance().data
      CollectionResults.find({검사종류: param}, data.condition.get().options)
  보고일: -> @보고일.toString().substring(0, 8)
  pacsImages: ->
    cursor = CollectionPacs.find({}, {limit:2})
    cl cursor.fetch()
    return cursor

#페이징
  page: ->
    if Template.instance().subscriptionsReady()
      datacontext = Template.instance().data
      datacontext?.pageInfo?.get()?.pageArray
  selected: (_index) ->
    if Template.instance().subscriptionsReady()
      datacontext = Template.instance().data
      cl curPage = datacontext.pageInfo.get().curPage
      if _index is curPage then return "selected"
#페이징


Template.patientDetail.events
  'click [name=imgModal]': (evt, inst) ->
    evt.preventDefault()
    $("#briefPopup").css('display', "block")


#  'click [name=imgModal]': (evt, inst) ->
#    evt.preventDefault()
#    src = $(evt.target).attr('src')
#    $("#img01").attr("src", src)
#    $(".modal-content").css('display', 'block')
#    $("#briefPopup").css('display', "block")
#    $(".pop01").css('display', "block")
#    $(".pop02").css('display', "none")
  'click [name=pop]': (evt, inst) ->
    evt.preventDefault()
    tempRv.set $(evt.target).attr('data-content') ##결과만 팝업에 넘기는 임시 변수
    $(".modal-content").css('display', 'none')
    $('#briefPopup').css('display', 'block')
    $(".pop01").css('display', "none")
    $(".pop02").css('display', "block")

#  페이징
  'click .page_num': (evt, inst) ->
    pageNo = $(evt.target).attr('data-val')
    datacontext = inst.data
    cond = datacontext.condition.get()
    cond.options.skip = ( (pageNo-1) * mDefine.result_psize )
    datacontext.condition.set cond
    pageInfo = datacontext.pageInfo.get()
    pageInfo.curPage = parseInt pageNo
    datacontext.pageInfo.set pageInfo
