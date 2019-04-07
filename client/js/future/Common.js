function OnSetUI(str) {
  var receivedJsonObj = JSON.parse(str);
  var receivedType = receivedJsonObj.type;
  var pageName = receivedType.split('?')[0];
  var statusName = receivedType.split('?')[1];
  var receivedParameter = receivedJsonObj.parameter;

  if (GetCurrentFileName() == "maincontents")
    document.getElementById("mainFrame").src = pageName + "/Index.htm?" + statusName + "?" + JSON.stringify(receivedParameter);
  else {
    if (pageName != GetCurrentPageName())
      GoPage("../" + pageName + "/Index.htm?" + statusName + "?" + JSON.stringify(receivedParameter));
    else {
      receivedParamStr = JSON.stringify(receivedParameter);
      ChangeStatus(statusName);
    }
  }
}

//---------------------------------------------------------------------------//
//-- 현재 htm파일 이름 받아오기 ------------------------------------------------//
//---------------------------------------------------------------------------//
function GetCurrentFileName() {
  var addressArr = location.href.split('/');
  var fileNameIdx = addressArr.findIndex(ele => ele.indexOf(".htm") != -1);

  return addressArr[fileNameIdx].split('.')[0];
}

function GoPage(pageName) {
  switch (GetCurrentPageName()) {
    case "Setting":
    case "Result":
      //case "Dance":
      location.href = pageName;
      break;
    default:
      location.href = pageName;
//            $("body")
//                .addClass("animsition-link")
//                .attr("href", pageName)
//                .trigger("click.animsition");
      break;
  }
}


