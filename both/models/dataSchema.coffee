#if Meteor.isServer
#  _ = Npm.require "underscore"
@dataSchema = (_objName, _addData) ->
  rslt = {}
  # add 될 데이터가 있다면 return 시에 extend 해서 반환한다.
  addData = _addData or {}
  createdAt = new Date()
  switch _objName
    when 'allowPageByAuthority'
      rslt =
        createdAt: new Date()
        authority: null #sc / admin / company / center / master(마스터는 all)
        title: null   #page title 한글명
        address: null   #page router
    when 'system'
      rslt =
        createdAt: new Date()
        username: 'system'
        profile:
          authority: 'system'
    when 'gateway'
      rslt =
        createdAt: createdAt
        username: 'gateway'
        profile:
          authority: 'gateway'
    when 'codeGroup'
      rslt =
        type: 'common'  # '',   common / talk / bot
        code: null #'', grade / bin / (변경 불가)
        title: null #'', 고객등급 (셀렉트 박스에 보여줄 목록)
        createdAt: createdAt
        createdBy:
          userNo: null
          userName: null
        updatedAt: createdAt
        updatedBy:
          userNo: null
          userName: null
    when 'codeDetail'
      rslt =
        p_id: null  #'',
#        pCode: null   #mFind로 codeGroup의 code를 검색 해올 수 있다.
        code: null  #'', V1
        title: null #'', 오렌지등급
        createdAt: createdAt
        createdBy:
          userNo: null
          userName: null
        updatedAt: createdAt
        updatedBy:
          userNo: null
          userName: null
    when 'code'
      rslt =
        auth: null  # common / bot / talk
        type: null    # '',   #grade / char / bank / branch / bin
        createdAt: createdAt
        createdBy:
          userNo: null
          userName: null
        updatedAt: createdAt
        updatedBy:
          userNo: null
          userName: null
        code: null    #automic 해야 할듯
        title: null
    when 'holiday'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        startedAt: null # Date 객체 사용
#        endedAt: null # 현재는 사용하지 않지만 언제부터~언제까지 를 고려
        title: null
        업무시각: # 하위 객체가 있을 경우 개별 근무시간 적용 / null일 경우 휴일
          시작시: 9
          시작분: 0
          종료시: 18
          종료분: 0
#        etc: null #비고
    when 'statsRoom'
      rslt =
#        group_id: null  #string  pub/sub 방식 때 필요
        createdAt: createdAt
        updatedAt: createdAt
        전광판:  #고객종료유형: 상담원종료 / 고객종료 / 고객무응답종료 / 상담원무응답종료 / 대기중종료 / 이관종료
          총상담: null
          총챗봇: null
          현재대기: null
          상담진행: null
          챗봇진행: null
          상담완료: null
          상담포기: null
          상담예약: null
        테이블:
          기준일: [] #title / 총인입 / 응답률 / 포기율
          당월평균: [] #퍼포먼스 확인 후 필요하면 별도 Method
          기준일합: {총인입: 0, 응답건: 0, 포기건: 0, 응답률: 0, 포기율: 0}  #테이블하단 총합계산
          당월평균합: {총인입: 0, 응답건: 0, 포기건: 0, 응답률: 0, 포기율: 0} #테이블하단 총합계산
        선형:
          채널: [   #data key 빠짐. 왜 필요?
#            title: null  #'01': '홈페이지'
#            value: []   #[시간별 24개 Number수치]
          ]
        파이:
          채널:
            title: []     #['WEB','APP']
            value: []     #[1,2]
          상담유형:
            title: []
            value: []
          완료구분:
            title: []
            value: []
    when 'statsSC'    #상담원 실적 조회
      rslt =
        createdAt: createdAt
