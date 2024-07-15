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
	<title>${project.project_name }</title>
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
  
  	<script>
		var projectId = ${project.id};
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
	</script>
	<script src="/resource/project/meeting.js"></script>
	<script src="/resource/common2.js"></script>
  
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
<!-- 새로운 JSP 파일 포함 -->
<jsp:include page="../common/checkCredential.jsp"/>
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
    				<li><a class="block" href="/usr/project/detail?projectId=${project.id }">피드</a></li>
    				<li><a class="block" href="/usr/project/task?projectId=${project.id }">업무</a></li>
    				<li><a class="block" id="calendarLink" href="#">캘린더</a></li>
    				<li><a class="block" href="/usr/project/file?projectId=${project.id }">파일</a></li>
    				<li><a class="block" href="/usr/project/meeting?projectId=${project.id }">영상회의</a></li>
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