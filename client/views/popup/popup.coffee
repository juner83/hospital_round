@tempRv = new ReactiveVar()

Template.popup.helpers
  팝업결과: ->
    if tempRv.get()? then tempRv.get()
Template.popup.events
  'click .close > img': (evt, inst) ->
    evt.preventDefault()
    $('#popup').css('display', 'none')
