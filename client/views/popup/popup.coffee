@tempRv = new ReactiveVar()

Template.briefPopup.helpers
  팝업결과: ->
    if tempRv.get()? then tempRv.get()
Template.briefPopup.events
  'click .close > img': (evt, inst) ->
    evt.preventDefault()
    $('#briefPopup').css('display', 'none')
