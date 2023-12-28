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
	var myName = '${myName}';
	var senderId = '${myId}';
	var projectName = '${projectName}';
	var groupChatRoomProjectId = "${groupChatRoomProjectId}";
	
	
	function connect() {
	    var socket = new SockJS('/chat'); // 서버로 연결을 시도(문)
	    stompClient = Stomp.over(socket);
	    stompClient.connect({}, function(frame) {
	    	
	        stompClient.subscribe('/topic/chat-group-' + groupChatRoomProjectId, function(messageOutput) {
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
	            senderId: senderId, //나
	            content: messageContent,
	            senderName: myName, // 나
	            groupChatRoomProjectId: groupChatRoomProjectId
	        };
	    
	 	   stompClient.send("/app/chat.group." + groupChatRoomProjectId, {}, JSON.stringify(chatMessage));
	        
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
	    	<div id="recipient-name"><span id="recipientName">${projectName}</span></div>
		</div>	
	
		<div class="chat-box bg-green-200" id="chat">
<%-- 		    <c:forEach items="${messages}" var="message"> --%>
<%-- 		        <div class="${message.senderId == myId ? 'my-message' : 'other-message'}"> --%>
<!-- 		            <div class="message-content"> -->
<!-- 		                내가 보낸 메시지가 아닐 때만 senderName을 표시합니다. -->
<%-- 		                <c:choose> --%>
<%-- 		                    <c:when test="${message.senderId != myId}"> --%>
<%-- 		                        <b>${message.senderName}</b>: --%>
<%-- 		                    </c:when> --%>
<%-- 		                </c:choose> --%>
<%-- 		                ${message.content} --%>
<!-- 		            </div> -->
<!-- 		            <div class="timestamp"> -->
<!-- 		                문자열 형태의 regDate를 포맷팅하기 위해 parseDate 사용 -->
<%-- 		                <fmt:parseDate value="${message.regDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate"/> --%>
<%-- 		                <fmt:formatDate value="${parsedDate}" pattern="a h:mm" /> --%>
<!-- 		            </div> -->
<!-- 		        </div> -->
<%-- 		    </c:forEach> --%>
		</div>
		
	    <div class="input-group"> <!-- 입력 필드와 버튼을 감싸는 div에 클래스를 추가 -->
	        <input type="text" id="messageInput" placeholder="메시지를 입력하세요..."/>
	        <button id="sendButton" onclick="sendMessage()">보내기</button>
	    </div>
    </div>
</body>
</html>