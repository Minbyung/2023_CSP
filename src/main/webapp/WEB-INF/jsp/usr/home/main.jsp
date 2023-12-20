<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MAIN" />
	
	<%@ include file="../common/head.jsp" %>
	
	
		<!-- HTML 파일에 SockJS와 STOMP 라이브러리를 포함 -->
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
	
	<script>
	var stompClient = null;
	
	function connect() {
	    var socket = new SockJS('/ws');
	    stompClient = Stomp.over(socket);
	    stompClient.connect({}, function(frame) {
	        console.log('Connected: ' + frame);
	        stompClient.subscribe('/topic/public', function(greeting) {
	            console.log(JSON.parse(greeting.body).content);
	        });
	    });
	}
	
	function disconnect() {
	    if (stompClient !== null) {
	        stompClient.disconnect();
	    }
	    console.log("Disconnected");
	}
	
	function sendMessage() {
	    stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({'content': $("#messageInput").val()}));
	}
	
	connect(); // 웹 페이지 로드 시 웹소켓 연결
	</script>
	
	
	
	
	
	
	
	
	
	
	<section class="mt-8">
		<div class="container mx-auto">
			<div>
				안녕하세요
			</div>
		</div>
		<div class="test widget-my-prj js-filter-widget update-hr">dsfsdfsdfsfsfddfdsffdsfd
		sfdsfsdfsdfdsdsdsdsfdsfsddsfddsfddsfdf
		dfsdfsdf</div>
		
		<input type="text" id="messageInput" />
		<button onclick="sendMessage()">Send</button>
		
		
	</section>
	
	<%@ include file="../common/foot.jsp" %>