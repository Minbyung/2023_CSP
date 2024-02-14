<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ include file="../common/head2.jsp" %>   
<head>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
    <link rel="stylesheet" href="/resource/chat/groupChat.css" />
</head>
<script>
	var stompClient = null;
	var myName = '${myName}';
	var senderId = '${myId}';
	var projectName = '${projectName}';
	var groupChatRoomProjectId = "${groupChatRoomProjectId}";
	var groupChatRoomMembersCount = '${groupChatRoomMembersCount}'
	
	function connect() {
	    var socket = new SockJS('/ws_endpoint'); // 서버로 연결을 시도(문)
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
		
		
		
		$('#chat-menu-button').click(function() {
	        $('#chat-sidebar').show();
	        $('#chat-overlay').show(); // 오버레이 표시
	    });

	    // 오버레이 클릭 이벤트 핸들러
	    $('#chat-overlay').click(function() {
	        $('#chat-sidebar').hide();
	        $(this).hide(); // 오버레이 숨김
	    });
		
	
	 // 멤버 이름 클릭 이벤트
	    $('.participants-container').on('click', '.participant div[id^=member-]', function() {
	    	
	      var memberId = $(this).data('member-id');
	      var memberName = $(this).text();
	      var $memberDetails = $('#member-details');
	      console.log("클릭")
	      $('.chat-btn').data('member-id', memberId);
	      
	   // AJAX 요청을 통해 멤버의 세부 정보를 가져옵니다.
	      $.ajax({
	        url: '../member/getMemberDetails', 
	        type: 'GET',
	        data: { memberId: memberId }, // 요청과 함께 서버로 보낼 데이터
	        dataType: 'json', // 서버로부터 기대하는 응답의 데이터 타입
	        success: function(data) {
	          // 성공 시, 응답 데이터로 모달의 내용을 채웁니다.
	          $memberDetails.html('<p>이름: ' + data.name + '</p>' +
	                              '<p>이메일: ' + data.email + '</p>' +
	                              '<p>전화번호: ' + data.cellphoneNum + '</p>'
	                              );
	          // 모달 창 표시.
	          $('#member-modal').fadeIn();
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	          // 오류 처리
	          console.error('AJAX 요청에 실패했습니다: ' + textStatus, errorThrown);
	        }
	      });
	    });


	    // 모달 닫기 버튼
	    $('.close').click(function() {
	      $('#member-modal').fadeOut();
	    });

	    // 모달 외부 클릭 시 모달 숨기기
	    $(window).click(function(event) {
	      if ($(event.target).hasClass('modal')) {
	        $('#member-modal').fadeOut();
	      }
	    });
	    
	    
	    $('.chat-btn').click(function() {
	    	  var memberId = $(this).data('member-id');
	   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
	   		  var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
	   		  // 새 창(팝업)으로 채팅방 열기
	   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
	   		  $('#member-modal').hide();
	    	});
	    
	    
	    
	    
	});
	
	

</script>

<body>
	<div class="chat-container">
		
		
		<div id="chat-header">
	    	<div id="recipient-name">
	    		<span id="recipientName">${projectName}(${groupChatRoomMembersCount})</span>
    		</div>
	    	<!-- 우측 상단 메뉴 버튼 -->
		    <div id="chat-menu-button">
		        <i class="fa-solid fa-bars"></i>
		    </div>
		    
		    <!-- 사이드바 -->
		    <div id="chat-sidebar" class="chat-sidebar">
<!-- 		    	높이물려받음 -->
		    	<div class="flex flex-col h-full"> 
				      <div class="chat-sidebar-header border border-green-600 h-20"></div>
				      <div class="chat-sidebar-body border border-green-600 flex-grow px-5 py-3">
					       <div class="participants-container">
						       <div class="flex">참여자(${groupChatRoomMembersCount})</div>
							   <c:forEach items="${members}" var="member">
								    <div class="participant flex justify-between border-green-600 py-8">
									    <div id="member-${member.id}" data-member-id="${member.id}">
									        ${member.name}
									    </div>
									    <div>   
									        <!-- 버튼에 클래스와 data- 속성 추가 -->
	<%-- 								        <button class="invite-btn" data-member-id="${member.id}" data-member-name="${member.name}" >초대하기</button> --%>
									        <button class="chat-btn" data-member-id="${member.id}" data-member-name="${member.name}" >채팅하기</button>
									    </div>
							        </div>
						       </c:forEach>
					       </div>
				      </div>
				      <div class="chat-sidebar-footer mt-auto border border-green-600 h-12"></div>
			      </div>  
	        </div>
	        
		    <!-- 사이드바를 위한 오버레이 -->
		    <div id="chat-overlay" class="chat-overlay"></div>
		    
		    <div id="member-modal" class="member-modal">
			<div class="modal-memberContent">
				<span class="close">&times;</span>
				<h2>멤버 세부 정보</h2>
				<div id="member-details" >
				<!-- 여기에 AJAX를 통해 가져온 멤버 정보를 채웁니다 -->
					</div>
					<div class="flex justify-center">
						<button class="chat-btn p-4 flex-grow text-center border border-red-300">채팅하기</button>
						<a class="p-4 flex-grow text-center border border-red-300" href="#">화상회의</a>
					</div>	
				</div>
			</div>
		    
		</div>	
		
		
		
		
		<div class="chat-box bg-green-200" id="chat">
		    <c:forEach items="${messages}" var="message">
		        <div class="${message.senderId == myId ? 'my-message' : 'other-message'}">
		            <div class="message-content">
		                <c:choose>
		                    <c:when test="${message.senderId != myId}">
		                        <b>${message.senderName}</b>:
		                    </c:when>
		                </c:choose>
		                ${message.content}
		            </div>
		            <div class="timestamp">
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