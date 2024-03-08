<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>

<!DOCTYPE html>
<html lang="en" >
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="/resource/dist/style.css" />
  <link rel="stylesheet" href="/resource/project/detail.css" />
  <link rel="stylesheet" href="/resource/project/file.css" />
  <link rel="stylesheet" href="/resource/dashboard/dashboard.css" />
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-autocomplete/1.0.7/jquery.auto-complete.min.js"></script>
  
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
  <title>${project.project_name }</title>
<!--chart.js -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>

</head>
<!-- partial:index.partial.html -->
<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->
<body>
	<script>
	$(document).ready(function() {
		var projectId = ${project.id};
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
		
	     $.ajax({
	         url: '../favorite/getFavorite',
	         method: 'GET',
	         data: {
	             "projectId": projectId
	         },
	         dataType: "json",
	         success: function(data) {
	        	 if (data) {
	                 $('#favoriteIcon').addClass('fas');
	             } 
	        	 else {
	                 $('#favoriteIcon').addClass('far');
	             }
	         }
	     });
	     

	     $('#favoriteIcon').click(function() {
	    	 var isFavorite = $(this).hasClass('fas'); 
	        $.ajax({
	            url: '../favorite/updateFavorite',
	            method: 'POST',
	            data: {
	                "projectId": projectId, 
	                "isFavorite": !isFavorite 
	            },
	            success: function(response) {
	            	console.log(response);
	            	 $('#favoriteIcon').toggleClass('far fas');
	            }
	        });
	    });
		
	    // 채팅
	    $('.chat-btn').click(function() {
	    	  var memberId = $(this).data('member-id');
	   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
	   		  var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
	   		  // 새 창(팝업)으로 채팅방 열기
	   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
	   		  $('#member-modal').hide();
	    	});

	    $('.group-chat-btn').click(function() {
	    	  var groupChatRoomProjectId = $(this).data('groupChatRoomProjectId');
	    	  console.log(groupChatRoomProjectId);
	   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
	   		  var chatWindowUrl = '/usr/home/groupChat?groupChatRoomProjectId=' + encodeURIComponent(groupChatRoomProjectId);
	   		  // 새 창(팝업)으로 채팅방 열기
	   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
	    	});
		    
		    
		    $('.notification').click(function() {
		    	$('.rpanel').toggle();
		    	$('.notification-badge').hide();
		    });
		    
	    // 서버로부터 사용자별 알림 목록을 가져옵니다.
	    $.ajax({
	        url: '../project/getWriteNotifications',
	        type: 'GET',
	        data: { loginedMemberId: ${rq.getLoginedMemberId()} },
	        success: function(notifications) {
	            // 가져온 알림 목록을 페이지에 추가합니다.
	            notifications.forEach(function(notification) {
	            	// 새 알림 카드 HTML 구조 생성
		            const newNotificationCardHtml = `
				    <div class="notification-card">
		            	<div class="notification-project-name">\${notification.projectName}\</div>
				        <div class="notification-project-writername">글쓴이 : \${notification.writerName}\</div>
				        <div class="notification-project-regdate">작성날짜 : \${notification.regDate}\</div>
				        <div class="notification-project-title">제목 : \${notification.title}\</div>
				        <div class="notification-project-content">내용 : \${notification.content}\</div>
				    </div>`;

	                $('.list-notification').prepend(newNotificationCardHtml);
	            });
	            
	            
	        },
	        error: function() {
	            $('.list-notification').text('Failed to load notifications.');
	        }
	    });

		 // 아코디언 버튼 클릭 이벤트
		    $('.project-menu-accordion-button > .flex').click(function() {
		        // 프로젝트 목록 토글
		        $('.left-menu-project-list-box').slideToggle();

		        // 아이콘 변경
		        var icon = $(this).find('i');
		        if (icon.hasClass('fa-chevron-down')) {
		            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
		        } else {
		            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
		        }
		    });
			
		    $('.chat-menu-accordion-button > .flex').click(function() {
		        // 프로젝트 목록 토글
		        $('.left-menu-chat-list-box').slideToggle();

		        // 아이콘 변경
		        var icon = $(this).find('i');
		        if (icon.hasClass('fa-chevron-down')) {
		            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
		        } else {
		            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
		        }
		    });

		    connect();
	});

	var projectId = ${project.id};

    function connect() {
		// SockJS와 STOMP 클라이언트 라이브러리를 사용하여 웹소켓 연결을 설정합니다.
	    var socket = new SockJS('/ws_endpoint'); // 서버로 연결을 시도(문) 서버 간에 동일한 URL 경로를 사용하여 서로 통신할 수 있도록 일치시켜야함
	    stompClient = Stomp.over(socket);
	    // 웹소켓 연결을 시도합니다.
	    stompClient.connect({}, function(frame) {
	     // 사용자별 알림을 위한 구독
	        // 이 부분은 서버가 특정 사용자에게만 보내는 메시지를 받기 위한 것입니다.
	        stompClient.subscribe('/queue/notify-' + ${rq.getLoginedMemberId()}, function(notification) {
	            // 알림 메시지 처리 로직을 여기에 구현합니다.
	        	const message = JSON.parse(notification.body);
	            alert("새 메시지가 도착했습니다: " + message.content);
	        });
	     
	     
	        stompClient.subscribe('/queue/writeNotify-' + projectId + ${rq.getLoginedMemberId()}, function(lastPostedArticle) {
	            // 알림 메시지 처리 로직을 여기에 구현합니다.
	        	const writeNotificationMessage = JSON.parse(lastPostedArticle.body);

	            alert(writeNotificationMessage.writerName + "님이 새 글을 작성하셨습니다");
	            $('.notification-badge').show();
	        });
	    });
	}
    	
    
    
    
