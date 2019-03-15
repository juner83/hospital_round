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
      번호: "1"
      병실: "501"
      성명: "박소민"
      등록번호: "1301245"
      진단명: "TFCC injury, wrist"
      수술명: "신경박리술"
      HOD: "HOD1"
      POD: "POD1"
      }
      {
      선택: "선택2"
      번호: "2"
      병실: "502"
      성명: "주소현"
      등록번호: "1242535"
      진단명: "Pan-peritonitis"
      수술명: "고주파 수핵성형술"
      HOD: "HOD2"
      POD: "POD2"
      }
      {
      선택: "선택3"
      번호: "3"
      병실: "503"
      성명: "배성진"
      등록번호: "1403459"
      진단명: "Herniation of intervertevral disc"
      수술명: "인공디스크치환술"
      HOD: "HOD3"
      POD: "POD3"
      }
    ]

Template.patientList.events
  'click [name=goDetail]': (evt, inst) ->
    FlowRouter.go '/patientDetail'