#        updatedAt: createdAt
        statsAt: null     #1일 1건 00:00:00 mUtils.getStartEndOfDate().startAt값
        총건: 0   #기간내 총건
        예약건: 0  #기간내 예약처리건
        달성률: 0   #1일간 (총건 / 목표치) * 100
        총상담진행시간: 0 #mil, room내 chattingFor 합산
        총상담불가시간: 0 #mil, 비상담중 상태 변환 시간 합산? or 일시정지 합산 (후자로 밀자)
        평균상담시간: 0 #mil, 총상담진행시간 / 총건
        최초로그인시각: null   #date, Detail에만 있음
        최종로그아웃시각: null  #Detail에만 있음
        userInfo: {}    #{}, sc info copy
    when 'notice'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        title: null
        content: null
        isImportant: false
        notRead_ids: [] #공지사항 생성 시점에 읽어야 하는 소속 상담원들의 _id들. 이후 시점에 생성/소속 된 상담원은 모두 읽은 상태로 시작 되는 결과. (상담원이 무한히 늘지 않는 구조하에 가능)
        userInfo: null    #{}
    when 'blockKeyword'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        title: null
        userInfo: null    #{}
    when 'kmsKeyword'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        search_id: null
        title: null
        content: null
        userInfo: null    #{}
    when 'chat_summary_category1'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        title: null
        userInfo: null    #{}
    when 'chat_summary_category2'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        p_id: null  #talk_chat_summary_category1_id
        title: null
        content: null
        userInfo: null    #{}
    when 'greeting'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        title: null
        content: null #${상담원명}: Client에서 인서트 할 때 scName을 Replace 할 것  / ${대기시간}: 대기중일때 대기 시간(분) 으로 Replace (대기시간 연산은 아직 미구현)
        userInfo: null    #{}, 등록자: admin or master
        isUsing: true
    when 'idiom'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        p_id: null  #category _id
        title: null
        content: null
        userInfo: null  #{}, 필요시 사용
        updaterInfo: null
        isUsing: true #사용유무(필요시 사용)
    when 'idiomCategory'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        title: null
        userInfo: null  #{}, 등록 관리자 정보 (필요 시 사용)
        isUsing: true #사용유무(필요시 사용)
        order: 0    #순서 필요시
    when 'settings'
      rslt =
        _id: 'settings'
        createdAt: createdAt
        canCstJoin: true
        #상담 카테고리 콜렉션 분리
