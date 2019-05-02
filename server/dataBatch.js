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
				, 'patientId'	: row.pid // 2009382,2010568
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
      tempData = JSON.parse(data.data);
      tempData = tempData.root.tmp;
    } catch(e) {
      tempData = data.data.root.tmp;
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




// 임시 데이터 포멧
var tempModel = {
  'doctor' : {
    'status' : '200'
    , 'content' : {
      "root": {
          "ret": {
              "resultKM": {
                  "updateinstance": true,
                  "clear": true,
                  "description": "info||정상 처리되었습니다.",
                  "source": 1556783844025,
                  "error": "no",
                  "type": "status"
              },
              "session": {
                  "cmcnu": "nabSlaA/mD4srPSQrjnsrPKtLzA+me[5Hfz6DUH54kNxwwDx5MN5GMBslDARlzA9lzA9lN[5uPe6GPe5GiDw5r+slz0RLn/J3nSoCK/05K7wwn7[EK/iEN9/lzb9lzA9lzA9Ln/3FKSfFK/g7nw[8N99l[l9Ln/JGn/yxN9+m[3/LnwREn/OGN9Rlzp9Ln/OGn7S3ljTrOnBrjKArOZsrfZ9rPqFLz0+Ln/34n/K4nwREn/iEN9RmDA[mN+nL0taL0YsL04Pb[A+mbc0ce+OZcl9lac1Y1cslz0RL04Pb[A+mbc0ce9/lz0Mlzb9lD0SmaI/mzA/mN9+m[O7laI7laA9kD0RlT9SlzA+LN9+m[O7laI7la0/kDbQLzA+me[5Hfz6DUH54kNxwwDx5MN5GMBslDARlzA9lzA9lN[5uPe6GPe5GiDw5r+slz09lDIQlDbUl[4slaA[Ln/05K/JGnwREn/3Fe9Rlzb[lzA9lzA9Ln/3FKSfFK/g7nw[8nScGKwREn/kvN99le9/lzA9lzA9lzA9LzA[Lzl+l[PsZGt8kcFRIyBlgdcsaTPQh2t9gdYvfTl3bTc/gSc/Ke9X"
              },
              "users": {
                  "usergrp": "",
                  "dutinstcd": "015",
                  "specordyn": "N",
                  "orddeptflag": "D",
                  "posinstcd": "015",
                  "userid": 95610268,
                  "fstrgstrid": 19200010,
                  "todd": 99991231,
                  "orginstcd": 103,
                  "deptabbr": "OS",
                  "prfshipflagnm": "전임교원",
                  "dutplceinstcd": "015",
                  "psnworkyn": "N",
                  "systemcd": "HIS015EDU",
                  "medispclno": 3132,
                  "ipaddr": "172.17.112.54",
                  "mpphonno": "01027425838",
                  "majorfild": "",
                  "grupjoblnnm": "교원직군",
                  "dutinstnm": "은평성모병원",
                  "fromdd": 20180101,
                  "systeminstcd": "015",
                  "apntflagnm": "보임",
                  "posinstnm": "은평성모병원",
                  "ordsupdeptcd": 2000000000,
                  "jobposcd": 1782,
                  "dutplcecd": 2050000000,
                  "lastupdtdt": 20180118112626716,
                  "orgdeptcd": 5053000000,
                  "prfshipflagcd": 11,
                  "licnsno": 56034,
                  "kmiip": "172.17.100.153",
                  "vpnyn": "N",
                  "userengnm": "Joo-Yup Lee",
                  "userkindcd": "01",
                  "systeminstnm": "HIS015EDU",
                  "grupjoblncd": "03",
                  "fstrgstdt": 20171228091313995,
                  "jobrespcd": 5040,
                  "lastupdtrid": 19400031,
                  "posdeptcd": 2050000000,
                  "orgdeptnm": "정형외과학교실",
                  "dutplcenm": "정형외과",
                  "dutunitnm": "정형외과",
                  "tempyn": "N",
                  "jobkindcd": "0330",
                  "logindt": 20190502165724024,
                  "jobposnm": "교수",
                  "usernm": "이주엽",
                  "userkindnm": "교직원",
                  "jobrespnm": "수부·상지센터장",
                  "systemnm": "HIS015EDU",
                  "orginstnm": "성의교정",
                  "posdeptnm": "정형외과",
                  "apntflag": "008",
                  "dutunitcd": 2050000000,
                  "deptengnm": "Orthopedics Surgery",
                  "jobkindnm": "의사",
                  "dutplceinstnm": "은평성모병원",
                  "kmiport": 6001
              }
          }
      }
  }
  }
  , 'patient' : { // 환자리스트 데이터
    'status' : '200'
    , 'content' : {
      'root' : {
        'resultKM' : {}
        /*
        'patlist' : [
          {
            'pid'			: '등록번호10' // 등록번호
            , 'hngnm'		: '환자명01' // 환자명
            , 'sa'			: '성별나이01' // 성별나이
            , 'hd'			: 'Hospital Day01' // Hospital Day
            , 'orddeptcd'	: '진료과01' // 진료과
            , 'deptnm'		: '진료과명01' // 진료과명
            , 'medispclnm'	: '주치의명01' // 주치의명
            , 'atdoctnm'	: '담당의명01' // 담당의명
            , 'diagnm'		: '진단명01' // 진단명
            , 'opnm'		: '수술명01' // 수술명
            , 'roomcd'		: '병실01' // 병실
          }
          , {
            'pid'			: '등록번호02' // 등록번호
            , 'hngnm'		: '환자명02' // 환자명
            , 'sa'			: '성별나이02' // 성별나이
            , 'hd'			: 'Hospital Day02' // Hospital Day
            , 'orddeptcd'	: '진료과02' // 진료과
            , 'deptnm'		: '진료과명02' // 진료과명
            , 'medispclnm'	: '주치의명02' // 주치의명
            , 'atdoctnm'	: '담당의명02' // 담당의명
            , 'diagnm'		: '진단명02' // 진단명
            , 'opnm'		: '수술명02' // 수술명
            , 'roomcd'		: '병실02' // 병실
          }
        ]
        */

        , 'patlist' : {
          'pid'			: '등록번호10' // 등록번호
          , 'hngnm'		: '환자명01' // 환자명
          , 'sa'			: '성별나이01' // 성별나이
          , 'hd'			: 'Hospital Day01' // Hospital Day
          , 'orddeptcd'	: '진료과01' // 진료과
          , 'deptnm'		: '진료과명01' // 진료과명
          , 'medispclnm'	: '주치의명01' // 주치의명
          , 'atdoctnm'	: '담당의명01' // 담당의명
          , 'diagnm'		: '진단명01' // 진단명
          , 'opnm'		: '수술명01' // 수술명
          , 'roomcd'		: '병실01' // 병실
        }
      }
    }
	}
	, 'result' : { // 검진결과 데이터
    'status' : '200'
    , 'content' : {
      'root' : {
        'resultKM' : {}
        , 'patinfo' : {
          'pid'			: '등록번호' // 등록번호
          , 'hngnm'		: '환자명' // 환자명
          , 'orddeptcd'	: '진료과코드' // 진료과코드
          , 'deptnm'		: '진료과명' // 진료과명
          , 'medispclid'	: '주치의 ID' // 주치의 ID
          , 'medispclnm'	: '주치의 명' // 주치의 명
          , 'atdoctid'	: '담당의 ID' // 담당의 ID
          , 'atdoctnm'	: '담당의 명' // 담당의 명
          , 'wardcd'		: '병동코드' // 병동코드
          , 'wardnm'		: '병동명' // 병동명
          , 'roomcd'		: '병실코드' // 병실코드
          , 'nursinfo'	: '간호사정보' // 간호사정보
          , 'diagnm'		: '진단명' // 진단명
          , 'opnm'		: '수술명' // 수술명
          , 'hd'			: 'HD' // HD
          , 'pod'			: 'POD' // POD
        }
        , 'reclist' : [
          {
            'recdd'		: '기록일1' // 기록일
            , 'rec_so'	: 'S_O' // S_O
            , 'rec_a'	: 'A' // A
            , 'rec_p'	: 'P' // P
          }
        ]
        , 'prcplist' : [
          {
            'prcpdd'		: '기록일1' // 처방일
            , 'prcpclscd'	: 'A2' // 구분코드
            , 'prcpclsnm'	: '구분명1' // 구분명
            , 'clsdispnm'	: '구분표시명1' // 구분표시명
            , 'prcpcd'		: '처방코드1' // 처방코드
            , 'prcpnm'		: '처방내역1' // 처방내역
            , 'prcpdetl'	: '처방상세1' // 처방상세
            , 'prcpstatnm'	: '상태1' // 상태
          }
          , {
            'prcpdd'		: '기록일1' // 처방일
            , 'prcpclscd'	: 'A6' // 구분코드
            , 'prcpclsnm'	: '구분명2' // 구분명
            , 'clsdispnm'	: '구분표시명2' // 구분표시명
            , 'prcpcd'		: '처방코드2' // 처방코드
            , 'prcpnm'		: '처방내역2' // 처방내역
            , 'prcpdetl'	: '처방상세2' // 처방상세
            , 'prcpstatnm'	: '상태2' // 상태
          }
        ]
        , 'btlist' : [
          {
            'prcpdd'		: '기록일1' // 처방일
            , 'testnm'		: '검사명' // 검사명
            , 'testrslt'	: '결과' // 결과
            , 'judgmark'	: '판정' // 판정
            , 'rsltunit'	: '단위' // 단위
            , 'refinfo'		: '참고치' // 참고치
            , 'reptdt'		: '보고일시' // 보고일시
          }
        ]
        , 'bctlist' : [
          {
            'prcpdd'		: '처방일1' // 처방일
            , 'testnm'		: '검사명' // 검사명
            , 'testclsnm'	: '검사항목명' // 검사항목명
            , 'testrslt'	: '결과' // 결과
            , 'reptdt'		: '보고일시' // 보고일시
          }
        ]
        /*
        , 'biopsylist' : [
          {
            'testdd'		: '육안검사일' // 육안검사일
            , 'testnm'		: '검사명' // 검사명
            , 'spcnm'		: '대표검체' // 대표검체
            , 'detlspcnm'	: '세부검체' // 세부검체
            , 'testrslt1'	: '결과1' // 결과1
            , 'testrslt2'	: '결과2' // 결과2
            , 'testrslt3'	: '결과3' // 결과3
            , 'testrslt4'	: '결과4' // 결과4
            , 'testrslt5'	: '결과5' // 결과5
            , 'testrslt6'	: '결과6' // 결과6
            , 'cmtcnts'		: '결과 Comment' // 결과 Comment
          }
          , {
            'testdd'		: '육안검사일' // 육안검사일
            , 'testnm'		: '검사명' // 검사명
            , 'spcnm'		: '대표검체' // 대표검체
            , 'detlspcnm'	: '세부검체' // 세부검체
            , 'testrslt1'	: '결과1' // 결과1
            , 'testrslt2'	: '결과2' // 결과2
            , 'testrslt3'	: '결과3' // 결과3
            , 'testrslt4'	: '결과4' // 결과4
            , 'testrslt5'	: '결과5' // 결과5
            , 'testrslt6'	: '결과6' // 결과6
            , 'cmtcnts'		: '결과 Comment' // 결과 Comment
          }
        ]
        /**/
        , 'biopsylist' : {
          'testdd'		: '육안검사일' // 육안검사일
          , 'testnm'		: '검사명' // 검사명
          , 'spcnm'		: '대표검체' // 대표검체
          , 'detlspcnm'	: '세부검체' // 세부검체
          , 'testrslt1'	: '결과1' // 결과1
          , 'testrslt2'	: '결과2' // 결과2
          , 'testrslt3'	: '결과3' // 결과3
          , 'testrslt4'	: '결과4' // 결과4
          , 'testrslt5'	: '결과5' // 결과5
          , 'testrslt6'	: '결과6' // 결과6
          , 'cmtcnts'		: '결과 Comment' // 결과 Comment
        }
      }
    }
	}
	, 'schedule' : { // 스케줄 데이터
    'status' : '200'
    , 'content' : {
      'root' : {
        'resultKM' : {}
        /* 스케줄 List data
        , 'list' : [
          {
            'hospitalCd'	: '015' // 병원 기관기호
            , 'departmentCd': '진료과 코드' // 진료과 코드
            , 'departmentNm': '진료과 명칭' // 진료과 명칭
            , 'doctorId'	: '의사 ID' // 의사 ID
            , 'doctorNm'	: '의사 명' // 의사 명
            , 'visitDt'		: '진료일자' // 진료일자 (예약일자)
            , 'visitTm'		: '진료시간' // 진료시간 (예약시간)
            , 'visitKind'	: '진료' // 진료, 수납, 검사예약, 주사, 약, 검사
            , 'visitMemo'	: '일정 비고' // 일정 비고
            , 'statusCd'	: '상태코드' // 상태코드 (R:접수,W:대기,C:완료,H:보류)
            , 'statusNm'	: '상태메시지' // 상태메시지 (R:접수,W:대기,C:완료,H:보류)
            , 'nextLoc'		: '화면 표시용' // 가셔야할곳목록(화면 표시용)
            , 'poiCd'		: 'I/F 용' // 가셔야할곳목록(I/F 용)
            , 'poiNm'		: 'I/F 용' // 가셔야할곳목록 명칭(I/F 용)
            , 'telNum'		: '부서전화번호' // 부서전화번호 - 미래일정변경시 사용 (미사용)
            , 'rcptNm'		: '수납여부' // 수납여부(수납/미수납)
            , 'examDoc'		: '검사예문' // 검사예문
            , 'receiptNo'	: '접수번호' // 접수번호	
          }
          , {
            'hospitalCd'	: '015' // 병원 기관기호
            , 'departmentCd': '진료과 코드' // 진료과 코드
            , 'departmentNm': '진료과 명칭' // 진료과 명칭
            , 'doctorId'	: '의사 ID' // 의사 ID
            , 'doctorNm'	: '의사 명' // 의사 명
            , 'visitDt'		: '진료일자' // 진료일자 (예약일자)
            , 'visitTm'		: '진료시간' // 진료시간 (예약시간)
            , 'visitKind'	: '진료' // 진료, 수납, 검사예약, 주사, 약, 검사
            , 'visitMemo'	: '일정 비고' // 일정 비고
            , 'statusCd'	: '상태코드' // 상태코드 (R:접수,W:대기,C:완료,H:보류)
            , 'statusNm'	: '상태메시지' // 상태메시지 (R:접수,W:대기,C:완료,H:보류)
            , 'nextLoc'		: '화면 표시용' // 가셔야할곳목록(화면 표시용)
            , 'poiCd'		: 'I/F 용' // 가셔야할곳목록(I/F 용)
            , 'poiNm'		: 'I/F 용' // 가셔야할곳목록 명칭(I/F 용)
            , 'telNum'		: '부서전화번호' // 부서전화번호 - 미래일정변경시 사용 (미사용)
            , 'rcptNm'		: '수납여부' // 수납여부(수납/미수납)
            , 'examDoc'		: '검사예문' // 검사예문
            , 'receiptNo'	: '접수번호' // 접수번호	
          }
        ]
        /*  */
        /* 스케줄 단일 data */
        , 'list' : {
          'hospitalCd'	: '015' // 병원 기관기호
          , 'departmentCd': '진료과 코드' // 진료과 코드
          , 'departmentNm': '진료과 명칭' // 진료과 명칭
          , 'doctorId'	: '의사 ID' // 의사 ID
          , 'doctorNm'	: '의사 명' // 의사 명
          , 'visitDt'		: '진료일자' // 진료일자 (예약일자)
          , 'visitTm'		: '진료시간' // 진료시간 (예약시간)
          , 'visitKind'	: '진료' // 진료, 수납, 검사예약, 주사, 약, 검사
          , 'visitMemo'	: '일정 비고' // 일정 비고
          , 'statusCd'	: '상태코드' // 상태코드 (R:접수,W:대기,C:완료,H:보류)
          , 'statusNm'	: '상태메시지' // 상태메시지 (R:접수,W:대기,C:완료,H:보류)
          , 'nextLoc'		: '화면 표시용' // 가셔야할곳목록(화면 표시용)
          , 'poiCd'		: 'I/F 용' // 가셔야할곳목록(I/F 용)
          , 'poiNm'		: 'I/F 용' // 가셔야할곳목록 명칭(I/F 용)
          , 'telNum'		: '부서전화번호' // 부서전화번호 - 미래일정변경시 사용 (미사용)
          , 'rcptNm'		: '수납여부' // 수납여부(수납/미수납)
          , 'examDoc'		: '검사예문' // 검사예문
          , 'receiptNo'	: '접수번호' // 접수번호	
        }
        /* */
      }
    }
	}
};