#@CollectionAllowPageByAuthority = new Mongo.Collection 'talk_allowPageByAuthority'
#@CollectionGroups  = new Mongo.Collection 'talk_groups'
#@CollectionCompanies = new Mongo.Collection 'talk_company'
#@CollectionCenters = new Mongo.Collection 'talk_center'
#@CollectionRooms  = new Mongo.Collection 'talk_rooms'
#@CollectionMessagesReserved = new Mongo.Collection 'talk_messages_reserved'
#@CollectionMessages  = new Mongo.Collection 'talk_messages'
#oldInsert = CollectionMessages.insert
#CollectionMessages.insert = (obj, callback) ->
#  origin = _.extend {}, obj
#  obj = libServer.contentEncrypt(obj)
#  insert_id = oldInsert.call this, obj, callback
#  origin._id = insert_id
#  try
#    streamer.emit Meteor.userId(), origin
#  catch err then cl err
##  CollectionTmp.upsert _id: origin._id, origin
#  return insert_id
#
##@CollectionTmp = new Mongo.Collection 'talk_tmp'
#@CollectionMessagesShared = new Mongo.Collection 'talk_messages_shared'
##@CollectionContents  = new Mongo.Collection 'talk_contents'
#@CollectionLogs = new Mongo.Collection 'talk_logs'
#@CollectionStatsSCs = new Mongo.Collection 'talk_stats_scs' #상담원 1일통계
##@CollectionSCLogins = new Mongo.Collection 'talk_sc_logins' #상담원 로긴/로그아웃 로그
##@CollectionStatsRooms = new Mongo.Collection 'talk_stats_rooms' #시간/일별 상담방 정보 요약(대쉬보드의 사용 형태로 저장)
#@CollectionSettings = new Mongo.Collection 'talk_settings'
#@CollectionIdioms = new Mongo.Collection 'talk_idioms'  #자주쓰는문구리스트
#@CollectionIdiomsCategories = new Mongo.Collection 'talk_idioms_categories' #자주쓰는 문구 카테고리
#@CollectionGreetings = new Mongo.Collection 'talk_greetings'  #고객안내문구
#@CollectionChatSummaryCategory1 = new Mongo.Collection 'talk_chat_summary_category1' #상담카테고리1
#@CollectionChatSummaryCategory2 = new Mongo.Collection 'talk_chat_summary_category2' #상담카테고리2
#@CollectionKmsKeywords = new Mongo.Collection 'talk_kms_keywords'
#@CollectionBlockKeywords = new Mongo.Collection 'talk_block_keywords'
#@CollectionNotices = new Mongo.Collection 'talk_notices'
#@CollectionHolidays = new Mongo.Collection 'talk_holidays'
##@CollectionCodeGrade = new Mongo.Collection 'talk_code_grade' #고객등급
##@CollectionCodeChar = new Mongo.Collection 'talk_code_char'   #고객특성
##@CollectionCodeBank = new Mongo.Collection 'talk_code_bank' #결제은행
##@CollectionCodeBranch = new Mongo.Collection 'talk_code_branch' #점번호
##@CollectionCodeBin = new Mongo.Collection 'talk_code_bin'     #빈번호 (카드체크 6자리)
#@CollectionCodeGroups = new Mongo.Collection 'COMMON_CODE_GROUPS'
#@CollectionCodeDetail = new Mongo.Collection 'COMMON_CODE_DETAIL'  #grade / char / bank / branch / bin
#CollectionCodeDetail.mFind = (where) ->
#  unless where then where = {}
#  unless options then options = {}
#  if where.pCode? and CollectionCodeGroups.findOne()
#    group = CollectionCodeGroups.findOne(code: where.pCode)
#    delete where.pCode
#    where.p_id = group._id
#  return CollectionCodeDetail.find where
#CollectionCodeDetail.mFindOne = (where) ->
#  unless where then where = {}
#  unless options then options = {}
#  if where.pCode? and CollectionCodeGroups.findOne()
#    group = CollectionCodeGroups.findOne(code: where.pCode)
#    delete where.pCode
#    where.p_id = group._id
#  return CollectionCodeDetail.findOne where

########chatbot
@CollectionChatRoom = new Mongo.Collection 'CHAT_ROOM'
@CollectionInoutDatas = new Mongo.Collection 'CHAT_INOUT_DATA'
#########

#cl CollectionCodeDetail.mFindOne()
#@CollectionCodeSCStatus = new Mongo.Collection 'talk_code_sc_status'  #상담원 현재 상태
@CollectionCustomers  = new Mongo.Collection 'talk_customers' #test 가상 고객

#CollectionCodeBank.before.insert (userId, doc) ->
#  doc


#Meteor.users.allow
#  update: (userId, doc, fields, modifier) ->
#    if Meteor.user()?.profile?.회원등급 is '관리자' or Meteor.user()._id is userId then true
#    else false
#
#CollectionSettings.allow
#  update: (userId, doc, fields, modifier) ->
#    if Meteor.user()?.profile?.회원등급 is '관리자' then true
#    else false
#
#CollectionPayments.allow
#  insert: (userId, doc, fields, modifier) ->
#    if Meteor.user()?.profile?.회원등급 is '관리자' then true
#
#CollectionEnrollments.allow
#  insert: (userId, doc, fields, modifier) ->
#    if Meteor.user()?.profile?.회원등급 is '관리자' then true
