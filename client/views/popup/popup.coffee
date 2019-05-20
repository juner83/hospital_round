@tempRv = new ReactiveVar()

Template.briefPopup.onRendered ->
  $(document).ready ->
    Meteor.setTimeout ->
      $('.slider-container').ikSlider speed: 500
      $('.slider-container').on 'changeSlide.ikSlider', (evt) ->
        console.log evt.currentSlide
        return
    , 1000

Template.briefPopup.helpers
  팝업결과: ->
    if tempRv.get()? then tempRv.get()
  pacs: ->
    pacs = Template.instance().data?.pacs.get()
    return pacs
Template.briefPopup.events
  'click .close > img': (evt, inst) ->
    evt.preventDefault()
    $('#briefPopup').css('display', 'none')
