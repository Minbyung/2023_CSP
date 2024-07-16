<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<%@ include file="../common/head.jsp" %>
<!DOCTYPE html>
<html lang="en" >
<head>
<title>Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<link rel="stylesheet" href="/resource/dashboard/dashboard.css" />
	
	<script>
		var teamId = ${teamId};
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
	</script>
	<script src="/resource/dashboard/dashboard.js"></script>
</head>

<body>
	<div class="task-manager">	
		<div class="detail-header">
		    <div class="h-full flex justify-end items-center">
		        <div class="flex items-center text-xl gap-8">
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
	                    <span class="text-blue-500 font-bold">대시보드</span>
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
	                    <span >내 프로젝트</span>
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
	    <div class="lnb-bottom-customer">
	        <a href="#" class="">
	            <i class="fa-regular fa-circle-question self-center mr-3"></i>
	            <div>고객센터</div>
	        </a>
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
	    				<p>팀원(${teamMembersCnt })</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<div class="member-list flex invite-modal">
	    					<div class="member-invite-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-solid fa-user-plus"></i></span></div>
	    					<div class="member-list-detail flex flex-col justify-center">
	    						<div class="team-invite">팀원 초대</div>
	    					</div>	
	    				</div>
	    				<div class="layer-bg"></div>
						<div class="invite-layer">
							<div class="invite-box">
								<span id="close" class="close close-btn-x">&times;</span>
								<div>팀원초대</div>
								<div>팀원들과 협업을 시작해보세요</div>
								<input type="email" class="form-control invite-email-input" id="exampleFormControlInput1" placeholder="초대하고싶은 팀원의 이메일을 입력해주세요" required />
								<div class="flex-grow"></div>
							    <button id="submitBtn" type="button" class="btn btn-primary">전송하기</button>
						    </div>
						</div>
	    				<c:forEach items="${teamMembers}" var="member">
					    	<div class="member-list flex participant">
							        <div class="member-icon-wrap">
							            <span class="member-icon flex justify-center items-center profile-photo-container">
							                <img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo">
							            </span>
							        </div>
							        <div class="member-list-detail flex flex-col justify-center">
							            <div class="font-bold" id="member-${member.id}" data-member-id="${member.id}">
							                ${member.name}
							                <c:if test="${member.id == rq.getLoginedMemberId()}">(나)</c:if>
							            </div>
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
	   							<a href="/usr/article/detail?id=${taggedArticle.id}">${taggedArticle.title }</a>
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
					    	<div class="member-list flex chat-btn border-b" data-member-id="${chatRoom.recipientId}">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><span class="member-icon flex justify-center items-center profile-photo-container">
							                <img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo">
							            </span></span></div>
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

	<!-- 멤버이름 클릭하면 나오는 모달 -->
	<div id="member-modal" class="member-modal">
		<span class="close">&times;</span>
		<h2>멤버 세부 정보</h2>
		<div id="member-details" >
		<!--  멤버 정보 -->
		</div>
		<div class="flex justify-center">
			<button class="chat-btn detail-chat p-4 flex-grow text-center">1:1 채팅</button>
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
  
</body>
</html>