</script>

	


	<div class="task-manager">
		<div class="left-bar flex flex-col mt-0">
			<div class="logo h-20 mx-auto">로고</div>
		    <div class="left-content">
				<ul class="action-list flex flex-col">
					<div>
						<a href="../project/make?teamId=${teamId }"class="self-center block">
							<button class="new-project-btn">새 프로젝트</button>
						</a>
					</div>
					<li class="item mt-8"><svg xmlns="http://www.w3.org/2000/svg"
							width="24" height="24" fill="none" stroke="currentColor"
							stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							class="feather feather-inbox" viewBox="0 0 24 24">
		            <path d="M22 12h-6l-2 3h-4l-2-3H2" />
		            <path
								d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z" />
		          </svg> <a href="../dashboard/dashboard?teamId=${teamId }"> <span>대시보드</span>
					</a></li>
					<li class="item"><svg xmlns="http://www.w3.org/2000/svg"
							width="24" height="24" viewBox="0 0 24 24" fill="none"
							stroke="currentColor" stroke-width="2" stroke-linecap="round"
							stroke-linejoin="round" class="feather feather-star">
		            <polygon
								points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
		            </svg> <a href="../dashboard/myProject?teamId=${teamId }"> <span
							class="text-blue-500 font-bold">내 프로젝트</span>
					</a></li>
				</ul>
				<ul class="menu-accordion-group">
		          <li class="menu-accordion-button project-menu-accordion-button">
			          <div class="flex justify-between">
				          <div>프로젝트</div>
				          <div><i class="fa-solid fa-chevron-down"></i></div>
					  </div>	
					  <div class="left-menu-project-list-box mt-4">
				          <c:forEach items="${projects}" var="project">
			   					<div class="left-menu-project-list">
				    				<a href="../project/detail?projectId=${project.id}">
										<div>${project.project_name }</div>
									</a>
								</div>
							</c:forEach>
				      </div>
		     	  </li>
		     	  <li class="menu-accordion-button chat-menu-accordion-button">
			          <div class="flex justify-between">
				          <div>채팅방</div>
				          <div><i class="fa-solid fa-chevron-down"></i></div>
					  </div>	
					  <div class="left-menu-chat-list-box mt-4">
				          <c:forEach items="${chatRooms}" var="chatRoom">
						    	<div class="left-menu-chat-list flex">
							    	<div class="left-menu-chat-list-detail flex flex-col justify-center items-center">
								    	<div class="chat-btn" data-member-id="${chatRoom.recipientId}">${chatRoom.name}</div>
							    	</div>
						    	</div>
						 </c:forEach>
				      </div>
		     	  </li>	
		      </ul>
		    </div>
	    <div class="mt-auto lnb-bottom-customer">
	    	<a href="#" class="">
		    	<i class="fa-regular fa-circle-question self-center mr-3"></i> 
		    	<div>고객센터</div>
	    	</a>
	    </div>
	  </div>
	    <div class="rpanel">
			<div class="rpanel-list">
				<div class="list-header">
					<div class="text-lg font-bold">알림 센터</div>
					<span id="close" class="close close-btn-x">&times;</span>
				</div>
				<div class="list-notification">
				</div>
			</div>
		</div>
	  
		<div class="page-content bg-red-100 overflow-auto relative flex flex-col">
			<div class="bg-gray-100 detail-header">
				<div class="h-full flex justify-between items-center">
					<div class="flex items-center">
						<i data-project-id="${project.id}" id="favoriteIcon"
							class="far fa-star" style="font-size: 24px;"></i>
						<div class="ml-4">
							<h1 class="text-xl font-bold">${project.project_name }</h1>
							<div class="mt-1">${project.project_description }</div>
						</div>
					</div>
					<div class="flex items-center text-xl">
						<div class="notification-icon text-2xl">
							<i class="fas fa-bell notification"></i>
							<div class="notification-badge"></div>
						</div>
						<div class="ml-4">
							<a href="/usr/member/doLogout">로그아웃</a>
						</div>
					</div>
				</div>
			</div>
			<nav class="menu-box-1">
    			<ul>
    				<li><a class="block" href="../project/detail?projectId=${project.id }">피드</a></li>
    				<li><a class="block" href="../project/task?projectId=${project.id }">업무</a></li>
    				<li><a class="block" href="../project/gantt?projectId=${project.id }">간트차트</a></li>
    				<li><a class="block" href="../project/schd?projectId=${project.id }">캘린더</a></li>
    				<li><a class="block" href="../project/file?projectId=${project.id }">파일</a></li>
    				<li><a class="block" href="">알림</a></li>
    			</ul>
    		</nav> 	
  			<div class="file-list-container">
		  		<div>
			  		<div>파일 목록</div>
			  		<c:if test="${not empty projectFiles}">
						<div class="files">
						    <ul class="border border-black">
						        <c:forEach var="file" items="${projectFiles}">
									<li class="p-4 border border-b hover:hover:bg-gray-300">
										<a href="../file/downloadFile?articleId=${file.article_id }&fileId=${file.id }">
											<div class="flex justify-between">
												<div>${file.original_name}</div>
												<div><i class="fa-solid fa-download download-btn"></i></div>
											</div>
										</a>
									</li>
								</c:forEach>
						    </ul>
						</div>
					</c:if>	
		  		</div>
		  		
		  		
  			</div>
    	</div>
	</div>
</body>	

</html>