function GetCurrentPageName() {
  var addressArr = location.href.split('/');
  var fileNameIdx = addressArr.findIndex(ele => ele.indexOf(".htm") != -1);

  return addressArr[fileNameIdx - 1];


function ChangeStatus(status) {

  // Home Button
  if (document.getElementsByClassName("home").length != 0)
    document.getElementsByClassName("home")[0].setAttribute("onclick", "GoMain()");
  // Back Button
  if (document.getElementsByClassName("back").length != 0)
    document.getElementsByClassName("back")[0].setAttribute("onclick", " BtnClickedEvent('back_btn', '')");

  this.status = status;

  switch (GetCurrentPageName()) {
    case "Setting":
      switch (status) {
        case "init":
          OnScreenKeyboard(false, c_language);
          GetVolume();
          GetFollowNaviConfig();
          document.getElementById("initStatus").getElementsByTagName("span")[0].innerHTML = "IDLE";
          isInitializing = false;
          break;
      }
      break;
    case "Main":
      switch (status) {
        case "start":
          var parameterObj = {
            "curLoc": "0",
            "orgCoord": "0,0,0"
          };
          parameterObj.orgCoord = placeJsonObj["0"].coord;
          BtnClickedEvent("init_btn", JSON.stringify(parameterObj));
          break;
        case "init":
          MakeSetting();
          break;
      }
      break;
//        case "Mirror":
//            switch (status) {
//                case "init":
//                    OnScreenKeyboard(false, c_language);
//                    document.body.setAttribute("onclick", "GoMain()");
//                    CamImageOnOff(true);
//                    break;
//            }
//            break;
//        case "Search":
//            byKeyboard = false;
//            switch (status) {
//                case "init":
//                    VROff();
//                    OnScreenKeyboard(false, c_language);
//                    break;
//                case "on":
//                    VROn();
//                    OnScreenKeyboard(false, c_language);
//                    break;
//                case "keyboard":
//                    byKeyboard = true;
//                    KeyboardOn();
//                    OnScreenKeyboard(true, c_language);
//                    break;
//                case "search":
//                    byKeyboard = true;
//                    SearchByKeyboard();
//                    break;
//                case "pardon":
//                    SearchOnPardon();
//                    break;
//            }
//            break;
//        case "Result":
//            switch (status) {
//                case "init":
//                    CreateResultList();
//                    break;
//            }
//            break;
//        case "Map":
//            switch (status) {
//                case "init":
//                    MapInit();
//                    break;
//                case "disable":
//                    document.getElementById("return").style.display = "";
//                    break;
//            }
//            break;
//        case "Navi":
//            switch (status) {
//                case "org_ready":
//                    OnReady("org");
//                    break;
//                case "org_go":
//                    // 현위치 설정 (0:원위치, -1:이동중, 나머지:위치코드)
//                    currentLocationCode = "-1";
//                    var parameterObj = {
//                        "curLoc": ""
//                    };
//                    parameterObj.curLoc = currentLocationCode;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//                case "org_ongoing":
//                    OnOngoing("org");
//                    break;
//                case "org_pause":
//                    OnPause("org");
//                    break;
//                case "org_obstacle":
//                    OnObstacle("org");
//                    break;
//                case "etc_ready":
//                    OnReady("etc");
//                    break;
//                case "etc_go":
//                    // 현위치 설정 (0:원위치, -1:이동중, 나머지:위치코드)
//                    currentLocationCode = "-1";
//                    var parameterObj = {
//                        "curLoc": ""
//                    };
//                    parameterObj.curLoc = currentLocationCode;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//                case "etc_ongoing":
//                    OnOngoing("etc");
//                    break;
//                case "etc_pause":
//                    OnPause("etc");
//                    break;
//                case "etc_obstacle":
//                    OnObstacle("etc");
//                    break;
//                case "arrive_cache":
//                    // 현위치 설정
//                    currentLocationCode = destinationPlaceCode;
//                    var parameterObj = {
//                        "curLoc": ""
//                    };
//                    parameterObj.curLoc = currentLocationCode;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//                case "arrive":
//                    OnArrive();
//                    break;
//                case "return_ready_cache":
//                    // 목적지 설정
//                    destinationPlaceCode = "0";
//                    destinationPlace = placeJsonObj[destinationPlaceCode].name;
//                    var parameterObj = {
//                        "coord": ""
//                    };
//                    parameterObj.coord = placeJsonObj[destinationPlaceCode].coord;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//                case "return_ready":
//                    OnReady("return");
//                    break;
//                case "return_go":
//                    // 현위치 설정 (0:원위치, -1:이동중, 나머지:위치코드)
//                    currentLocationCode = "-1";
//                    var parameterObj = {
//                        "curLoc": ""
//                    };
//                    parameterObj.curLoc = currentLocationCode;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//                case "return_ongoing":
//                    OnOngoing("return");
//                    break;
//                case "return_pause":
//                    OnPause("return");
//                    break;
//                case "return_obstacle":
//                    OnObstacle("return");
//                    break;
//                case "return_arrive_cache":
//                    // 현위치 설정
//                    currentLocationCode = "0";
//                    var parameterObj = {
//                        "curLoc": ""
//                    };
//                    parameterObj.curLoc = currentLocationCode;
//                    BtnClickedEvent("cache_btn", JSON.stringify(parameterObj));
//                    break;
//            }
//            break;
//        case "Event":
//            switch (status) {
//                case "init":
//                    var imgFolderPath = GetCurrentFolderPath() + "Image";
//                    var fileFormat = "event*.jpg";
//                    GetFileCount(imgFolderPath, fileFormat);
//                    $(".slider:eq(0) ul").stop(true, true);
//                    document.getElementsByClassName("ppt")[0].innerHTML = "";
//                    CreateSlider();
//                    InitSlider();
//                    EventInit();
//                    break;
//            }
//            break;
    case "2_Voice":
      switch(status){
        case "init":
          break;

        case "on":
          break;

        case "reply":
          break;
      }
      break;

    case "4_Round_list":
      switch(status){
        case "init":
          break;
        case "briefing":
          break;

      }
      break;

    case "Photo":
      switch (status) {
        case "enter":
          CamImageOnOff(false);
          OnPhotoEnter();
          break;
        case "init":
        case "aftertts":
          CamImageOnOff(true);
          OnPhotoInit();
          TtsCountOut();
          break;
        case "take":
          CamImageOnOff(true);
          OnPhotoTake();
          break;
        case "beforeComplete":
          OnPhotoTakeAfter();
          break;
        case "complete":
        case "completeMute":
        case "emailFalseTTS":
          OnPhotoComplete();
          break;
        case "emailOn":
          OnphotoEmailOn();
          break;
        case "emailGo":
          OnphotoEmailGo();
          break;
        case "emailTrue":
          EmailTrue();
          break;
        case "emailFalse":
          EmailFalse();
          break;
      }
      break;
  }
}
