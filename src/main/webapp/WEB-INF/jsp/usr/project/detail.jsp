<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>

<!DOCTYPE html>
<html lang="en" >
<script src="https://cdn.tailwindcss.com"></script>
<!-- 제이쿼리 -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> -->
<head>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="/resource/dist/style.css" />
  <link rel="stylesheet" href="/resource/common.css" />
  <link rel="stylesheet" href="/resource/project/detail.css" />
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  
  <title>${project.project_name }</title>
</head>
<!-- partial:index.partial.html -->
<link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet">
<body>
	<script>
	$(document).ready(function() {
		var status = "요청"; // Default status 
		$(".status-btn-write[data-status='요청']").addClass("active"); // '요청' 버튼에 'active' 클래스를 추가합니다.
		
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
	     

	     $(".status-btn-write").click(function(){
	 	    $(".status-btn-write").removeClass("active");
	 	    $(this).addClass("active");

	 	    status = $(this).attr('data-status');
	 	  });
	     
	     
	     $('.modal-exam').click(function(){
	    		$('.layer-bg').show();
	    		$('.layer').show();
	    	})

	    	$('.close-btn').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    	})

	    	$('.close-btn-x').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    		// x버튼으로 끄면 안에 내용 빈칸으로 초기화
	    		$('.tag').remove();
	    		$('#exampleFormControlInput1').val('');
	    		$('#exampleFormControlTextarea1').val('');
	    	})

	    	$('.layer-bg').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    		// 회색바탕 눌러서 끄면 안에 내용 빈칸으로 초기화
	    		$('.tag').remove();
	    		$('#exampleFormControlInput1').val('');
	    		$('#exampleFormControlTextarea1').val('');
	    	})
	    	
