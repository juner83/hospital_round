FlowRouter.route '/patientDetail', action: ->
  BlazeLayout.render 'main',
    content: 'patientDetail'
    hasHeader: true
    hasFooter: true
  return

Template.patientDetail.onCreated ->
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
Template.patientDetail.events