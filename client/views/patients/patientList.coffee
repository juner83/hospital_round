FlowRouter.route '/patientList', action: ->
  BlazeLayout.render 'main',
    content: 'patientList',
    hasHeader: true
    hasFooter: true
  return

Template.patientList.onCreated ->
Template.patientList.onRendered ->
Template.patientList.helpers
  lists: ->
    [
      {
      선택: "선택1"
      번호: "번호1"
      병실: "병실1"
      성명: "성명1"
      등록번호: "등록번호1"
      진단명: "진단명1"
      수술명: "수술명1"
      HOD: "HOD1"
      POD: "POD1"

      }
      {
      선택: "선택2"
      번호: "번호2"
      병실: "병실2"
      성명: "성명2"
      등록번호: "등록번호2"
      진단명: "진단명2"
      수술명: "수술명2"
      HOD: "HOD2"
      POD: "POD2"

      }
      {
      선택: "선택3"
      번호: "번호3"
      병실: "병실3"
      성명: "성명3"
      등록번호: "등록번호3"
      진단명: "진단명3"
      수술명: "수술명3"
      HOD: "HOD3"
      POD: "POD3"

      }
    ]

Template.patientList.events
  'click [name=goDetail]': (evt, inst) ->
    FlowRouter.go '/patientDetail'