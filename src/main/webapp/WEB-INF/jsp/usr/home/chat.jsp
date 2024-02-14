<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	var recipientName = '${recipientName}';
	var chatRoomId = "${chatRoomId}";
	
	
	function connect() {
		// SockJS와 STOMP 클라이언트 라이브러리를 사용하여 웹소켓 연결을 설정합니다.
	    var socket = new SockJS('/ws_endpoint'); // 서버로 연결을 시도(문) 서버 간에 동일한 URL 경로를 사용하여 서로 통신할 수 있도록 일치시켜야함
	    stompClient = Stomp.over(socket);
	    
	    // 웹소켓 연결을 시도합니다.
	    stompClient.connect({}, function(frame) {
	    	// 연결에 성공하면, 서버로부터 메시지를 받을 구독을 설정합니다. (클라이언트는 '/queue/chat-' + chatRoomId를 구독)
	    	// 서버로부터 메시지를 받으면 이 콜백 함수가 호출됩니다.
	        stompClient.subscribe('/queue/chat-' + chatRoomId, function(messageOutput) {
	        	// 메시지 처리 로직을 여기에 구현합니다.	
	        	showMessage(messageOutput.body);
	        });
	   
   	
	    	
	    });
	}

	function showMessage(messageOutputBody) {
		var message = JSON.parse(messageOutputBody);
	    var messageType = (message.senderName === myName) ? 'my-message' : 'other-message';
	    
// 		var messageTime = new Date(message.regDate).toLocaleTimeString();
		var messageTime = new Date(message.regDate).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true });
		
		
		var messageContent = (message.senderName === myName) ? 
		        message.content : '<b>' + message.senderName + '</b>: ' + message.content;

		    var messageElement = $('<div class="' + messageType + '">' + messageContent + '<span class="timestamp">' + messageTime + '</span></div>');
		
	    // 채팅 창에 메시지 요소를 추가
	    $('.chat-box').append(messageElement);

	    // 채팅 창을 스크롤하여 최신 메시지가 보이도록 함
	    $('.chat-box').scrollTop($('.chat-box')[0].scrollHeight);
	}

			
	
	function sendMessage() {
	    var messageContent = $('#messageInput').val();
	    var chatMessage = {
	            senderId: senderId,
	            content: messageContent,
	            recipientId: memberId,
	            senderName: myName,
	            chatRoomId: chatRoomId
	        };
	    	// 클라이언트에서 STOMP를 통해 서버에 메시지를 보냄
	 	   stompClient.send("/app/chat.private." + memberId, {}, JSON.stringify(chatMessage));
	        
	        $('#messageInput').val('').focus();
	    }
	


	$(document).ready(function() {
		var chatBox = $('#chat');
		
	    $('#messageInput').keypress(function(e) {
	        if(e.which == 13) { // 엔터키가 눌렸을 때
	            sendMessage();
	        }
	    });
		 // 채팅 페이지를 열었을 때 자동으로 가장 최근의 메시지가 있는 위치로 스크롤이 이동
	    chatBox.scrollTop(chatBox.prop('scrollHeight')); 
		connect();
	});
	
	

</script>

<body>
	<div class="chat-container">
		<div id="chat-header">
	    	<div id="recipient-name">채팅 상대: <span id="recipientName">${member.name}</span></div>
		</div>	
	
		<div class="chat-box bg-green-200" id="chat">
		    <c:forEach items="${messages}" var="message">
		        <div class="${message.senderId == myId ? 'my-message' : 'other-message'}">
		            <div class="message-content">
		                <!-- 내가 보낸 메시지가 아닐 때만 senderName을 표시합니다. -->
		                <c:choose>
		                    <c:when test="${message.senderId != myId}">
		                        <b>${message.senderName}</b>:
		                    </c:when>
		                </c:choose>
		                ${message.content}
		            </div>
		            <div class="timestamp">
		                <!-- 문자열 형태의 regDate를 포맷팅하기 위해 parseDate 사용 -->
		                <fmt:parseDate value="${message.regDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate"/>
		                <fmt:formatDate value="${parsedDate}" pattern="a h:mm" />
		            </div>
		        </div>
		    </c:forEach>
		</div>
		
	    <div class="input-group"> <!-- 입력 필드와 버튼을 감싸는 div에 클래스를 추가 -->
	        <input type="text" id="messageInput" placeholder="메시지를 입력하세요..."/>
	        <button id="sendButton" onclick="sendMessage()">보내기</button>
	    </div>
    </div>
</body>
</html>