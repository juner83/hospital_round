FlowRouter.route '/patientDetail', name: '/patientDetail', action: ->
  BlazeLayout.render 'main',
    content: 'patientDetail'
    hasHeader: true
    hasFooter: true
  return

Template.patientDetail.onCreated ->
  inst = @
  inst.subscribe 'pub_results'

Template.patientDetail.onRendered ->
  ##tab control
  $(document).ready ->
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

