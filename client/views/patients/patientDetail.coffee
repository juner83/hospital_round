FlowRouter.route '/patientDetail', action: ->
  BlazeLayout.render 'main',
    content: 'patientDetail'
    hasHeader: true
    hasFooter: true
  return

Template.patientDetail.onCreated ->
  inst = @
  inst.subscribe 'pub_results'
  datacontext = inst.data
  datacontext.imageName = new ReactiveVar(false)

Template.patientDetail.onRendered ->
  ##tab control
  $(document).ready ->
    cl 1
    $('.tabs > li').click()
    cl 2
    $('.tab_contents').hide()
    $('.tab_contents:first').show()
    $('ul.tabs li').click ->
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
  검사: (param) -> CollectionResults.find({검사종류: param},{limit: 4})
  imageName: ->
    datacontext = Template.instance().data
    return datacontext?.imageName.get()

Template.patientDetail.events
  'click [name=imgModal]': (evt, inst) ->
    evt.preventDefault()
    src = $(evt.target).attr('src')
    $("#img01").attr("src", src)
    $(".modal-content").css('display', 'block')
    $("#briefPopup").css('display', "block")
    $(".pop01").css('display', "block")
    $(".pop02").css('display', "none")
  'click [name=pop]': (evt, inst) ->
    evt.preventDefault()
    tempRv.set $(evt.target).attr('data-content') ##결과만 팝업에 넘기는 임시 변수
    $(".modal-content").css('display', 'none')
    $('#briefPopup').css('display', 'block')
    $(".pop01").css('display', "none")
    $(".pop02").css('display', "block")

  'click .tabs > li': (evt, inst) ->
    if $(evt.target).parent().hasClass('nU_btn')
      FlowRouter.go '/voiceEmr'
    else
      idNo  = mDefine.cstInfo.get()?._id
      if !idNo then idNo = "1"
      tabNo = $(evt.target).attr('rel')?.substr(3,3)
      if !tabNo then tabNo = "1"
      datacontext = inst.data
      cl "/temp/#{idNo}_#{tabNo}.jpg"
      datacontext.imageName.set "/temp/#{idNo}_#{tabNo}.jpg"