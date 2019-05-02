var param           = {};
var tempRes;
var tempCode        = {};
tempCode.hospital   = '015';        // 기관코드
tempCode.dutplcecd  = '2050000000'; // 근무지부서코드
tempCode.fromdd     = '20180101';   // 유효시작일자


Meteor.methods({
  dataBatch: () => {
    cl('methods/dataBatch');
    
    try {
      // 1. 의사ID 획득(하드코딩)
      var doctorIds = [95610268];

      // 1-1. 의사정보 획득
      doctorIds.forEach(function(row, idx) {
        param = {
          'hospital_id' : tempCode.hospital
            , 'submit_id'	: 'DRZUM00499'
            , 'business_id' : 'sz'
            , 'dutplceinstcd'		: '015'
            , 'userid'		: row
            , 'dutplcecd'	: tempCode.dutplcecd
            , 'fromdd'		: tempCode.fromdd
        };
        
        tempRes = dataModel.doctor(commonAjaxGet(param));

        // 2. 의사별 환자리스트 획득(환자정보저장) - 환자별 경과 기록지
        param = {
          'hospital_id' : tempCode.hospital
            , 'submit_id'	: 'DRARC20000'
            , 'business_id' : 'mr'
            , 'instcd'		: '015'
            , 'userid'		: row
            , 'dutplcecd'	: tempCode.dutplcecd
            , 'orddd'			: dateFormat()
        };

        tempRes = dataModel.patient(commonAjaxGet(param));
      });
    } catch (e) {
      throw new Meteor.Error(e.message)
    }

    try {
      // 4. 나의스케쥴 리스트 획득 / 저장 - TODO 실시간
    } catch (e) {
      throw new Meteor.Error(e.message)
    }

    return 'data batch complete'
  }
});

function dateFormat() {
  var date = new Date();

  var year = date.getFullYear();                                 //yyyy
	var month = (1 + date.getMonth());                     //M
	month = month >= 10 ? month : '0' + month;     // month 두자리로 저장
	var day = date.getDate();                                        //d
	day = day >= 10 ? day : '0' + day;                            //day 두자리로 저장
	return  year + '' + month + '' + day;
}

function commonAjaxGet(param, cbFunc) {
  return commonAjax('Get', param, cbFunc);
}

function commonAjaxPost(param, cbFunc) {
  return commonAjax('Post', param, cbFunc);
}

function commonAjax(method, param) {
  var e, result;
  try {
    result = HTTP.call('POST', 'http://121.135.148.170:29000/' + 'bridge' + method, {
      data: param
    });
  } catch (_error) {
    e = _error;
    throw new Meteor.Error('Data API. #Bridge');
  }

  return result;
}

var dataModel = {
  doctor : function(data) { // 환자리스트 데이터 리모델링
    var tempData = {};
    try {
      tempData = JSON.parse(data.content);
      tempData = tempData.root;
    } catch(e) {
      tempData = data.content.root;
    };

    return {'doctor' : tempData.ret.users};
  }
  , patient : function(data) { // 환자리스트 데이터 리모델링
    var tempData = {};
    try {   
      tempData = JSON.parse(data.content);
      tempData = tempData.root.tmp;
    } catch(e) {
      tempData = data.content.root.tmp;
    };

    var reData = [];

    if (tempData.patlist) {
      if (Array.isArray(tempData.patlist)) {
        tempData.patlist.forEach(function(row, idx) {
          reData.push(dataFormat.patient(row));
        });
      } else {
        reData.push(
          dataFormat.patient(tempData.patlist)
        );
      }
    }

    // 3. 환자별 경과 기록지
    reData.forEach(function(row, idx) {
      param = {
				'hospital_id'	: tempCode.hospital
				, 'submit_id'	: 'DRARC20001'
				, 'business_id'	: 'mr'
				, 'instcd' 		: '015'
				, 'pid'	: row.pid // 2009382,2010568
      };
      
      var tempResult = dataModel.result(commonAjaxGet(param));
      
      // TODO - customer 추가정보 입력
      row.result = tempResult.result;
      row.voiceEMR = tempResult.voiceEMR;
    });

    reData = {'customer' : reData};

    return reData;
  }
  , schedule : function(data) { // 스케줄 데이터 리모델링
    var tempData = {};
    try {   
      tempData = JSON.parse(data.content);
      tempData = tempData.root.tmp;
    } catch(e) {
      tempData = data.content.root.tmp;
    };

    var reData = [];
    
    if (tempData.list) {
      if (Array.isArray(tempData.list)) {
        tempData.list.forEach(function(row, idx) {
          reData.push(dataFormat.schedule(row));
        });
      } else {
        reData.push(
          dataFormat.schedule(tempData.list)
        );
      }
    }

    console.log('Schedule : ', {'schedule' : reData});
    return {'schedule' : reData};
  }
  , result : function(data) { // 검진결과 데이터 리모델링
    var tempData = {};

    try {
      tempData = JSON.parse(data.content);
      tempData = tempData.root.tmp;
    } catch(e) {
      tempData = data.content.root.tmp;
    };
    
    var reData = {
      customer : {}
      , result : []
      , voiceEMR : []
    };

    if (tempData.patinfo) {
      reData.customer = dataFormat.patient(tempData.patinfo);
    }
  
    if (tempData.reclist) {
      if (Array.isArray(tempData.reclist)) {
        tempData.reclist.forEach(function(row, idx) {
          reData.voiceEMR.push(
            dataFormat.retVoiceEMR(row, tempData.prcplist)
          );
        });
      } else {
        reData.voiceEMR.push(
          dataFormat.retVoiceEMR(tempData.reclist, tempData.prcplist)
        );
      }
    }
    
    if (tempData.btlist) {
      if (Array.isArray(tempData.btlist)) {
        tempData.btlist.forEach(function(row, idx) {
          reData.result.push(dataFormat.retResult('혈액검사', row));
        });
      } else {
        reData.result.push(
          dataFormat.retResult('혈액검사', tempData.btlist)
        );
      }
    }

    if (tempData.bctlist) {
      if (Array.isArray(tempData.bctlist)) {
        tempData.bctlist.forEach(function(row, idx) {
          reData.result.push(dataFormat.retResult('세균배양검사', row));
        });
      } else {
        reData.result.push(
          dataFormat.retResult('세균배양검사', tempData.bctlist)
        );
      }
    }

    if (tempData.biopsylist) {
      if (Array.isArray(tempData.biopsylist)) {
        tempData.biopsylist.forEach(function(row, idx) {
          reData.result.push(dataFormat.retResult('조직검사', row));
        });
      } else {
        reData.result.push(
          dataFormat.retResult('조직검사', tempData.biopsylist)
        );
      }
    }
    
    return reData;
  }
};

