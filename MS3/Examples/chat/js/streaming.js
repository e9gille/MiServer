(function (ms3, $, undefined) {
	
// streaming
	ms3.startStreaming = function (url) {
		ms3.ws = new WebSocket(url);
		ms3.ws.onopen = function(evt) 		{ ms3.onWebSocketOpen(evt) };
		ms3.ws.onclose = function(evt) 		{ ms3.onWebSocketClose(evt) };
		ms3.ws.onmessage = function(evt) 	{ ms3.onWebSocketMessage(evt) };
		ms3.ws.onerror = function(evt) 		{ ms3.onWebSocketError(evt) };
	}
  
	ms3.stopStreaming = function () {
		if (ms3.ws)
			ms3.ws.close();
	}
	
	ms3.onWebSocketOpen = function (evt) { 
		updateStatus("CONNECTED"); 
	}  
	
	ms3.onWebSocketClose = function (evt) {
		updateStatus("DISCONNECTED");
	}

	ms3.onWebSocketMessage = function (evt) { 
		var new_msg = JSON.parse(evt.data);
		
		writeToScreen( new_msg );
	}
	
	ms3.sendMessage = function(){
		var handle = $("#_handle").val();
		if (handle==""){
			handle = "Anonymous";
		}
		var message = {
			"text": $("#_message").val(),
			"handle": handle
		};		
		ms3.ws.send(JSON.stringify(message));
	}

  
	ms3.onWebSocketError = function (evt) { 
		updateStatus('<span style="color: red;">ERROR:</span> ' + evt.data); 
	}  
	
	function writeToScreen(message) {
		var out = "<p>[" + message.date + "] " + message.handle + ": " + message.text + "</p>";
		$("#output").prepend(out);
	}
	
	function updateStatus(message) {
		$("#status").html(message);
	}
	
	ms3.startStreaming("ws://127.0.0.1:8080/Examples/chat/chat.dyalog");
	
}( window.ms3 = window.ms3 || {}, window.jQuery ));