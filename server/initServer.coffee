Meteor.startup ->
  unless Meteor.users.findOne(username: 'admin')
    cl 'initServer/make admin'
    options = {}
    options.username = 'admin'
    options.password = 'admin123@'
    options.profile = dataSchema 'profile',
      authority: 'master'
      scName: 'master'
    Accounts.createUser options


#  call = Meteor.wrapAsync Meteor.call, Meteor
#  try
#    HTTP.call 'POST', "#{mDefine.gateWayUrl}/gateway/IN2002S00", {
#      data: {}
#    }, (err, rslt) ->
#      if err
#        cl err
#      else
#        cl rslt
#  catch e
#    cl e
##    cl call 'decryptPj', e
#  return

#  if Meteor.users.find(username: $ne: 'admin').count() <= 0
#    cl "make doctor data"
#    options = {}
#    options.username = 'doctor'
#    options.password = 'doctor123@'
#    options.profile = dataSchema 'profile',
#      이름: '나성모'
#      진료과: '정형외과'
#      부서: '관절센터'
#      병원명: '은평성모'
#    Accounts.createUser options
#
#  unless CollectionCustomers.findOne()
#    cl "make customer data"
#    doctor = Meteor.users.findOne(authority: 'doctor')
#    csts = ['박소민', '조진현', '이성계', '김덕호', '송은재']
#    for i in [1 .. 5]
#      cst = dataSchema 'customer',
#        doctor_id: doctor._id
#        병실: "50#{i}"
#        이름: csts[i-1]
#        등록번호: Random.hexString 7
#        진단명: "TFCC injury, wrist"
#        수술명: "신경박리술"
#        HOD: ''
#        POD: ''
#
#      cst_id = CollectionCustomers.insert cst
#      for j in [1..6]
#        rslt = dataSchema 'result',
#          customer_id: cst_id
#          검사종류: ''

  customers = [
    {
      _id: "1"
      병실: "501"
      이름: "박소민"
      등록번호: "902154"
      진단명: "Chronic knee arthritis"
      수술명: "TKRA"
      HOD: "7"
      POD: "6"
    },
    {
      _id: "2"
      병실: "502"
      이름: "주소현"
      등록번호: "845212"
      진단명: "Femor neck fx"
      수술명: "total hip arthroplasty"
      HOD: "9"
      POD: "8"
    },
    {
      병실: "503"
      이름: "김현성"
      등록번호: "994512"
      진단명: "T12 Compression Fx"
      수술명: "-"
      HOD: "1"
      POD: "-"
    },
    {
      병실: "505"
      이름: "이한얼"
      등록번호: "711692"
      진단명: "DM foot"
      수술명: "Amputation"
      HOD: "3"
      POD: "1"
    },

  ]

  unless CollectionCustomers.findOne()
    customers.forEach (_obj) ->
      cst = dataSchema 'customer', _obj
      CollectionCustomers.insert cst

  results = [
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: "2019-03-15"
      보고일: ""
      검사명: "CBC 5종"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "WBC count"
      결과: "6.6"
      판정: ""
      단위: "10^9/L"
      참고치: "4.0~10.0"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Hemoglobin"
      결과: "10.5"
      판정: "▼"
      단위: "g/dl"
      참고치: "11.5~16.0"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Hematocrit"
      결과: "30.2"
      판정: "▼"
      단위: "%"
      참고치: "35.0~48.0"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Platelet count"
      결과: "105"
      판정: "▼"
      단위: "0^9/L"
      참고치: "150~450"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "WBC Diff. Count"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Seg.-neutrophils"
      결과: "81.3"
      판정: "▲"
      단위: "%"
      참고치: "50~75"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Lymphocytes"
      결과: "11.3"
      판정: "▼"
      단위: "%"
      참고치: "20~44"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Monocytes"
      결과: "7.0"
      판정: ""
      단위: "%"
      참고치: "2~9"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Eosinophils"
      결과: "0.2"
      판정: "▼"
      단위: "%"
      참고치: "1~5"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Basophils"
      결과: "0.2"
      판정: ""
      단위: "%"
      참고치: "0~2"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "ANC 계산"
      결과: "5.4"
      판정: ""
      단위: "10^9/L"
      참고치: ">0.5"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: "2019-03-14"
      보고일: ""
      검사명: "Total Protein"
      결과: "4.64"
      판정: "▼"
      단위: "g/dl"
      참고치: "6.0~8.3"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Albumin"
      결과: "3.09"
      판정: "▼"
      단위: "g/dl"
      참고치: "3.5~5.3"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Sodium"
      결과: "141"
      판정: ""
      단위: "mmol/L"
      참고치: "135~145"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Potassium"
      결과: "4.2"
      판정: ""
      단위: "mmol/L"
      참고치: "3.5~5.5"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Chloride"
      결과: "108"
      판정: ""
      단위: "mmol/L"
      참고치: "98~110"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "AST(GOT)"
      결과: "25"
      판정: ""
      단위: "IU/L"
      참고치: "8~40"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "ALT(GPT)"
      결과: "13"
      판정: ""
      단위: "IU/L"
      참고치: "5~35"
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "혈액검사"
      진단일: ""
      보고일: ""
      검사명: "Total Bilirubin"
      결과: "0.93"
      판정: ""
      단위: "mg/dl"
      참고치: "0.2~1.2"
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "세균배양검사"
      진단일: "2019-03-15"
      보고일: "2019-03-18"
      검사명: "Gram stain"
      결과: "A few WBC"
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "세균배양검사"
      진단일: "2019-03-15"
      보고일: "2019-03-18"
      검사명: "Body fluid culture"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "세균배양검사"
      진단일: ""
      보고일: "2019-03-18"
      검사명: "1차보고"
      결과: "No growth"
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "세균배양검사"
      진단일: ""
      보고일: ""
      검사명: "2차보고"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "세균배양검사"
      진단일: "2019-03-14"
      보고일: "2019-03-16"
      검사명: "Other culture"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "세균배양검사"
      진단일: "2019-03-14"
      보고일: "2019-03-16"
      검사명: "1차보고"
      결과: "No growth"
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "2"
      검사종류: "세균배양검사"
      진단일: ""
      보고일: ""
      검사명: "2차보고"
      결과: ""
      판정: ""
      단위: ""
      참고치: ""
      세부검체: ""
    },
    {
      customer_id: "1"
      검사종류: "조직검사"
      진단일: "2019-03-13"
      보고일: ""
      검사명: "조직병리검사[1장기당]-Level A"
      결과: "병리번호 : S40-000488
<br>채취일 : 2019-03-08 11:30:49 윤유정
<br>대표검체 : Soft tissue[RT]
<br>세부검체 : Rt. elbow infective bursitis
<br>[GROSS DESCRIPTION]
Three pale brown, irregularly shaped, soft fragments, up to 2.3×1.8×0.5 cm, are totally embedded
(Block 1개)

<br>[DIAGNOSIS]
Elbow, right, excision ;
Chronic inflammation with fibrosis."
      판정: ""
      단위: ""
      참고치: ""
      세부검체: "Rt. elbow infective bursitis"
    },
    {
      customer_id: "2"
      검사종류: "조직검사"
      진단일: "2019-03-14"
      보고일: ""
      검사명: "조직병리검사[1장기당]-Level A"
      결과: "병리번호 : S30-000072
<br>채취일 : 2019-03-08 15:20:19 김승찬
<br>대표검체 : Soft tissue[RT]
<br>세부검체 : R/O Foreign body granuloma of skin/R/O Flexor tenosynovitis
 * 현재 진단 진행중(예비결과)입니다."
      판정: ""
      단위: ""
      참고치: ""
      세부검체: "R/O Foreign body granuloma"
    }


  ]
  unless CollectionResults.findOne()
    results.forEach (_obj) ->
      obj = dataSchema 'result', _obj
      CollectionResults.insert obj
