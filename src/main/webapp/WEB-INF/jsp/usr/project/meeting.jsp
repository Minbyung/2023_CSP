<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    java.util.Date now = new java.util.Date();
    request.setAttribute("currentTime", now);
%>

<%@ include file="../common/head2.jsp" %>
<%@ include file="../common/toastUiEditorLib.jsp" %>

<!DOCTYPE html>
<html lang="en" >
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="/resource/home/home.css" />
  <link rel="stylesheet" href="/resource/project/task.css" />
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
  <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<!--   웹소켓	 -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
  
  
  <title>${project.project_name }</title>
  
	<style>
	   .menu-box-1 > ul > li:nth-of-type(2) > a::after {
	   		content: none;
		}
	 .menu-box-1 > ul > li:nth-of-type(5) > a::after {
		    content: "";
		    background-color: black;
		    width: 100%;
		    height: 2px;
		    position: absolute;
		    bottom: 0;
		    left: 0;
		   	transition: width .3s;
		}
	</style>
  
</head>
<!-- partial:index.partial.html -->
<link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet">



	<script>
	$(document).ready(function() {
		setMinDate();
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
		var projectId = $('#favoriteIcon').data('project-id');
		
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
	   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
	   		  var chatWindowUrl = '/usr/home/groupChat?groupChatRoomProjectId=' + encodeURIComponent(groupChatRoomProjectId);
	   		  // 새 창(팝업)으로 채팅방 열기
	   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
	    	});
		    
		    $('.close-btn-x').click(function(){
		    	$('.layer-bg').hide();
		    	$('.rpanel').hide();
		    });
		    
		    $('.notification').click(function() {
		    	$('.rpanel').toggle();
		    	$('.notification-badge').hide();
		    });
		    
		 // 서버로부터 사용자별 알림 목록을 가져옵니다.
		    $.ajax({
		        url: '/getTaggedNotifications',
		        type: 'GET',
		        data: { loginedMemberId: ${rq.getLoginedMemberId()} },
		        success: function(notifications) {
		            // 가져온 알림 목록을 페이지에 추가합니다.
		            notifications.forEach(function(notification) {
		            	// 새 알림 카드 HTML 구조 생성
			            const newNotificationCardHtml = `
			            	<div class="notification-card-wrap" style="position: relative;">
					            <a href="/usr/article/detail?id=\${notification.articleId}\" class="notification-link">
								    <div class="notification-card">
						            	<div class="notification-project-name">\${notification.projectName}\</div>
								        <div class="notification-project-writername">글쓴이 : \${notification.writerName}\</div>
								        <div class="notification-project-regdate">작성날짜 : \${notification.regDate}\</div>
								        <div class="notification-project-title">제목 : \${notification.title}\</div>
								    </div>
							    </a>
							    <button class="delete-notification-btn" data-id="\${notification.id}\" style="position: absolute; top: 10px; right: 10px; background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
						    </div>
						    `;

		                $('.list-notification').prepend(newNotificationCardHtml);
		            });
		            $('.delete-notification-btn').click(function() {
		                const notificationId = $(this).data('id');
		                deleteNotification(notificationId);
		            });
		            $('.clear-all-btn').click(function() {
		                deleteAllNotification();
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
		    
		 	// 영상회의
		    $('#createMeetingBtn').click(function() {
		    	const projectId = ${project.id};
		    	const topic = $('#meetingTopic').val();
		        const duration = $('#meetingDuration').val();
		        const startTime = $('#meetingStartTime').val();
		        const password = $('#meetingPassword').val();

		     	// startTime을 ISO 8601 형식으로 변환 ex)start_time=2024-07-09T08:34:33
		        const isoStartTime = new Date(startTime).toISOString();
		     
		        const requestData = {
		            topic: topic,
		            type: 2,
		            start_time: isoStartTime,
		            duration: duration,
		            password: password
		        };

		        // 요청 데이터를 로컬 스토리지에 저장
		        localStorage.setItem('zoomMeetingRequest', JSON.stringify(requestData));

		     	// state 파라미터에 프로젝트 ID 포함
		        const state = encodeURIComponent(projectId);
		     
		     	// 서버에 세션 데이터를 저장하는 요청
		        $.ajax({
		            url: '/saveZoomMeetingRequest',
		            type: 'POST',
		            contentType: 'application/json',
		            data: JSON.stringify(requestData),
		            success: function(response) {
		                // OAuth 인증 URL로 리디렉션
		                var authUrl = `https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/oauth/callback&state=\${state}`;
		                window.location.href = authUrl;
		            },
		            error: function(error) {
		                console.error('Error:', error);
		                // Handle error
		            }
		        });
		    });
		    

//		업무 추가 버튼을 누르면		
	    $('.modal-exam').click(function(){
    		$('.layer-bg').show();
    		$('.layer').show();
    	});

    	$('.close-btn').click(function(){
    		$('.layer-bg').hide();
    		$('.layer').hide();
    	});

    	$('.close-btn-x').click(function(){
    		$('.layer-bg').hide();
    		$('.layer').hide();
    	});

    	$('.layer-bg').click(function(){
    		$('.layer-bg').hide();
    		$('.layer').hide();
    	});
    	

		// 달력아이콘과 옆 년월일 눌러도 달력나오게
	    $('#start-date, #end-date').on('click', function() {
	        this.showPicker(); 
	    });
		
		$(document).on('click', '.toggleTasks', function() { // 동적으로 생성된 요소에 이벤트 핸들러를 적용하려면, $(document).on(event, selector, function) 형태를 사용
		    $(this).closest('tr').nextAll().toggle();
		});		

		$('.sort-btn').on('click', function() {
        var column = $(this).data('column');
        var order = $(this).data('order');
        var table = $('#task-table-1');

        // Find the index of the column to sort
        var columnIndex = -1;
        table.find('th').each(function(index) {
            var thColumn = $(this).find('.sort-btn').data('column');
            if (thColumn === column) {
                columnIndex = index;
                return false; // Break the loop
            }
        });


        if (columnIndex === -1) return; // Column not found

        table.find('tbody').each(function() {
            var tbody = $(this);
            var header = tbody.find('tr:first'); // Group header row
            var rows = tbody.find('tr').not(':first').get(); // Group rows except header


            rows.sort(function(a, b) {
                var A = $(a).children('td').eq(columnIndex).text().trim();
                var B = $(b).children('td').eq(columnIndex).text().trim();

                // Handle date comparison if the column is 'startDate' or 'endDate' or 'regDate'
                if (column === 'startDate' || column === 'endDate' || column === 'regDate') {
                    A = parseDate(A);
                    B = parseDate(B);
                } else if (column === 'id') { // Handle numeric comparison if the column is 'id'
                    A = parseInt(A, 10);
                    B = parseInt(B, 10);
                }


                // Use localeCompare for string comparison, handle numeric comparison for 'id', and date comparison for dates
                return (A < B ? -1 : (A > B ? 1 : 0)) * (order === 'ASC' ? 1 : -1);
            });


            // Clear existing rows and re-append the sorted rows
            tbody.empty();
            tbody.append(header); // Re-add the group header
            $.each(rows, function(index, row) {
                tbody.append(row);
            });
        });

        // Toggle order for next click
        $(this).data('order', order === 'ASC' ? 'DESC' : 'ASC');
    });

    function parseDate(dateString) {
        // Assume the date format is YYYY-MM-DD
        var parts = dateString.split('-');
        return new Date(parts[0], parts[1] - 1, parts[2]);
    }
		
		
		
		
		
	 $('.member-detail').click(function(){
			$('.member-detail-menu').toggle();
		})
		// .member-detail-menu 이외의 부분 클릭 시 숨김 처리
	    $(document).click(function(event) {
	        var $target = $(event.target);
	        if(!$target.closest('.member-detail-menu').length && 
	           !$target.hasClass('member-detail')) {
	            $('.member-detail-menu').hide();
	        }
	    });
	 
	    $('.member-detail').click(function(){
			$('.member-detail-menu').toggle();
		})
		// .member-detail-menu 이외의 부분 클릭 시 숨김 처리
	    $(document).click(function(event) {
	        var $target = $(event.target);
	        if(!$target.closest('.member-detail-menu').length && 
	           !$target.hasClass('member-detail')) {
	            $('.member-detail-menu').hide();
	        }
	    });
	    
	    $('.btn-delete').click(function() {
            var meetingId = $(this).data('meeting-id');
            
            if (confirm("정말로 이 회의를 삭제하시겠습니까?")) {
            	console.log(meetingId);
                $.ajax({
                    url: '/usr/project/meeting/doDelete',
                    type: 'POST',
                    data: { meetingId: meetingId },
                    success: function(response) {
                        alert(response);
                        location.reload();
                    },
                    error: function(error) {
                        console.error('Error:', error);
                        alert('회의 삭제 중 오류가 발생했습니다.');
                    }
                });
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
	        	showMessage(message.senderName + "님이 새 채팅을 보냈습니다");
	        });
	     
	     
	        stompClient.subscribe('/queue/tagNotify-' + projectId + ${rq.getLoginedMemberId()}, function(lastPostedArticle) {
	            // 알림 메시지 처리 로직을 여기에 구현합니다.
	        	const writeNotificationMessage = JSON.parse(lastPostedArticle.body);

	            showMessage(writeNotificationMessage.writerName + "님이 태그하셨습니다");
	            $('.notification-badge').show();
	        });
	    });
	}
    	
	// 메시지 보기 함수
    function showMessage(message) {
        $("#messageBox").text(message).fadeIn(); // 메시지 박스를 서서히 나타나게 합니다.

        setTimeout(function() {
            $("#messageBox").fadeOut(); // 3초 후 메시지 박스를 서서히 사라지게 합니다.
        }, 3000); // 3000ms = 3초
    }

    function setMinDate() {
        var now = new Date();
        var year = now.getFullYear();
        var month = String(now.getMonth() + 1).padStart(2, '0');
        var day = String(now.getDate()).padStart(2, '0');
        var hours = String(now.getHours()).padStart(2, '0');
        var minutes = String(now.getMinutes()).padStart(2, '0');

        var minDate = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;

        $('#start-date').attr('min', minDate);
        $('#end-date').attr('min', minDate);
        $('#update-start-date').attr('min', minDate);
        $('#update-end-date').attr('min', minDate);
    }
    
 // 서버로 삭제 요청을 보내는 함수
    function deleteNotification(notificationId) {
        $.ajax({
            url: '/deleteNotificationById',
            type: 'POST',
            data: { notificationId: notificationId },
            success: function(response) {
            	console.log(response.success);
                if (response.success) {
                    // 알림 삭제 성공 시, 해당 알림 카드를 제거합니다.
                	 $(`button[data-id="\${notificationId}\"]`).closest('.notification-card-wrap').remove();
                } else {
                    alert('Failed to delete notification.');
                }
            },
            error: function() {
                alert('Error deleting notification.');
            }
        });
    }
    function deleteAllNotification() {
        $.ajax({
            url: '/deleteAllNotification',
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    // 알림 삭제 성공 시, 해당 알림 카드를 제거합니다.
                	 $('.list-notification').empty();
                } else {
                    alert('Failed to delete notification.');
                }
            },
            error: function() {
                alert('Error deleting notification.');
            }
        });
    }

	</script>





<body>
	<div class="task-manager">
		<div class="detail-header">
		    <div class="h-full flex justify-between items-center">
		        <div class="flex items-center">
		            <i data-project-id="${project.id}" id="favoriteIcon" class="far fa-star" style="font-size: 24px;"></i>
		            <div class="ml-4">
		                <h1 class="text-xl font-bold">${project.project_name}</h1>
		                <div class="mt-1">${project.project_description}</div>
		            </div>
		        </div>
		        <div class="flex items-center text-xl gap-8">
		            <!-- <div class="cursor-pointer"><i class="fa-regular fa-bell flex items-center h-full notification"></i></div> -->
		            <div class="notification-icon text-2xl">
		                <i class="fas fa-bell fa-regular notification"></i>
		                <div class="notification-badge"></div>
		            </div>
		            <div class="cursor-pointer">
	                    <div class="flex items-center h-full relative member-detail justify-center">
	                        <div class="profile-photo-container"><img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo"></div>
	                        ${member.name}님
	                        <ul class="member-detail-menu">
	                            <li><a href="/usr/member/myPage">내 프로필</a></li>
	                            <li><a href="/usr/dashboard/dashboard?teamId=${member.teamId}">내 대시보드</a></li>
	                            <li><a href="/usr/member/doLogout">로그아웃</a></li>
	                        </ul>
	                    </div>
	                </div>
		            <div>
		                <a href="/usr/member/doLogout">로그아웃</a>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="left-bar flex flex-col">
		    <div class="left-content">
		        <div class="new-project-btn-wrap">
		            <button class="new-project-btn">
		                <a href="../project/make?teamId=${teamId}">새 프로젝트</a>
		            </button>
		        </div>
		        <ul class="action-list">
		            <li class="item mt-8 flex gap-2 items-center">
		                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
		                    stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-inbox"
		                    viewBox="0 0 24 24">
		                    <path d="M22 12h-6l-2 3h-4l-2-3H2" />
		                    <path
		                        d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z" />
		                </svg>
		                <a href="../dashboard/dashboard?teamId=${teamId}">
		                    <span>대시보드</span>
		                </a>
		            </li>
		            <li class="item flex gap-2 items-center">
		                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
		                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
		                    class="feather feather-star">
		                    <polygon
		                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
		                </svg>
		                <a href="../dashboard/myProject?teamId=${teamId}">
		                    <span class="text-blue-500 font-bold">내 프로젝트</span>
		                </a>
		            </li>
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
		                                <div>${project.project_name}</div>
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
		</div>
			

		<div class="page-content">
            <nav class="menu-box-1">
                <ul>
                    <li><a class="block" href="../project/detail?projectId=${project.id }">피드</a></li>
    				<li><a class="block" href="../project/task?projectId=${project.id }">업무</a></li>
                    <li><a class="block" href="../project/schd?projectId=${project.id }">캘린더</a></li>
                    <li><a class="block" href="../project/file?projectId=${project.id }">파일</a></li>
                    <li><a class="block" href="../project/meeting?projectId=${project.id }">영상회의</a></li>
                </ul>
            </nav>        

            <div class="flex justify-end p-2">
            	<button class="btn btn-active btn-sm modal-exam mx-2">화상회의 추가</button>
            </div>	
			<div class="p-4">
			    <table id="task-table-1" class="table task-table rounded-xl table-hover">
				    <colgroup>
				        <col style="width: 20%;">
				        <col style="width: 20%;">
				        <col style="width: 20%;">
				        <col style="width: 20%;">
				        <col style="width: 10%;">
				        <col style="width: 10%;">
				    </colgroup>
				    <thead>
				        <tr>
				            <th style="text-align: center;">회의 이름
				                <button class="sort-btn" data-column="topic" data-order="ASC">▲</button>
				                <button class="sort-btn" data-column="topic" data-order="DESC">▼</button>
				            </th>
				            <th style="text-align: center;">회의 생성일
				                <button class="sort-btn" data-column="createdAt" data-order="ASC">▲</button>
				                <button class="sort-btn" data-column="createdAt" data-order="DESC">▼</button>
				            </th>
				            <th style="text-align: center;">회의 시작일
				                <button class="sort-btn" data-column="StartDate" data-order="ASC">▲</button>
				                <button class="sort-btn" data-column="StartDate" data-order="DESC">▼</button>
				            </th>
				            <th style="text-align: center;">회의 시간
				                <button class="sort-btn" data-column="duration" data-order="ASC">▲</button>
				                <button class="sort-btn" data-column="duration" data-order="DESC">▼</button>
				            </th>
				            <th style="text-align: center;">참여</th>
				            <th style="text-align: center;">삭제</th>
				        </tr>
				    </thead>
				    <tbody>
				        <c:forEach var="meetingInfo" items="${meetingInfos}">
				        	<c:set var="startTime" value="${meetingInfo.start_time.time}" />
            				<c:set var="endTime" value="${startTime + meetingInfo.duration * 60000}" />
				            <c:choose>
				                <c:when test="${not empty meetingInfos}">
				                    <tr>
				                        <td style="text-align: center; vertical-align: middle;">${meetingInfo.topic }</td>
				                        <td style="text-align: center; vertical-align: middle;">
				                        	<fmt:formatDate value="${meetingInfo.createdAt}" pattern="yy-MM-dd HH:mm"/>
				                        </td>
				                        <td style="text-align: center; vertical-align: middle;">
				                        	<fmt:formatDate value="${meetingInfo.start_time}" pattern="yy-MM-dd HH:mm"/>
				                        </td>
				                        <td style="text-align: center; vertical-align: middle;">${meetingInfo.duration }분</td>
				                        <td style="text-align: center; vertical-align: middle;">
				                        	<c:choose>
				                                <c:when test="${currentTime.time le endTime}">
				                                    <c:if test="${meetingInfo.memberId == rq.getLoginedMemberId()}">
				                                        <a href="${meetingInfo.start_url}" class="btn-join">회의 시작</a>
				                                    </c:if>
				                                    <c:if test="${meetingInfo.memberId != rq.getLoginedMemberId()}">
				                                        <a href="${meetingInfo.join_url}" class="btn-join">참여하기</a>
				                                    </c:if>
				                                </c:when>
				                                <c:otherwise>
				                                    <span class="btn-disabled">종료된 회의</span>
				                                </c:otherwise>
				                            </c:choose>
				                        </td>
				                        <td style="text-align: center; vertical-align: middle;">
				                        	<c:if test="${meetingInfo.memberId == rq.getLoginedMemberId()}">
				                                <button class="btn-delete" data-meeting-id="${meetingInfo.id}">삭제하기</button>
				                            </c:if>
				                        </td>
				                    </tr>
				                </c:when>
				                <c:otherwise>
				                    <tr>
				                        <td colspan="6" style="text-align: center;">예정된 영상 회의가 없습니다.</td>
				                    </tr>
				                </c:otherwise>
				            </c:choose>
				        </c:forEach>
				    </tbody>
				</table>
			</div>
			
			
        </div>      
    </div>
    
    
    <div class="rpanel">
		<div class="rpanel-list">
			<div class="list-header border-b">
				<div class="text-lg font-bold">알림 센터</div>
				<span id="close" class="close close-btn-x">&times;</span>
				<button class="clear-all-btn">모두 읽음</button>
			</div>
			
			<div class="list-notification">
			</div>
		</div>
	</div>
	
    <div id="messageBox" class="message-box" style="display: none;"></div>  
    
    <div class="layer-bg"></div>
		<div class="layer p-10">
		<div class="tabs flex">
	        <button class="tab-btn tab-meeting" data-for-tab="2">화상 회의</button>
	    </div>
	    <!-- 탭 내용 -->
	    <div class="tab-meeting-content" id="tab-2">
	    	<span id="close" class="close close-btn-x">&times;</span>
	    	<div class="flex flex-col h-full mt-4">
	    		<div class="flex-grow">
			    	<input type="text" id="meetingTopic" class="form-control w-72 mt-4" name="meetingTopic" placeholder="회의의 제목을 입력해주세요">
				    <input type="number" id="meetingDuration" class="form-control w-72 mt-4" name="meetingDuration" placeholder="회의 시간(분)을 입력해주세요" />
				    <label for="meetingStartTime">회의 시작 시간 :</label>
		      		<input type="datetime-local" id="meetingStartTime" class="mt-4" name="meetingStartTime">
		      		<input type="text" id="meetingPassword" class="form-control w-72 mt-4" name="meetingPassword" placeholder="회의의 비밀번호를 입력해주세요">
		    	</div>    
			    <div class="write-modal-footer flex justify-end">	
					<button id="createMeetingBtn">Zoom 인증 및 회의 생성</button>
				</div>
	    	</div>
    	</div>
	</div>	
    
                
</body>