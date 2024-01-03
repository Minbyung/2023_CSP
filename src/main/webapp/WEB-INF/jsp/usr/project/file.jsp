<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<link rel="stylesheet" href="/resource/dist/style.css" />
<link rel="stylesheet" href="/resource/project/detail.css" />
<link rel="stylesheet" href="/resource/project/file.css" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />

<title>Insert title here</title>
</head>
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
		       	<a href="../project/make">
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
		          
		          <a href="../dashboard/dashboard?teamId=${project.teamId }">
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
		          <span>내 프로젝트</span>
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
		<div class="page-content bg-red-100 p-0 overflow-auto relative flex flex-col">
				  <div class="bg-gray-100 detail-header">
		     	  	<div class="h-full flex justify-between items-center">
		        	<div class="flex items-center">
		              <i data-project-id="${project.id}" id="favoriteIcon" class="far fa-star" style="font-size: 24px;"></i>
		              <div class="ml-4">
		                  <h1 class="text-xl font-bold">${project.project_name }</h1>
		                  <div class="mt-1">${project.project_description }</div>
		              </div>
		          </div>
		          <div>
		              <div>초대하기</div>
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
		  		
			  		파일 목록
			  		<c:if test="${not empty projectFiles}">
						<div class="files">
						    <ul class="border border-black">
						        <c:forEach var="file" items="${projectFiles}">
									<li class="p-4 border border-b"><a href="../file/downloadFile?articleId=${file.article_id }&fileId=${file.id }">${file.original_name}</a></li>
								</c:forEach>
						    </ul>
						</div>
					</c:if>
		  			
		  		
		  		</div>
		</div>
	</div>



</body>
</html>