// Global UI elements:
//  - log: event log
//  - trans: transcription window

// Global objects:
//  - tt: simple structure for managing the list of hypotheses
//  - dictate: dictate object with control methods 'init', 'startListening', ...
//       and event callbacks onResults, onError, ...

//$('[data-toggle="tooltip"]').tooltip();

var tt = new Transcription();

var dictate = new Dictate({
		server : "wss://puzzle-ai.com:9223/client/ws/speech",
		serverStatus : "wss://puzzle-ai.com:9223/client/ws/status",
//		server : "wss://106.245.241.74:62001/client/ws/speech",
//		serverStatus : "wss://106.245.241.74:62001/client/ws/status",
		
		recorderWorkerPath : '_recorderWorker.js',
		onReadyForSpeech : function() {
			__message("READY FOR SPEECH");
			__status("녹취중입니다");
		},
		onEndOfSpeech : function() {
			__message("END OF SPEECH");
			__status("녹취가 종료되었습니다");
		},
		onEndOfSession : function() {
			__message("END OF SESSION");
			__status("세션이 종료되었습니다");
		},
		onServerStatus : function(json) {
			__serverStatus(json.num_workers_available + ':' + json.num_requests_processed);
			if (json.num_workers_available == 0) {
				$("#buttonStart").prop("disabled", true);
				$("#serverStatusBar").addClass("highlight");
			} else {
				$("#buttonStart").prop("disabled", false);
				$("#serverStatusBar").removeClass("highlight");
			}
		},
		onPartialResults : function(hypos) {
			// TODO: demo the case where there are more hypos
			tt.add(hypos[0].transcript, false);
			__updateTranscript(tt.toString());
		},
		onResults : function(hypos) {
			// TODO: demo the case where there are more results
			tt.add(hypos[0].transcript, true);
			__updateTranscript(tt.toString());
			// diff() is defined only in diff.html
			if (typeof(diff) == "function") {
				diff();
			}
		},
		onError : function(code, data) {
			__error(code, data);
			__status("Viga: " + code);
			dictate.cancel();
		},
		onEvent : function(code, data) {
			__message(code, data);
		}
	});

// Private methods (called from the callbacks)
function __message(code, data) {
	log.innerHTML = "msg: " + code + ": " + (data || '') + "\n" + log.innerHTML;
}

function __error(code, data) {
	log.innerHTML = "ERR: " + code + ": " + (data || '') + "\n" + log.innerHTML;
}

function __status(msg) {
	statusBar.innerHTML = msg;
}

function __serverStatus(msg) {
	serverStatusBar.innerHTML = msg;
}

function __updateTranscript(text) {
	var text_ori = text;
	var text_split = text.split(" ");
	var i;
	for (i=0; i<text_split.length; i++){
		if (!text_split[i].match('/^[A-Za-z]+$/')){
			text_split[i] = text_split[i].charAt(0).toUpperCase() + text_split[i].slice(1).toLowerCase();
		}
		if (text_split[i].length <= 2){
			text_split[i] = text_split[i].toLowerCase();
		}
		if (text_split[i].toUpperCase() == "EGD" || text_split[i].toUpperCase() == "IV"){
			text_split[i] = text_split[i].toUpperCase();
		}
	}
	text = text_split.join(" ");
	text = text.replace(/미리 그람/gi, "mg").replace(/증상 에/gi, "증상에").replace(/전처치 로/gi, "전처치로").replace(/식 도/gi, "식도").replace(/오십/gi, "50").replace(/십\ /gi, "10 ").replace(/오/gi, "5").replace(/퍼센트/gi, "%");
	text = text
	console.log(text);
	$("#trans").val(text);
}

// Public methods (called from the GUI)
function toggleLog() {
	$(log).toggle();
}
function clearLog() {
	log.innerHTML = "";
}

function clearTranscription() {
	tt = new Transcription();
	$("#trans").val("");
}

function startListening() {
	dictate.startListening();
}

function stopListening() {
	dictate.stopListening();
}

function cancel() {
	dictate.cancel();
}

function init() {
	dictate.init();
}

function showConfig() {
	var pp = JSON.stringify(dictate.getConfig(), undefined, 2);
	log.innerHTML = pp + "\n" + log.innerHTML;
	$(log).show();
}

// window.onload = function() {
// 	init();
// };
