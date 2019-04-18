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
        로봇속도: 50
    when 'customer'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        doctor_id: ''
        병실: ''
        침대번호: ''
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
    when 'voiceEMR'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        customer_id: ''
        yymmdd: ''
        so: ''
        a: ''
        p: ''
        주사: ''
        약처방: ''
    when 'bed_coordination' #참조없이 변경되면 변경하는 코드성 데이터
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        병원명: ''
        부서명: ''
        진료과명: ''
        병실번호: ''
        좌표: ''
    when 'schedule'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        customer_id: '' #고객명, 환자번호 등 참조
        병원기관기호: '012'  #012(서울성모)
        진료과코드: ''   #2050000000
        진료과명: ''    #[본관2층]정형외과
        doctor_id: '' # _id
        의사명: ''
        진료일자: ''    #20190310 yyyymmdd
        진료시간: ''    #1150     hhmm
        일정종류: ''    #진료, 수납, 검사예약, 주사, 약, 검사
        상태메시지: ''   #접수, 대기, 완료, 보류
        가셔야할곳: ''   #poiNM 사용
        수납여부: ''    #수납/미수납


    when 'connection'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        connectionInfo: null    #{}
    else
      throw new Error '### Data Schema Not found'

  return _.extend rslt, addData