#        categories:
#          cate1: [] #{_id: null, title: null}
#          cate2: []
        kmsUrl: null  #기본 KMS 접속 URL
        기본근무환경:
          주간근무요일:
            [false, true, true, true, true, true, false] # 일, 월, ... 금, 토
          업무시각:
            시작시: 9
            시작분: 0
            종료시: 18
            종료분: 0
        상담목표건수: 100   #기본 값. 상담원 생성 시 copy
        상담원무응답종료시간: 10*60*1000  #mil
        고객무응답종료시간: 9*60*1000   #mil
        예약고객무응답종료시간: 8*60*1000 #mil
        상담지연시간: 7*60*1000       #mil
        예약상담안내노출시간: 6*60*1000   #mil
        동시상담가능건수: 20  #기본 값. 상담원 생성 시 copy
        비밀번호잠김횟수: 5   #회
        자동로그아웃시간: 10 * 60 * 1000 # 기본값 10분
        이전상담원연결: true   #사용/미사용
        우선상담등급: []    #코드성
        상담지연메시지: '상담원 연결이 지연되고 있습니다. 잠시만 기다려주세요.'
        상담종료메시지: '상담이 종료되었습니다. 감사합니다.'
        상담원무응답종료메시지: '상담에 문제가 있어 종료되었습니다.'
        고객무응답종료메시지: '고객님께서 장시간 무응답으로 상담이 종료 되었습니다.'
        차단키워드경고메시지: '금칙어가 포함되어 있습니다.'
        상담일시정지메시지: '상담이 일시 정지 되었습니다. 잠시만 기다려주세요.'
        이관대기중메시지: '상담을 ${상담원명} 상담원으로 변경 중 입니다. 잠시만 기다려주세요.' # ${상담원명} 지원
        직전상담원안내메시지: '이전에 상담했던 상담원으로 연결 하시겠습니까?'
        상담시간외안내메시지: '톡상담은 평일 ${영업시작시각} ~ ${영업종료시각}에 가능합니다.'
        대기열인입불가메시지: '진행 중인 상담건이 많아 상담이 제한되었습니다. 잠시 후에 다시 시도 해 주세요.'
        상담원연결메시지: '안녕하세요, ${상담원명} 상담원입니다. 무엇을 도와드릴까요?'
        상담일시정지메시지: '일시정지 안내'
        예약상담신청메시지: '예약상담 안내'
        예약상담신청완료메시지: '예약상담 신청 완료 안내'
        QnA신청메시지: 'QnA신청메시지'
        QnA신청완료메시지: 'QnA신청완료메시지'
        QnA답변완료안내: 'QnA답변완료안내'
        #시스템사용 (향후 어드민 제어 여부에 따라 적용 위함)
        대기예상단위시간: 180000  #num, sec  #대기 고객 예상 시간 산출을 위한 상담원별 상담 단위 시간
        mainServer: null  #{}, createdAt / _id
        기본접근페이지: [{title:'메인',address:'/'},{title:'마이페이지',address:'/myPage'},{title:'공지사항(상세팝업)',address:'/notice'}]
        등록된페이지: [
          #채팅상담
          {title:'채팅상담',address:'/chat', idx:0}
          #대시보드
          {title:'대시보드',address:'/dashboard', idx:100}
          #상담조회
          {title:'예약상담조회',address:'/futuerChatList', idx:200}
          {title:'과거상담조회',address:'/oldChatList', idx:201}
          {title:'과거상담조회(상세팝업)',address:'/oldChatPopup/:room_id/:cst_id', idx:202}
          {title:'실시간상담조회',address:'/liveChatList', idx:203}
          {title:'실시간상담조회(상세팝업)',address:'/liveChatPopup/:room_id/:cst_id', idx:204}
          #상담현황
          {title:'상담원현황',address:'/liveScList', idx:300}
          {title:'대기현황',address:'/waitingRoomList', idx:301}
          #컨텐츠관리
          {title:'자주쓰는문구',address:'/idiom', idx:400}
          {title:'고객안내문구',address:'/greeting', idx:401}
          {title:'상담유형',address:'/chatSummaryCategory', idx:402}
          {title:'KMS관리',address:'/kmsKeyword', idx:403}
          {title:'차단키워드',address:'/blockKeyword', idx:404}
          {title:'공지사항',address:'/noticeList', idx:405}
          #실적관리
          {title:'상담원실적',address:'/scResult', idx:500}
          {title:'상담원실적(상세팝업)',address:'/scResultOnce/:startedAt/:endedAt/:id', idx:501}
          {title:'기간별실적',address:'/timeResult', idx:502}
          #조직관리
          {title:'사용자관리',address:'/userManage', idx:600}
          {title:'사용자생성(상세팝업)',address:'/userCreatePopup', idx:601}
          {title:'사용자수정(상세팝업)',address:'/userEditPopup/:id', idx:602}
#          {title:'팀관리',address:'/groupManage', idx:603}
          {title:'조직관리',address:'/groups', idx:603}
          {title:'영업일',address:'/schedule', idx:604}
          #로그조회
          {title:'로그조회',address:'/logHistory', idx:700}
          #시스템관리
          {title:'일반설정',address:'/systemTime', idx:801}
          {title:'메세지설정',address:'/systemText', idx:802}
          {title:'코드설정',address:'/systemCode', idx:803}
          {title:'접근권한설정',address:'/systemAuth', idx:804}
        ]

    ## 삭제 예정 (StatsSC) ##
    when 'SCStats'  #실시간 상담원 현황 조회
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        userInfo: null    #{}
        stats:
          totalCnt: 0
          proceedCnt: 0
          markRate: 0 #백분율
          totalTime: 0  #mil
          aveChatTime: 0    #평균채팅 시간 mil
          aveNotChatTime: 0 #채팅불가 시간 mil
        firstLogin: null  #date
        lastLogout: null  #date

    when 'scLogins'
      rslt =
        createdAt: createdAt
        sc_id: null   #''
        action: null  #bool, true: login / false: logout

    when 'profile'
      rslt =
#        createdAt: createdAt  #상위로 넘기기
#        updatedAt: createdAt  #상위로 넘기기
        authority: null #master(시스템마스터)/center(센터장)/company(매니저)/admin(팀장)/sc(상담원)
        center_ids: []  #소속센터 _id, 복수개 가능
        company_ids: []  #소속회사 _id, 복수개 가능
        group_ids: []  #소속팀 _id, sc만 하나씩 가질수 있고 admin 은 복수개 가능
#        master_group_name: null #master 그룹명, 마스터만 보유하는 필드 ( 팀관리오 상관없는 텍스트 팀 명) #todo 이 필드 미사용 확인필요
        scName: null   #이름
        scNum: null    #사번
        scGrade: []   #V1 / V2 / V3 ... 코드성_id? customer.type 동일
        scChar: []    #B1 / B2 / B3 ... 코드성_id? customer.char 동일
        scStatus: '상담중'   #상담중/식사/교육/휴식/사내/기타 mDefine
        scStatusChangedAt: null #scStatus 없데이트된 시간(지속시간 산정시 필요)
