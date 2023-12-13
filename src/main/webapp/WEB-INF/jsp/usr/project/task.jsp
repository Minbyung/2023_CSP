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
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <title>${project.project_name }</title>
</head>
<!-- partial:index.partial.html -->
<link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet">



	<script>
	$(document).ready(function() {
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
		       	console.log(response);
		       	 $('#favoriteIcon').toggleClass('far fas');
		       }
		   });
		});
	
		$(".status-btn-write").click(function(event) {
	        event.stopPropagation();
	        $(this).siblings(".status-menu").toggle();
	    });

	    $(document).click(function() {
	        $(".status-menu").hide();
	    });

	    $(".status-menu button").click(function() {
	        var newStatus = $(this).data('status'); // 클릭한 버튼의 상태를 가져옵니다.
	        var articleId = $(this).data('article-id');
	        $.ajax({
	            url: '../article/doUpdateStatus',
	            method: 'POST',
	            data: {
	            	'articleId': articleId,
	                'newStatus': newStatus
	            },
	            success: function() {
	                // 요청이 성공하면 상태 버튼의 텍스트를 업데이트하고 상태 리스트를 숨깁니다.
	                $(".status[data-article-id=" + articleId + "] .status-btn-write").text(status);
	                $(".status-menu").hide();
	                location.reload();
	            },
	            error: function() {
	                alert('상태 업데이트에 실패했습니다.');
	            }
	        });
	    });
		
		 // 그룹 추가 버튼을 눌렀을 때
	    $(".addGroupButton").click(function(){
	      // 그룹명 입력 창을 생성
	      var $inputRow = $('<tr><th colspan="7"><input placeholder="추가할 그룹명을 입력해 주세요." type="text" id="groupNameInput"></th></tr>');
	      $(".task-table").prepend($inputRow);
	      $("#groupNameInput").focus();
	    });	
		
		 
		 // 그룹명 입력 창에 엔터를 눌렀을 때
	    $(document).on('keypress', '#groupNameInput', function(event) {
	        if(event.keyCode == 13) {
	            saveGroup();
	        }
	    });

	   /*  // 그룹명 입력 창 외의 영역을 클릭했을 때
	    $(document).click(function(event){
		  if($('#groupNameInput').is(":visible") && !$(event.target).closest('#groupNameInput').length){
		    saveGroup();
		  }
		}); */
	    
		 // 그룹 저장 함수
	    function saveGroup() {
        
	      var group_name = $("#groupNameInput").val().trim();
	      var projectId = $('#favoriteIcon').data('project-id');
	      
	      if (group_name.length === 0) {
	            alert('그룹 이름을 입력해주세요.');
	            return;
	        }
	       $.ajax({
	            url: '../group/doMake',
	            method: 'POST',
	            data: {
	            	'projectId': projectId,
	                'group_name': group_name
	            },
	            success: function() {
	            	console.log(projectId);
	            	//그룹명 입력 창을 제거
// 	            	$("#groupNameInput").parent().parent().remove();
	            	location.reload();
	            },
	            error: function() {
	                alert('그룹 저장에 실패했습니다.');
	            }
	        });
		
	    } 
		 
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
				          <span>대시보드</span>
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
		<div class="page-content bg-red-100 p-0">
            <div class="h-20 bg-gray-100 detail-header flex items-center justify-between">
                <div class="flex items-center">
                    <div class="flex items-center">
                        <i data-project-id="1" id="favoriteIcon" class="far fa-star" style="font-size: 24px;"></i>
                        <div class="ml-4">
                            <h1 class="text-xl font-bold">${project.project_name}</h1>
                            <div class="mt-1">${project.project_description}</div>
                        </div>
                    </div>
                </div>
                <div>초대하기</div>
            </div>
            <nav class="menu-box-1">
                <ul>
                    <li><a class="block" href="../project/detail?projectId=1">피드</a></li>
                    <li><a class="block" href="../project/task?projectId=1">업무</a></li>
                    <li><a class="block" href="">간트차트</a></li>
                    <li><a class="block" href="">캘린더</a></li>
                    <li><a class="block" href="">파일</a></li>
                    <li><a class="block" href="">알림</a></li>
                </ul>
            </nav>        
            
            
            <div><button class="btn btn-active btn-sm addGroupButton">그룹 추가</button></div>
            
			<div class="overflow-x-auto">
			    <table class="table task-table">
			    	
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
			                <th>업무명</th>
			                <th style="text-align: center;">상태</th>
			                <th style="text-align: center;">담당자</th>
			                <th style="text-align: center;">시작일</th>
			                <th style="text-align: center;">마감일</th>
			                <th style="text-align: center;">등록일</th>
			                <th style="text-align: center;">업무번호</th>
			            </tr>
			        </thead>
			        <c:forEach var="group" items="${groupedArticles}">
			            <tbody>
			                <tr><th class="font-bold" colspan="7"><c:out value="${group.key}"/></th></tr>
			                <c:choose>
                    			<c:when test="${not empty group.value}">
			                <c:forEach var="article" items="${group.value}">
			                    <tr>
			                        <td><c:out value="${article.title}"></c:out></td>						
	                                <td class="status relative" data-id="${article.id}">
	                                    <button class="status-btn-write btn btn-active btn-xs btn-block" data-status="${article.status}">
	                                        <c:out value="${article.status}"></c:out>
	                                    </button>
	                                    <div class="status-menu" style="display: none; position: absolute; z-index: 1000;">
	                                        <div class="bg-white border border-black border-solid p-3 rounded">
	                                            <button class="status-btn-write btn btn-active btn-xs btn-block my-1" data-status="요청" data-article-id="${article.id}">요청</button>
	                                            <button class="status-btn-write btn btn-active btn-xs btn-block my-1" data-status="진행" data-article-id="${article.id}">진행</button>
	                                            <button class="status-btn-write btn btn-active btn-xs btn-block my-1" data-status="피드백" data-article-id="${article.id}">피드백</button>
	                                            <button class="status-btn-write btn btn-active btn-xs btn-block my-1" data-status="완료" data-article-id="${article.id}">완료</button>
	                                            <button class="status-btn-write btn btn-active btn-xs btn-block my-1" data-status="보류" data-article-id="${article.id}">보류</button>
	                                        </div>
	                                    </div>
	                                </td>						
	                                <td style="text-align: center;">
	                                    <c:forEach var="name" items="${fn:split(article.taggedNames, ',')}">
	                                        <c:out value="${name}"></c:out>
	                                    </c:forEach>
	                                </td>
	                                <td style="text-align: center;"><c:out value="${article.startDate.substring(2, 10)}"></c:out></td>
	                                <td style="text-align: center;"><c:out value="${article.endDate.substring(2, 10)}"></c:out></td>
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
</body>