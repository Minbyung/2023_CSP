<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<%@ include file="../common/head2.jsp" %>
	 
<!DOCTYPE html>
<html lang="en" >
<head>
<link rel="stylesheet" href="/resource/cards/dist/style.css" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<link rel="stylesheet" href="/resource/project/detail.css" />
<link rel="stylesheet" href="/resource/dist/style.css" />
<link rel="stylesheet" href="/resource/dashboard/dashboard.css" />
</head>


<!--   <meta charset="UTF-8"> -->
<!--   <link rel="stylesheet" href="./style.css"> -->
<!--   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css"> -->

<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->





<script>
$(document).ready(function() {
	
	
	$("#submitBtn").click(function(){
		
		// 초대 메일 전송     	    	
	var email = $("#exampleFormControlInput1").val();
	var teamId = '1';
	
	$.ajax({
	    url: '../member/doInvite',
	    type: 'POST',
	    data: { teamId: teamId, email: email },
	    success: function(data) {
	      console.log(data);
// 	      $("#email").val("");
	      $('.layer-bg').hide();
		  $('.layer').hide();
		  
	    }
	  });
	});
	
	// 채팅방 리스트에서 채팅방 클릭하면 
	$('.chat-btn').click(function() {
  	  var memberId = $(this).data('member-id');
 		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
 		  var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
 		  // 새 창(팝업)으로 채팅방 열기
 		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
  	});
	
	
	
});

</script>




<body>
<div class="task-manager">
	<div class="left-bar">
	    <div class="upper-part">
	      <div class="actions">
	        <div class="circle"></div>
	        <div class="circle-2"></div>
	      </div>
	    </div>
	    <div class="left-content">
	      <ul class="action-list">
	       	<a href="../project/make?teamId=${teamId }">
	        	<button class="btn btn-warning">새 프로젝트</button>
	        </a>
	        <li class="item mt-8">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
	            stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-inbox"
	            viewBox="0 0 24 24">
	            <path d="M22 12h-6l-2 3h-4l-2-3H2" />
	            <path
	              d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z" />
	          </svg>
	          <a href="../dashboard/dashboard?teamId=${teamId }">
	         	<span>대시보드</span>
		      </a>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-star">
	            <polygon
	              points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
	            </svg>
	          <a href="../dashboard/myProject?teamId=${teamId }">
	          	<span>내 프로젝트</span>
	          </a>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
	            stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-calendar"
	            viewBox="0 0 24 24">
	            <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
	            <path d="M16 2v4M8 2v4m-5 4h18" />
	          </svg>
	          <span>Upcoming</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-hash">
	            <line x1="4" y1="9" x2="20" y2="9" />
	            <line x1="4" y1="15" x2="20" y2="15" />
	            <line x1="10" y1="3" x2="8" y2="21" />
	            <line x1="16" y1="3" x2="14" y2="21" /></svg>
	          <span>Important</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-users">
	            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
	            <circle cx="9" cy="7" r="4" />
	            <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
	            <path d="M16 3.13a4 4 0 0 1 0 7.75" /></svg>
	          <span>Meetings</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
	            stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-trash"
	            viewBox="0 0 24 24">
	            <path d="M3 6h18m-2 0v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
	          </svg>
	          <span>Trash</span>
	        </li>
	      </ul>
	      <ul class="category-list">
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-users">
	            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
	            <circle cx="9" cy="7" r="4" />
	            <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
	            <path d="M16 3.13a4 4 0 0 1 0 7.75" /></svg>
	          <span>Family</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
	            stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-sun"
	            viewBox="0 0 24 24">
	            <circle cx="12" cy="12" r="5" />
	            <path
	              d="M12 1v2m0 18v2M4.22 4.22l1.42 1.42m12.72 12.72l1.42 1.42M1 12h2m18 0h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
	          </svg>
	          <span>Vacation</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-trending-up">
	            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18" />
	            <polyline points="17 6 23 6 23 12" /></svg>
	          <span>Festival</span>
	        </li>
	        <li class="item">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
	            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
	            class="feather feather-zap">
	            <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" /></svg>
	          <span>Concerts</span>
	        </li>
	      </ul>
	    </div>
	  </div>
	<div class="page-content">
		<div class="dashboard-container">
	    	<div class="flex">
		    	<div class="dashboard-profile-name">${member.name}님 즐거운 ${amOrPm }입니다😊 </div>
		    	<div class="flex-grow"></div>
		    	<div class="widget-date">${currentDate }요일</div>
	    	</div>
	    	<div class="widget-container flex flex-wrap">
	    		<div class="card-long">
		   			<div class="card-long-header">
		   				<p>내 프로젝트</p>
		   			</div>
		   			<div class="card-long-body flex flex-wrap">
		   				<c:forEach items="${projects}" var="project">
		   					<div class="project-list">
			    				<a href="../project/detail?projectId=${project.id}">
									<div>${project.project_name }</div>
								</a>
							</div>
						</c:forEach>
	   				</div>
	    		</div>
	    		<div class="card-short">
	    			<div class="card-short-header">
	    				<p>구성원</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<div class="member-list flex modal-exam">
	    					<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-solid fa-user-plus"></i></span></div>
	    					<div class="member-list-detail flex flex-col justify-center">
	    						<div class="team-invite">직원 초대</div>
	    					</div>	
	    				</div>
	    				<div class="layer-bg"></div>
						<div class="layer">
							<span id="close" class="close close-btn-x">&times;</span>
							<div>직원초대</div>
							<div>직원들과 협업을 시작해보세요</div>
							
							<input type="email" class="form-control" id="exampleFormControlInput1" placeholder="초대하고싶은 직원의 이메일을 입력해주세요" required />
						    <button id="submitBtn" type="button" class="btn btn-primary">전송하기</button>
						</div>
	    				<c:forEach items="${teamMembers}" var="member">
					    	<div class="member-list flex">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-regular fa-user"></i></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="font-bold">${member.name}</div>
							    	<div class="text-xs">${member.teamName}</div>
						    	</div>
					    	</div>
						</c:forEach>
	    			</div>
	    		</div>
	    		<div class="card-long">
		   			<div class="card-long-header">
		   				<p>내가 담당중인 업무</p>
		   			</div>
		   			<div class="card-long-body flex flex-wrap">
		   				<c:forEach items="${taggedArticles}" var="taggedArticle">
		   					<div class="project-list">
									<div>${taggedArticle.title }</div>
							</div>
						</c:forEach>
	   				</div>
	    		</div>
	    		<div class="card-short">
	    			<div class="card-short-header">
	    				<p>채팅 방</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<c:forEach items="${chatRooms}" var="chatRoom">
					    	<div class="member-list flex chat-btn" data-member-id="${chatRoom.recipientId}">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-regular fa-user"></i></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="font-bold">${chatRoom.name}</div>
						    	</div>
					    	</div>
						</c:forEach>
	    			</div>
	    		</div>
			</div>
		</div>
	</div>  
</div>
  
</body>
</html>
