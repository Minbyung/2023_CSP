<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ include file="../common/head2.jsp" %>   
<head>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
</head>
<script>
	var stompClient = null;
	
	function connect() {
	    var socket = new SockJS('/chat'); // 서버로 연결을 시도(문)
	    stompClient = Stomp.over(socket);
	    stompClient.connect({}, function(frame) {
	    	// '/topic/messages' 채널을 구독
	        stompClient.subscribe('/topic/messages', function(messageOutput) {
	        	console.log("작동");
	            var message = JSON.parse(messageOutput.body);
	            showMessage(message.content);
	        });
	    });
	}

	function showMessage(messageOutput) {
		var myName = '${myName}';
		var message = JSON.parse(messageOutput.body);
	    var messageType = (message.sender === myName) ? 'my-message' : 'other-message';
	    
	    // 메시지를 보낸 사람 이름과 메시지 내용을 포함하는 요소를 생성
	    var messageElement = $('<div class="' + messageType + '"><b>' + message.sender + '</b>: ' + message.content + '</div>');

	    // 채팅 창에 메시지 요소를 추가
	    $('.chat-box').append(messageElement);

	    // 채팅 창을 스크롤하여 최신 메시지가 보이도록 함
	    $('.chat-box').scrollTop($('.chat-box')[0].scrollHeight);
	    
	}
	
	
	function sendMessage() {
	    var messageContent = $('#messageInput').val();
	    var senderName = '${member.name}';
	    
	    if (messageContent.trim() !== '') { // 메시지 내용이 비어있지 않은지 확인
	        var chatMessage = {
	            content: messageContent,
	            sender: senderName
	            // sender, timestamp 등의 필드를 추가예정
	        };
	        stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
	        $('#messageInput').val('');
	    }
	}


	$(document).ready(function() {
	    
	    $('#messageInput').keypress(function(e) {
	        if(e.which == 13) { // 엔터키가 눌렸을 때
	            sendMessage();
	        }
	    });
	    $('#sendButton').click(sendMessage); 
	    
		connect();
	});	

</script>

<style>
.chat-box {
	height: 100px;
}
</style>


<body>
	    
	    <input type="text" id="messageInput" />
	    <button id="sendButton" onclick="sendMessage()">보내기</button>
		<div class="chat-box bg-green-200" id="chat"></div>
    
</body>
</html>