#        adminGroups: []   #관리자일경우 내가 관리하는 그룹_id, default = all, 1차에선 제외
        loginFailedCount: 0 #로그인 실패횟수, 로그인성공시 0으로 초기화
        isTempPw: false      #최초생성 or 비밀번호 초기화시 true, false시 다른메뉴 접근제한(내정보관리 redirection)
        pastPws: []   #지난 비번 4개
        isUsing: true        #사용여부(권한), false시 로그인제한. 현재 사용은 안함?
        lastLoginAt: null   #log를 뒤져서 쓰는게 낫지 않나. 일배치 파일에도 남겨야 함
        lastLogoutAt: null  #log를 뒤져서 쓰는게 낫지 않나. 일배치 파일에도 남겨야 함
        lastPwUpdatedAt: null  #로그인 시 1회 변경이므로 항상 있는 값
#        lastPwUpdatedAt: lastPwUpdatedAt # 마지막으로 비밀번호를 수정한 일시
        resignedAt: null #퇴사날짜  null: 재직 / Date: 퇴사
        상담목표건수: 0
        동시상담가능건수: 0
        branchCode: null #branchCode Collection 참조로 화면에 표시. 사용자 생성 시 입력 해 줘야하고 상담원 조회 시 보여 줘야 함.. #string or number 정해진 대로 들어갈 예정.
#        statistics:
#          meal: 0 #식사, 상태변경시마다 초단위 합산
#          rest: 0 #휴식, 상태변경시마다 초단위 합산
#          edu: 0  #교육미팅, 상태변경시마다 초단위 합산
#          call: 0 #콜상담, 상태변경시마다 초단위 합산
#          etc: 0  #기타, 상태변경시마다 초단위 합산
#          logout: 0 #로그아웃, 상태변경시마다 초단위 합산
#          chat_count: 0 #채팅건수, 상담완료/고객미응답포함
#          chat_total_time: 0 #전체채팅시간, 대기중/채팅중/업무처리 시간합계
    when 'group'  # admin(team) / company / center
      rslt =
        p_id: null # center / company / team 관계에서 상위를 표현. 없으면 없는것으로 간주.
        createdAt: createdAt
        updatedAt: createdAt
        title: null  #팀명
#        code: null        #팀코드 000 부터 시작
#        leader_id: null   #책임관리자_id
        isUsing: true    #사용중
        userInfo: null    #{}, 최초 만든 사람.
        updaterInfo: null   #{}, 수정한 사람.
    when 'customer'
      rslt =
#        createdAt: createdAt
#        updatedAt: createdAt
        cst_id: null      #'',
        id_type: null     #'', cstNum / nickCell
        cstNum: null        #고객번호. pk
#        cstDiv: null        #회원구분: 일반회원, 점유인증, 비회원 ...
        cstName: null       #고객명
        cstNick: null     #고객 닉네임
        cstCell: null     #고객 전화번호
#        cstType: '일반'    #필요할 때 필드를 생각해보자.
        cstGrade: []      #고객등급: V1/V2/V3...
        cstChar: []       #고객하트고객: B1/B2/B3...
        cstCharDetail: []   #고객문제행동 내역 상세 (사용??)
        isChattingNow: false  #채팅상담중일때 true, 아니면 false
        #저장 시 버릴데이터
        tmp:
          이메일: null
          주민등록번호: null
          웹회원아이디: null
          결제단위_신용: null
          결제단위_체크: null
          대표카드번호: null
          회원사회원번호: null
          소지자구분: null
    when 'room'
      rslt =
        createdAt: createdAt   #대기실 진입시각 (상담일)
        updatedAt: createdAt   #상담 종료 이후에는 updatedAt이 상담 종료 시각을 나타내게 됨. 라이프 사이클 종료시점.
        lastCstAt: null   #마지막 message가 들어온 시각을 기억
        lastScAt: null    #마지막 message가 들어온 시각을 기억
        p_id: null    #이관 시 상위 room_id
        summary:
          cate1: null #{}, settings summary_cate1 객체. 코드성 변경 가능때문에 전체 객체 저장
          cate2: null #{}, settings summary_cate2 객체.
          requestedChar: null #{}, 완료 시 선택 된 CollectionCodeDetail.mFind(pCode: mDefine.CODES.CHAR) code는 바뀔 수 있는 코드성 이기 때문에 객체 전체를 저장
#          code: null
#          title: null
          note: null
        startedAt: null   #상담시작시각
        endedAt: null     #종료시각
        pausedAt: null    #상담일시정지 시각.
        pausedFor: 0      #상담일시정지 시간 mil. 상담 재시작 시 + 되며 무응답 종료판단 시 해당 값을 더해서 연산
        resumedAt: null
        waitingFor: 0       #대기시간: startedAt - createdAt mil
        chattingFor: 0      #상담시간: endedAt - startedAt mil
        estWaitingFor: 0    #대기예상 시간: mil. 대기중일때 update 된다. 고객 채팅화면에서 ${대기시간} 스트링을 이 값으로 replace 해서 reactive 걸어주면 된다. ex> 고객님의 예상 대기 시간은 ${대기시간}분입니다.
        cstInfo: null            #{}, 고객정보: 상담시점의 정보 간직
        userInfo: null             #{}, 상담원정보: 상담시점의 정보 간직
