Meteor.startup ->
  return
#  unless Meteor.users.findOne(username: 'admin')
#    cl 'initServer/make admin'
#    options = {}
#    options.username = 'admin'
#    options.password = 'admin123@'
#    options.profile = dataSchema 'profile',
#      authority: 'master'
#      scName: 'master'
#    Accounts.createUser options


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
