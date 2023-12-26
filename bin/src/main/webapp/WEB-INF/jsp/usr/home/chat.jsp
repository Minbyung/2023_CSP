<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ include file="../common/head2.jsp" %>   
<head>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
    <link rel="stylesheet" href="/resource/chat/chat.css" />
</head>
<script>
	var stompClient = null;
	var memberId = '${member.id}'; // 수신자 ID
	var myName = '${myName}';
	var senderId = '${myId}';
	
	function connect() {
	    var socket = new SockJS('/chat'); // 서버로 연결을 시도(문)
	    stompClient = Stomp.over(socket);
	    stompClient.connect({}, function(frame) {
	    	
	        stompClient.subscribe('/queue/chat-' + senderId, function(messageOutput) {
	        	showMessage(messageOutput.body);
	        });
	    });
	}

	function showMessage(messageOutputBody) {
		var message = JSON.parse(messageOutputBody);
	    var messageType = (message.senderName === myName) ? 'my-message' : 'other-message';
// 	    // 메시지를 보낸 사람 이름과 메시지 내용을 포함하는 요소를 생성
// 	    var messageElement = $('<div class="' + messageType + '"><b>' + message.senderName + '</b>: ' + message.content + '</div>');
		
		var messageContent = (message.senderName === myName) ? 
        message.content : '<b>' + message.senderName + '</b>: ' + message.content;

  	 	var messageElement = $('<div class="' + messageType + '">' + messageContent + '</div>');
		
	    // 채팅 창에 메시지 요소를 추가
	    $('.chat-box').append(messageElement);

	    // 채팅 창을 스크롤하여 최신 메시지가 보이도록 함
	    $('.chat-box').scrollTop($('.chat-box')[0].scrollHeight);
	    
	}

			
	
	function sendMessage() {
	    var messageContent = $('#messageInput').val();
	    var chatMessage = {
	            senderId: senderId,
	            content: messageContent
	        };
	    
	 	   stompClient.send("/app/chat.private." + memberId, {}, JSON.stringify(chatMessage));
	        
	        console.log(memberId);
	        $('#messageInput').val('');
	    }
	


	$(document).ready(function() {
	    
	    $('#messageInput').keypress(function(e) {
	        if(e.which == 13) { // 엔터키가 눌렸을 때
	            sendMessage();
	        }
	    });
	    
		connect();
	});	

</script>

<style>
.chat-box {
	height: 90vh;
}
</style>


<body>
	    
	    
<!-- 		<div class="chat-box bg-green-200" id="chat"></div> -->
<!-- 		<div> -->
<!-- 			<input type="text" id="messageInput" /> -->
<!-- 		    <button id="sendButton" onclick="sendMessage()">보내기</button> -->
<!-- 	    </div> -->


	<div class="chat-box bg-green-200" id="chat"></div>
    <div class="input-group"> <!-- 입력 필드와 버튼을 감싸는 div에 클래스를 추가 -->
        <input type="text" id="messageInput" placeholder="메시지를 입력하세요..."/>
        <button id="sendButton" onclick="sendMessage()">보내기</button>
    </div>
    
</body>
</html>