<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MAIN" />
	
	<%@ include file="../common/head.jsp" %>
	
		<!-- HTML 파일에 SockJS와 STOMP 라이브러리를 포함 -->
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
	
	<script>
	function openChatWindow() {
	    // 실제 채팅 페이지의 URL로 대체해주세요.
	    window.open("/usr/home/chat", "chatWindow", "width=400,height=600");
	}
	</script>



	<div>
	대시보드 들어가려면(본 기능) 로그인
	</div>
<!-- 	<section class="mt-8"> -->
<!-- 		<div class="container mx-auto"> -->
<!-- 			<div> -->
<!-- 				안녕하세요 -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 		<div class="test widget-my-prj js-filter-widget update-hr">dsfsdfsdfsfsfddfdsffdsfd -->
<!-- 		sfdsfsdfsdfdsdsdsdsfdsfsddsfddsfddsfdf -->
<!-- 		dfsdfsdf</div> -->
		
<!-- 		<button onclick="openChatWindow()">Open Chat</button> -->
<!-- 		<a href="testHtml">htmltest</a> -->
<!-- 	</section> -->
	
	<%@ include file="../common/foot.jsp" %>