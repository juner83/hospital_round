@tempRv = new ReactiveVar()

Template.briefPopup.onRendered ->
  $(document).ready ->
    $('.slider-container').ikSlider speed: 500
    $('.slider-container').on 'changeSlide.ikSlider', (evt) ->
      console.log evt.currentSlide
      return


Template.briefPopup.helpers
  팝업결과: ->
    if tempRv.get()? then tempRv.get()
Template.briefPopup.events
  'click .close > img': (evt, inst) ->
    evt.preventDefault()
    $('#briefPopup').css('display', 'none')