var dataFormat = {
  patient : function (data) {
    var tempData = {};
    tempData.doctor_id	= 'TODO_doctor_id';
    tempData.pid	= data.pid ? data.pid : '';
    tempData.병실		= data.roomcd ? data.roomcd : '';
    tempData.침대번호	= 'TODO_침대번호';
    tempData.이름		= data.hngnm ? data.hngnm : '';
    tempData.등록번호	= data.pid ? data.pid : '';
    tempData.진단명		= data.diagnm ? data.diagnm : '';
    tempData.수술명		= data.opnm ? data.opnm : '';
    tempData.HOD		= data.hd ? data.hd : '';
    tempData.POD		= data.pod ? data.pod : '';
    
    return tempData;
  }
  , schedule : function (data) {
    var tempData = {};
    tempData.customer_id	= 'TODO_customer_id';
    tempData.병원기관기호	= data.hospitalCd ? data.hospitalCd : '';
    tempData.진료과코드		= data.departmentCd ? data.departmentCd : '';
    tempData.진료과명		= data.departmentNm ? data.departmentNm : '';
    tempData.doctor_id		= data.doctorId ? 'TODO_' + data.doctorId : '';
    tempData.의사명			= data.doctorNm ? data.doctorNm : '';
    tempData.진료일자		= data.visitDt ? data.visitDt : '';
    tempData.진료시간		= data.visitTm ? data.visitTm : '';
    tempData.일정종류		= data.visitKind ? data.visitKind : '';
    tempData.상태메시지		= data.statusNm ? data.statusNm : '';
    tempData.가셔야할곳		= data.poiNm ? data.poiNm : '';
    tempData.수납여부		= data.rcptNm ? data.rcptNm : '';
    
    return tempData;
  }
  , retVoiceEMR : function (data, prcplist) {
    var tempData = {};
    tempData.customer_id	= 'TODO_customer_id';
    tempData.yymmdd			= data.recdd ? data.recdd : '';
    tempData.so			= data.rec_so ? data.rec_so : '';
    tempData.a			= data.rec_a ? data.rec_a : '';
    tempData.p			= data.rec_p ? data.rec_p : '';
    
    tempData.약처방		= ''; // 약
    tempData.주사		= ''; // 주사
    
    if (Array.isArray(prcplist)) {
      prcplist.forEach(function(row, idx) {
        if (data.recdd == row.prcpdd) {
          if (row.prcpclscd == 'A2') { // 약처방
            tempData.약처방 += row.prcpnm + ' ' + row.prcpdetl + '\n';	
          } else if (row.prcpclscd == 'A6') { // 주사처방
            tempData.주사 += row.prcpnm + ' ' + row.prcpdetl + '\n';
          }
        }
      });
    } else {
      if (data.recdd == prcplist.prcpdd) {
        if (prcplist.prcpclscd == 'A2') { // 약처방
          tempData.약처방 += prcplist.prcpnm + ' ' + prcplist.prcpdetl + '\n';	
        } else if (prcplist.prcpclscd == 'A6') { // 주사처방
          tempData.주사 += prcplist.prcpnm + ' ' + prcplist.prcpdetl + '\n';
        }
      }
    }
    
    return tempData;
  }
  , retResult : function (type, data) {
    var tempData = {};
    tempData.customer_id= 'TODO_doctor_id';
    tempData.검사종류	= type;
    tempData.진단일		= data.prcpdd ? data.prcpdd : '';
    tempData.보고일		= data.reptdt ? data.reptdt : '';
    tempData.검사명		= data.testnm ? data.testnm : '';
    tempData.결과		= data.testrslt ? data.testrslt : '';
    tempData.판정		= data.judgmark ? data.judgmark : '';
    tempData.단위		= data.rsltunit ? data.rsltunit : '';
    tempData.참고치		= data.refinfo ? data.refinfo : '';
    tempData.세부검체	= data.detlspcnm ? data.detlspcnm : '';
    
    return tempData;
  }
}