//           글쓰기	     	    	
	    	$("#submitBtn").click(function(){
	    	var selectedGroupId = parseInt($('#groupSelect').val());
		    var title = $("#exampleFormControlInput1").val();
		    var content = $("#exampleFormControlTextarea1").val();
		 // 태그에 있는 모든 담당자를 배열로 가져옵니다.
		    var managers = $('.tag').map(function() {
		  // 'x' 버튼을 제외한 텍스트만 반환합니다.
		        return $(this).clone().children().remove().end().text();
		    }).get();
		 	
		    $.ajax({
		        url: '../article/doWrite',
		        type: 'POST',
		        data: { title: title, content: content, status: status, projectId: projectId, managers: managers, selectedGroupId: selectedGroupId },
		        success: function(data) {
		          console.log(selectedGroupId);
		          $("#title").val("");
		          $("#content").val("");
		          $('.tag').remove();
		          $('.layer-bg').hide();
				  $('.layer').hide();
				  location.reload();
		        }
		      });
		    });
	     
	     // 담당자 태그 및 자동 완성
	     $('#search').on('keyup', function() {
	    	    var search = $(this).val();
	    	    $('#autocomplete-results').empty();

	    	    if (search) {
	    	        $.ajax({
	    	            url: '../project/getMembers', 
	    	            type: 'GET',
	    	            data: { "term": search },
	    	            success: function(data) {
	    	                $.each(data, function(i, result) {
	    	                    // 태그에 있는 담당자를 확인합니다.
	    	                    var taggedMembers = $('.tag').map(function() {
	    	                        // 'x' 버튼을 제외한 텍스트만 반환합니다.
	    	                        return $(this).clone().children().remove().end().text();
	    	                    }).get();

	    	                    // 태그에 없는 담당자만 목록을 생성합니다.
	    	                    if(taggedMembers.indexOf(result) === -1) {
	    	                        var resultDiv = $('<div>' + result + '</div>');
	    	                        
	    	                        resultDiv.on('click', function() {
	    	                            var newValue = result;
	    	                            $('#search').val('');
	    	                            $('#autocomplete-results').empty();

	    	                            // 선택한 담당자를 태그로 표시합니다. 'x' 버튼을 추가합니다.
	    	                            var tag = $('<span class="tag">' + newValue + '<button class="tag-remove btn btn-circle"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
	    	                            $('#inputArea').prepend(tag);
										
	    	                            
	    	                        	// 입력 필드를 autocomplete-container의 맨 앞으로 이동합니다.
	    	                            $('#search').prependTo('.autocomplete-container');
	    	                        	
// 	    	                            // 입력 필드를 오른쪽으로 이동합니다.
// 	    	                            $('#search').appendTo('#inputArea');

	    	                            // 'x' 버튼에 클릭 이벤트 핸들러를 설정합니다.
	    	                            tag.find('.tag-remove').on('click', function() {
	    	                                tag.remove(); // 태그를 삭제합니다.
	    	                            });
	    	                        });
	    	                        
	    	                        $('#autocomplete-results').append(resultDiv);
	    	                    }
	    	                });
	    	            },
	    	            error: function(err) {
	    	                console.error(err);
	    	            }
	    	        });
	    	    }
	    	});
	     
// 	     상태버튼 현재 상태 활성화 표시

	     $('.status-btns-update').each(function() {
	         var currentStatus = $(this).data('current-status');
	         $(this).find('.status-btn-update').each(function() {
	             if ($(this).data('status') === currentStatus) {
	                 $(this).addClass("active");
	             }
	         });
	     });
// 	     상태버튼 업데이트	     
	     $('.status-btn-update').click(function() {
	    	    var newStatus = $(this).data('status');
	    	    var articleId = $(this).data('article-id');
	    	    $.ajax({
	    	        url: '../article/doUpdateStatus', 
	    	        type: 'POST',
	    	        data: {
	    	            'articleId': articleId,
	    	            'newStatus': newStatus
	    	        },
	    	        success: function(response) {
	    	        	console.log(response);
	    	            $('.status-btn-update').removeClass('active');
	    	            $(this).addClass('active');
	    	            location.reload();
	    	        }
	    	    });
	    	});
	     
	     
	     

	});
	
	
	
	</script>


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
  		  <div class="h-20 bg-gray-100 detail-header">
       	  	<div class="h-full flex justify-between items-center">
          	<div class="flex items-center">
                <i data-project-id="1" id="favoriteIcon" class="far fa-star" style="font-size: 24px;"></i>
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
    				<li><a class="block" href="">피드</a></li>
    				<li><a class="block" href="">업무</a></li>
    				<li><a class="block" href="">간트차트</a></li>
    				<li><a class="block" href="">캘린더</a></li>
    				<li><a class="block" href="">파일</a></li>
    				<li><a class="block" href="">알림</a></li>
    			</ul>
    		</nav>
    		
    		<section class="project-detail-container overflow-auto">
				<div class="mt-5 detail-wrap mx-auto">
    				<div class="postTimeline bg-yellow-100">
    					<div class="reportArea">
    					<h1>업무 리포트</h1>
    					<div>차트 나오는곳</div>
    					</div>
							<div class="modal-exam"><span>글 작성</span></div>
						<div class="layer-bg"></div>
						<div class="layer">
							<span id="close" class="close close-btn-x">&times;</span>
							<div id="status">
						      <button class="status-btn-write btn btn-active" data-status="요청">요청</button>
						      <button class="status-btn-write btn btn-active" data-status="진행">진행</button>
						      <button class="status-btn-write btn btn-active" data-status="피드백">피드백</button>
						      <button class="status-btn-write btn btn-active" data-status="완료">완료</button>
						      <button class="status-btn-write btn btn-active" data-status="보류">보류</button>
						    </div>
								<div id="inputArea">
								  <div class="autocomplete-container flex flex-col">
									  <!-- 기존의 입력 필드 -->
									  <input type="text" class="form-control w-2/5" id="search" autocomplete="off" placeholder="담당자를 입력해주세요">
									  <!-- 자동완성 목록 -->
									  <section id="autocomplete-results" style="width:20%;"></section>
								  </div>
								  
								  						  
								<select id="groupSelect" class="select w-full max-w-xs">
									<option disabled selected>그룹 설정</option>
									<c:forEach var="group" items="${groups }">
								  <option value="${group.id }">${group.group_name }</option>
								 	</c:forEach>
								</select>  
								  
								  
								  
								</div>
								<div class="mb-3">
								  <label for="exampleFormControlInput1" class="form-label">제목</label>
								  <input type="email" class="form-control" id="exampleFormControlInput1" placeholder="제목을 입력해주세요" required />
								</div>
								<div class="mb-3">
								  <label for="exampleFormControlTextarea1" class="form-label h-4">내용</label>
								  <textarea class="form-control h-80" id="exampleFormControlTextarea1" rows="3" placeholder="내용을 입력해주세요" required></textarea>
								</div>
						    <button id="submitBtn" type="button" class="btn btn-primary">제출</button>
						</div>
						<div id="postList">
						 
				
							<c:forEach var="article" items="${articles }">
								<div class="card z-0">
								  <div class="card-body z-0">
								  	<div class="flex z-0">
								  		<h6 class="card-subtitle mb-2 text-muted">${article.writerName }</h6>
								  		<h6 class="card-subtitle mb-2 ml-4 text-muted">${article.regDate }</h6>
								  	</div>
								    <h5 class="card-title">${article.title }</h5>
								    <p>그룹: ${article.groupName }</p> 
								    <div class="status-btns-update" data-current-status="${article.status }" >
								      <button class="status-btn-update btn btn-active btn-xs" data-status="요청" data-article-id="${article.id}">요청</button>
								      <button class="status-btn-update btn btn-active btn-xs" data-status="진행" data-article-id="${article.id}">진행</button>
								      <button class="status-btn-update btn btn-active btn-xs" data-status="피드백" data-article-id="${article.id}">피드백</button>
								      <button class="status-btn-update btn btn-active btn-xs" data-status="완료" data-article-id="${article.id}">완료</button>
								      <button class="status-btn-update btn btn-active btn-xs" data-status="보류" data-article-id="${article.id}">보류</button>
								    </div>
								    
								    담당자: <c:forEach var="name" items="${fn:split(article.taggedNames, ',')}">
									    ${name}
									</c:forEach>
								    
								    <p class="card-text">내용: ${article.content }</p>
								    
								    
								  </div>
								</div>
							</c:forEach>
						</div>
						 
						</div>
						  
						  
						  
						  
						  
						  
						  
						</div>
    				</div>
				</div>
    		</section>
    		
    		
    		
    		
    		
    		
    		
		</div>
	</div>	 
</body>	
</html>