#        pastUserInfos: []       #이관 된 상담원들의 info->이관종료로 변경
        incomingType: '일반'    #상담구분: ARS / 예약 / QnA / 일반 (눈에 보이는 필드)
        incomingInfo: null      #상담구분에 따른 부가 정보(ARS:경로/ )
        incomingChannel: null   #채널["01 : 홈페이지, 02 : 모바일웹, 031 : Android 앱, 032 : IOS 앱"]  #mDefine
        status: '대기'         #방상태: ['대기' / '상담중' / '후처리' / '상담완료']
        statusDetail: null  #방상태세부 - null / 대기: ['이관', '직전상담']    (statusDetail 만 보고도 유입 상태를 알 수 있어야 하기 때문에 일반예약과 같이 구분되는 이름으로 변경하였음)
#        sc_id: null       #상담원 지정 된 경우 _id (예약 / 이관 / 직전 상담 등 상담원이 지정 된 모든 경우. 대기+일반 일 경우 sc_id가 셋팅 되어 있으면 강제 할당으로 해당 상담원 연결 처리.
        completedAs: null     #고객종료유형: 상담원종료 / 고객종료 / 고객무응답종료 / 상담원무응답종료 / 대기중종료 / 이관종료
        isProcessed: false  #stats 처리가 됐는지 여부
        cid: ''   #QnA에서 cid 넣음
        arsPayload: ''  #incomingType 이 ARS인경우 진행단계 저장 필드
        scenarioStatus: false #시나리오중일때 true, 아닐때 false
    when 'reservedMessage'
      rslt =            # 동일 고객 여러건일 경우 마지막 건의 정보를 계승한다. room_id가 없는 모든 건이 미처리 건이고, 처리 시 해당 건들에 room_id를 셋한다.
        createdAt: createdAt
        updatedAt: createdAt
        incomingType: null    # '예약' / 'QnA'
        incomingChannel: null #채널["01 : 홈페이지, 02 : 모바일웹, 031 : Android 앱, 032 : IOS 앱"]  #mDefine
        cstInfo: null   # {}
        title: null     # 제목이 필요?
        content: null   # 내용
        room_id: null   # 대기룸 생길 때 셋팅. 완료 flag
    when 'message'
      rslt=
        type: 'msg'        #'', MessageShared를 위함 msg / api(end, keypress, ....)
        typeDetail: null    # senarioStart   /  (msg: user/bot)
        createdAt: createdAt
        msgTagType: null # 예약 또는 QnA 에 등록된 고객의 문의 내용메세지에만 값이 붙는 플레그 (value: "예약" or "QnA")
        room_id: null     #room _id
        sender: null     #송신인: sc / cst / sys
        content: null     #내용
        htmlContent: null  #html 변환 content
        imageLink: null   #이미지업로드한 경우 링크
        isRead: false   #안읽힌경우 뱃지생성 및 마지막생성된 안읽힌 메시지는 리스트에 노출. pub 될때 (userNum) -> 을 넘겨서 false에 대해서 sender 가 아닌 측이 받아갈 경우 true로 변경
    when 'content'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        authorDiv: null
        authorId: null
        alias: null
        content: null
        code: null  #관리자는 A_001 ~, 상담원은 사번_001부터, 자동 생성
        isUsing: true  #사용유무

    when 'log'
      rslt =
        createdAt: createdAt
        sourceInfo: null   #{}, 수행자정보 (gateway는 createdAt/username: 'gateway'만 존재. dataSchema 'gateway')
        targetInfo: null  #{}, 수행대상자정보
        actionInfo: null  #{}, 최종 상태에 대한 데이터를 포함 시켜서 향후 활용 시 사용. 보통 before / after. 상황에 따라 변경 가능.
        rslt: true #true / false
        type: null  #로그인/로그인실패/로그아웃/계정잠김/계정생성/계정정보수정/계정삭제/팀생성/팀수정/팀삭제/상담원팀이동/팀장지정/비밀번호초기화/비밀번호변경/대기열인입수정
        desc: null  #비고

    when 'connection'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        connectionInfo: null    #{}
    else
      throw new Error '### Data Schema Not found'

  return _.extend rslt, addData
