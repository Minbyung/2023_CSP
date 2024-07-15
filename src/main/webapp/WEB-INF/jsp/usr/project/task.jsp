<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
  <script src="/resource/project/task.js"></script>
  
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
            	<button class="btn btn-active btn-sm addGroupButton mx-2">그룹 추가</button>
            	<button class="btn btn-active btn-sm modal-exam mx-2">업무 추가</button>
            </div>	
			<div class="bg-white p-4">
			    <table id="task-table-1" class="table task-table rounded-xl table-hover">
			        <colgroup>
			            <col style="width: 20%;">
			            <col style="width: 10%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			        </colgroup>
			        <thead>
			            <tr>
			                <th>업무명
				                <button class="sort-btn" data-column="title" data-order="ASC">▲</button>
	   							<button class="sort-btn" data-column="title" data-order="DESC">▼</button>
   							</th>
			                <th style="text-align: center;">상태</th>
			                <th style="text-align: center;">담당자</th>
			                <th style="text-align: center;">시작일
			                	<button class="sort-btn" data-column="startDate" data-order="ASC">▲</button>
	   							<button class="sort-btn" data-column="startDate" data-order="DESC">▼</button>
			                </th>
			                <th style="text-align: center;">마감일
				                <button class="sort-btn" data-column="endDate" data-order="ASC">▲</button>
		   						<button class="sort-btn" data-column="endDate" data-order="DESC">▼</button>
			                </th>
			                <th style="text-align: center;">등록일
				                <button class="sort-btn" data-column="regDate" data-order="ASC">▲</button>
		   						<button class="sort-btn" data-column="regDate" data-order="DESC">▼</button>
			                </th>
			                <th style="text-align: center;">업무번호
				                <button class="sort-btn" data-column="id" data-order="ASC">▲</button>
		   						<button class="sort-btn" data-column="id" data-order="DESC">▼</button>
			                </th>
			            </tr>
			        </thead>
			        <c:forEach var="group" items="${groupedArticles}">
			            <tbody>
			                <tr><th class="font-bold" colspan="7"> <button class="toggleTasks">▶</button> <c:out value="${group.key}"/></th></tr>
			                <c:choose>
                    			<c:when test="${not empty group.value}">
			                <c:forEach var="article" items="${group.value}">
			                    <tr>
			                    	<td><a href="/usr/article/detail?id=${article.id }"><c:out value="${article.title}"></c:out></a></td>					
	                                <td class="status relative" data-id="${article.id}">
	                                    <button class="status-btn-taskupdate btn btn-active btn-xs btn-block" data-status="${article.status}">
	                                        <c:out value="${article.status}"></c:out>
	                                    </button>
	                                    <div class="status-menu" style="display: none; position: absolute; z-index: 9000;">
	                                        <div class="bg-white border border-black border-solid p-3 rounded">
	                                            <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="요청" data-article-id="${article.id}">요청</button>
	                                            <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="진행" data-article-id="${article.id}">진행</button>
	                                            <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="피드백" data-article-id="${article.id}">피드백</button>
	                                            <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="완료" data-article-id="${article.id}">완료</button>
	                                            <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="보류" data-article-id="${article.id}">보류</button>
	                                        </div>
	                                    </div>
	                                </td>						
	                                <td style="text-align: center;">
	                                    <c:forEach var="name" items="${fn:split(article.taggedNames, ',')}" varStatus="status">
						                    <c:out value="${name}"></c:out><c:if test="${!status.last}">, </c:if>
						                </c:forEach>
	                                </td>
	                                <td style="text-align: center;">
									    <c:choose>
									        <c:when test="${article.startDate.substring(2, 10) == '00-01-01'}">
									            -
									        </c:when>
									        <c:otherwise>
									            <c:out value="${article.startDate.substring(2, 10)}"></c:out>
									        </c:otherwise>
									    </c:choose>
									</td>
	                                <td style="text-align: center;">
									    <c:choose>
									        <c:when test="${article.endDate.substring(2, 10) == '00-01-01'}">
									            -
									        </c:when>
									        <c:otherwise>
									            <c:out value="${article.endDate.substring(2, 10)}"></c:out>
									        </c:otherwise>
									    </c:choose>
									</td>
	                                <td style="text-align: center;"><c:out value="${article.regDate.substring(2, 10)}"></c:out></td>
	                                <td style="text-align: center;"><c:out value="${article.id}"></c:out></td>
			                    </tr>
			                </c:forEach>
				                </c:when>
		                  		<c:otherwise>
		                  		<tr>
		                            <td colspan="7" style="text-align: center;">작업 내용이 없습니다.</td>
		                        </tr>
		                  	  </c:otherwise>
		               		 </c:choose>
			            </tbody>
			        </c:forEach>
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
	        <button class="tab-btn tab-write" data-for-tab="1">글 작성</button>
	        <button class="tab-btn tab-meeting" data-for-tab="2">화상 회의</button>
	    </div>
	    <!-- 탭 내용 -->
	    <div class="tab-content" id="tab-1">
        	<span id="close" class="close close-btn-x">&times;</span>
			<div class="flex flex-col h-full">
				<div class="write-modal-body">
					<input type="hidden" id="projectId" value="${project.id }">
	<!-- 							<input type="file" id="fileInput" name="files" multiple> -->
					<div id="status" class="mt-4">
				      <button class="status-btn-write btn btn-active" data-status="요청">요청</button>
				      <button class="status-btn-write btn btn-active" data-status="진행">진행</button>
				      <button class="status-btn-write btn btn-active" data-status="피드백">피드백</button>
				      <button class="status-btn-write btn btn-active" data-status="완료">완료</button>
				      <button class="status-btn-write btn btn-active" data-status="보류">보류</button>
				    </div>
						<div id="inputArea">
						  <div class ="tag-container" id="tag-container"></div>
						  <div class="autocomplete-container flex flex-col mb-3" id="autocomplete-container">
							  <!-- 기존의 입력 필드 -->
							  <input type="text" class="form-control w-72" id="search" autocomplete="off" placeholder="담당자를 입력해주세요">
							  <!-- 자동완성 목록 -->
							  <section id="autocomplete-results" style="width:20%;"></section>
						  </div>
						<div class="mb-3">
							<label for="start-date">시작일:</label>
							<input type="datetime-local" id="start-date" name="start-date">
	
						    <label for="end-date">마감일:</label>
						    <input type="datetime-local" id="end-date" name="end-date">		
							  		
							  						  
							<select id="groupSelect" class="select select-bordered select-xs w-full max-w-xs"">
							    <c:forEach var="group" items="${groups}">
							        <c:choose>
							            <c:when test="${group.group_name eq '그룹 미지정'}">
							                <option value="${group.id}" selected>${group.group_name}</option>
							            </c:when>
							            <c:otherwise>
							                <option value="${group.id}">${group.group_name}</option>
							            </c:otherwise>
							        </c:choose>
							    </c:forEach>
							</select> 
						</div>
						
						</div>
						<div class="mb-3">
						  <label for="exampleFormControlInput1" class="form-label">제목</label>
						  <input type="email" class="form-control" id="exampleFormControlInput1" placeholder="제목을 입력해주세요" required />
						</div>
<!-- 						<div class="mb-3"> -->
<!-- 						  <label for="exampleFormControlTextarea1" class="form-label h-4">내용</label> -->
<!-- 						  <textarea class="form-control h-80" id="exampleFormControlTextarea1" rows="3" placeholder="내용을 입력해주세요" required></textarea> -->
<!-- 						</div> -->
						<div id="editor"></div>
						
						<div class="file_list" id="file_list">
							<div class="file_input pb-3 pt-3 flex items-center">
		                        <div> 첨부파일
		                            <input type="file" name="files" onchange="selectFile(this);" />
		                        </div>
		                        <button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>
	                 					<button type="button" onclick="addFile();" class="btns fn_add_btn p-2 border border-gray-400"><span>파일 추가</span></button>
		                    </div>
	                    </div>
					</div>	
				<div class="write-modal-footer">	
			 	   <button id="submitBtn" type="button">작성하기</button>
			    </div>
		    </div>
    	</div>
	    <div class="tab-content tab-meeting-content" id="tab-2" style="display: none;">
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