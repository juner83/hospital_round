#unless Meteor.isServer then return
#
#Meteor.users._ensureIndex {createdAt: -1}
#Meteor.users._ensureIndex {'profile.resignedAt': -1}
#Meteor.users._ensureIndex {'profile.isUsing': -1}
#Meteor.users._ensureIndex {'profile.company_ids': -1}
#Meteor.users._ensureIndex {'profile.group_ids': -1}
#Meteor.users._ensureIndex {'profile.authority': -1}
#Meteor.users._ensureIndex {'profile.scNum': -1}
#Meteor.users._ensureIndex {'profile.scName': -1}
#
#CollectionGroups._ensureIndex {createdAt: -1}
#CollectionGroups._ensureIndex {updatedAt: -1}
#
#CollectionRooms._ensureIndex {createdAt: -1}
#CollectionRooms._ensureIndex {updatedAt: -1}
#CollectionRooms._ensureIndex {startedAt: -1}
#CollectionRooms._ensureIndex {endedAt: -1}
#CollectionRooms._ensureIndex {pausedAt: -1}
#CollectionRooms._ensureIndex {resumedAt: -1}
#CollectionRooms._ensureIndex {status: -1}
#CollectionRooms._ensureIndex {'statusDetail': -1}
#CollectionRooms._ensureIndex {'incomingType': -1}
#CollectionRooms._ensureIndex {'cstInfo.cst_id': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstChar': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstGrade': -1}
#CollectionRooms._ensureIndex {'userInfo._id': -1}
#CollectionRooms._ensureIndex {'userInfo.profile.group_ids': -1}
#CollectionRooms._ensureIndex {'userInfo.profile.scNum': -1}
#CollectionRooms._ensureIndex {'userInfo.profile.scName': -1}
#CollectionRooms._ensureIndex {isProcessed: -1}
#CollectionRooms._ensureIndex {completedAs: -1}
#CollectionRooms._ensureIndex {incomingChannel: -1}
#CollectionRooms._ensureIndex {chattingFor: -1}
#CollectionRooms._ensureIndex {waitingFor: -1}
#CollectionRooms._ensureIndex {'summary.cate1._id': -1}
#CollectionRooms._ensureIndex {'summary.cate2._id': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstNum': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstName': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstCell': -1}
#CollectionRooms._ensureIndex {'cstInfo.cstNick': -1}
#
#CollectionMessagesReserved._ensureIndex {createdAt: -1}
#CollectionMessagesReserved._ensureIndex {updatedAt: -1}
#CollectionMessagesReserved._ensureIndex {room_id: -1}
#CollectionMessagesReserved._ensureIndex {'cstInfo.cst_id': -1}
#
#CollectionMessages._ensureIndex {createdAt: -1}
#CollectionMessages._ensureIndex {updatedAt: -1}
#CollectionMessages._ensureIndex {room_id: -1}
#CollectionMessages._ensureIndex {sender: -1}
#CollectionMessages._ensureIndex {isRead: -1}
#
##CollectionTmp._ensureIndex {createdAt: -1}
##CollectionTmp._ensureIndex {updatedAt: -1}
##CollectionTmp._ensureIndex {room_id: -1}
##CollectionTmp._ensureIndex {sender: -1}
##CollectionTmp._ensureIndex {isRead: -1}
#
#CollectionMessagesShared._ensureIndex {createdAt: -1}
#CollectionMessagesShared._ensureIndex {updatedAt: -1}
#
#CollectionLogs._ensureIndex {createdAt: -1}
#CollectionLogs._ensureIndex {updatedAt: -1}
#CollectionLogs._ensureIndex {type: -1}
#CollectionLogs._ensureIndex {'sourceInfo.profile.scNum': -1}
#CollectionLogs._ensureIndex {'userInfo.profile.group_ids': -1}
#CollectionLogs._ensureIndex {'sourceInfo.profile.group_ids': -1}
#
#CollectionStatsSCs._ensureIndex {createdAt: -1}
#CollectionStatsSCs._ensureIndex {updatedAt: -1} #todo 없는 필드
#CollectionStatsSCs._ensureIndex {statsAt: -1}
#CollectionStatsSCs._ensureIndex {'userInfo._id': -1}
#CollectionStatsSCs._ensureIndex {'userInfo.profile.group_ids': -1}
#CollectionStatsSCs._ensureIndex {'userInfo.profile.authority': -1}
#CollectionStatsSCs._ensureIndex {'userInfo.profile.scName': -1}
#CollectionStatsSCs._ensureIndex {총건: -1}
#CollectionStatsSCs._ensureIndex {예약건: -1}
#CollectionStatsSCs._ensureIndex {달성률: -1}
#CollectionStatsSCs._ensureIndex {총상담진행시간: -1}
#CollectionStatsSCs._ensureIndex {평균상담시간: -1}
#CollectionStatsSCs._ensureIndex {총상담불가시간: -1}
#CollectionStatsSCs._ensureIndex {최초로그인시각: -1}
#CollectionStatsSCs._ensureIndex {최종로그아웃시각: -1}
#
#CollectionKmsKeywords._ensureIndex {createdAt: -1}
#CollectionKmsKeywords._ensureIndex {updatedAt: -1}
#
#CollectionBlockKeywords._ensureIndex {createdAt: -1}
#CollectionBlockKeywords._ensureIndex {updatedAt: -1}
#
#CollectionNotices._ensureIndex {createdAt: -1}
#CollectionNotices._ensureIndex {updatedAt: -1}
#
#CollectionHolidays._ensureIndex {createdAt: -1}
#CollectionHolidays._ensureIndex {startedAt: -1}
#
#CollectionCodeGroups._ensureIndex {p_id: -1}
#CollectionCodeGroups._ensureIndex {code: -1}
#
##CollectionContents._ensureIndex {createdAt: -1}
##CollectionContents._ensureIndex {updatedAt: -1}
#
##CollectionSCLogins._ensureIndex {createdAt: -1}
##CollectionSCLogins._ensureIndex {updatedAt: -1}
#
##CollectionStatsRooms._ensureIndex {createdAt: -1}
##CollectionStatsRooms._ensureIndex {updatedAt: -1}