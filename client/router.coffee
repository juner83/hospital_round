FlowRouter.notFound =
  action: -> FlowRouter.go '/'

FlowRouter.triggers.enter [->
  ### 경로 진입시 window.isAddEventBeforUnload 의 boolean 값 확인
  boolean 값이 false 일 경우 이벤트 추가###
#  if !window.isAddEventBeforUnload
#    window.isAddEventBeforUnload = true
#    ###현재 창 종료 또는 새로고침 시
#    현재 창에서 띄운 모든 팝업창 종료 이벤트 로직###
#    window.addEventListener 'beforeunload', ->
#      obj = window.popupWindow
#      for idx of obj
#        if obj[idx] and obj[idx].close then obj[idx].close()
#      if !FlowRouter.current().context.isWindowPopup # 윈도우 창이 아닐 경우
#        return '' # IE 사용자의 경우 닫기전 확인 메세지 출력 (리턴값이 없을경우 확인메세지 없음)
#
#  checkPathRv.set false
  path = FlowRouter.current().route.path
#  Meteor.call 'routerPathCheck', path, (err,rslt)->
#    if err || (!rslt && path != '/') then FlowRouter.go '/'
#    else if rslt
#      if rslt.path != path and rslt.auth != 'master' # 현재 경로와 결과 경로가 같지 않고 마스터가 아닐경우
#        alert '접근권한이 없습니다.'
#        FlowRouter.go rslt.path
#        checkPathRv.set true
#        return
#      checkPathRv.set true
#      Meteor.call 'getShouldChangePassword', (err,rslt2)->
#        if err then return alert err.reason
#        else if rslt2 # 90일 초과로 비밀번호 변경이 필요할 경우
#          FlowRouter.go '/myPage'
#          return swal text: '마지막으로 비밀번호를 변경한지 90일을 초과하였습니다.\n 비밀번호 변경 후 재로그인 해주세요.', icon: "warning"
#        else if rslt.isTempPw # 임시비밀번호로 비밀번호 변경이 필요한 경우
#          FlowRouter.go '/myPage'
#          return swal text: "비밀번호 변경 후 재로그인 해주세요.", icon: "warning"
#        else if path == '/' # 로그인 이후 페이지 이동 없이 '/' 경로에 있을 경우 강제 이동
#          if rslt.auth == 'master' then return FlowRouter.go '/dashboard'
#          else if path != rslt.path then return FlowRouter.go rslt.path
#        return
]