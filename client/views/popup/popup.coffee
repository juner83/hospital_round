Template.briefPopup.onRendered ->
  $(document).ready ->
    Meteor.setTimeout ->
      $('.slider-container').ikSlider
        speed: 500
        autoPlay: false
        infinite: true
        touch: false
      $('.slider-container').on 'changeSlide.ikSlider', (evt) ->
        console.log evt.currentSlide
      return
    , 1000

Template.briefPopup.helpers
  pacs: ->
    pacs = Template.instance().data?.pacs.get()
    return pacs
Template.briefPopup.events
  'click .close > img': (evt, inst) ->
    evt.preventDefault()
    $('#briefPopup').css('display', 'none')
