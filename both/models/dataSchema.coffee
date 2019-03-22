#if Meteor.isServer
#  _ = Npm.require "underscore"
@dataSchema = (_objName, _addData) ->
  rslt = {}
  # add 될 데이터가 있다면 return 시에 extend 해서 반환한다.
  addData = _addData or {}
  createdAt = new Date()
  switch _objName
    when 'profile'
      rslt =
        authority: 'doctor'
        이름: ''
        진료과: ''
        부서: ''
        병원명: ''
    when 'customer'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        doctor_id: ''
        병실: ''
        이름: ''
        등록번호: ''
        진단명: ''
        수술명: ''
        HOD: ''
        POD: ''
    when 'pacs'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        customer_id: ''
        imageLink: ''
    when 'result'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        customer_id: ''
        검사종류: ''  #혈액검사, 세균배양검사, 조직검사
        진단일: createdAt
        보고일: createdAt
        검사명: ''
        결과: ''
        판정: ''
        단위: ''
        참고치: ''
        세부검체: ''
    when 'bed_coordination' #참조없이 변경되면 변경하는 코드성 데이터
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        병원명: ''
        부서명: ''
        진료과명: ''
        병실번호: ''
        좌표: ''
    when 'connection'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        connectionInfo: null    #{}
    else
      throw new Error '### Data Schema Not found'

  return _.extend rslt, addData
