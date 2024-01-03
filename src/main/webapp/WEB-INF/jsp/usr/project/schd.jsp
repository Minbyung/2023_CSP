<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ include file="../common/head2.jsp" %>    
<!DOCTYPE html>
<html>
<head>
<!--   <meta charset='utf-8' /> -->
<!--   <!-- 화면 해상도에 따라 글자 크기 대응(모바일 대응) --> 
  <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="/resource/dist/style.css" />
  <link rel="stylesheet" href="/resource/project/detail.css" />	
  <!-- fullcalendar CDN -->
  <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
  <!-- fullcalendar 언어 CDN -->
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<!--   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css"> -->
<!-- <!-- 글작성 양식 -->
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  
  
<style>
  /* body 스타일 */
  html, body {
    overflow: hidden;
/*     font-family: Arial, Helvetica Neue, Helvetica, sans-serif; */
/*     font-size: 14px; */
  }
  /* 캘린더 위의 해더 스타일(날짜가 있는 부분) */
  .fc-header-toolbar {
    padding-top: 1em;
    padding-left: 1em;
    padding-right: 1em;
  }
  #calendar-container {
  	padding-left: 30px;
  	padding-right: 30px;
  }
</style>

<script>

	$(document).ready(function() {
		var projectId = ${projectId};
		
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
		
		
		
		
		var calendarEl = $('#calendar')[0]; // 제이쿼리를 사용하여 DOM 요소를 선택
		var calendar = new FullCalendar.Calendar(calendarEl, {
			height: '700px', // calendar 높이 설정
			expandRows: true, // 화면에 맞게 높이 재설정
			// 해더에 표시할 툴바        
			headerToolbar: {
				left: 'prev,next today',
				center: 'title',
				right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
				},
// 			initialDate: '2021-07-15', 설정하지않으면 오늘날짜	
			initialView: 'dayGridMonth', // 초기 뷰 설정
			navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
			editable: true, // 수정 가능?
			eventDurationEditable: true,
			eventResizableFromStart: true,
			eventDrop: function(info) {
				var event = info.event;
				$.ajax({
				      url: '/usr/article/doUpdateDate', // 이벤트 정보를 업데이트하는 서버의 엔드포인트 URL
				      method: 'POST',
				      data: {
				    	articleId: event.id, // 이벤트 ID
				        startDate: event.start.toISOString(), // 변경된 시작 날짜/시간
				        endDate: event.end ? event.end.toISOString() : event.start.toISOString() // 변경된 종료 날짜/시간
				        // 기타 필요한 데이터를 여기에 포함시킬 수 있습니다.
				      },
				      success: function(response) {
				        // 서버에서 성공적으로 처리됐을 때의 로직
				      },
				      error: function() {
				        // 오류 처리
				        info.revert(); // 변경 사항을 되돌립니다.
				      }
				    });
				console.log(info.event.title + "이(가) " + info.event.start + "부터 " + info.event.end + "까지로 이동되었습니다.");
			},
			
			
			selectable: true, // 달력 일자 드래그 설정가능
			nowIndicator: true, // 현재 시간 마크
			dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)        
			locale: 'ko', // 한국어 설정
			select: function(info) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
				$('#start-date').val(info.startStr);
			    $('#end-date').val(info.endStr);
			   
			    showModal();
			},
			// 이벤트 
	        events: function(fetchInfo, successCallback, failureCallback) { 
	        	$.ajax({
	        		url: '/usr/project/getGroupedArticles', // 서버의 API 엔드포인트
	                method: 'GET',
	                dataType: 'json',
	                data: {
	                	projectId: projectId
	                  // 필요한 경우 서버에 전송할 추가 데이터를 여기에 포함시킵니다.
	                  // 예: start: fetchInfo.startStr, end: fetchInfo.endStr
	                },	
	                success: function(data) {
	                	let events = [];
	                	for (let group in data) {
	                		var articles = data[group];
	                	    for (var i = 0; i < articles.length; i++) {
	                            var article = articles[i];
	                            
	                            events.push({
	                                id: article.id,
 	                                title: article.title,
	                                start: article.startDate,
 	                                end: article.endDate
	                            });
	                	    }
	                	}
	                  successCallback(events);
	               },
	       	
	               error: function(xhr, status, error) {
	                   // 오류 처리
	                   failureCallback(error);
	                 }
	        	});
	        } 	
		});
		calendar.render(); // 캘린더 렌더링
		
		// 모달을 표시하는 함수
		function showModal() {
			$(".modal-exam").show();
			$(".layer-bg").show();
			$(".layer").show();
		}
		// 모달을 숨기는 함수
		function hideModal() {
		  $(".modal-exam").hide();
		  $(".layer-bg").hide();
		  $(".layer").hide();
		  $('.tag').remove();
		  $('#exampleFormControlInput1').val('');
	  	  $('#exampleFormControlTextarea1').val('');
	 	  $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
		}
		// 닫기 버튼에 이벤트 리스너를 연결합니다.
		$("#close").on("click", function() {
			hideModal();
		});

		// 초기 상태에서 모달을 숨깁니다.
		hideModal();
		
		
//      글쓰기
		var status = "요청"; // Default status 
		$(".status-btn-write[data-status='요청']").addClass("active");
		
		$(".status-btn-write").click(function(){
	 	    $(".status-btn-write").removeClass("active");
	 	    $(this).addClass("active");

	 	    status = $(this).attr('data-status');
	 	  });

    	$("#submitBtn").click(function(){
    	var selectedGroupId = parseInt($('#groupSelect').val());
    	if (!selectedGroupId) {
            // 아무 것도 선택되지 않았다면 '그룹 미지정' 그룹의 ID 설정
            $('#groupSelect').val('그룹 미지정');
        }
	    var title = $("#exampleFormControlInput1").val();
	    var content = $("#exampleFormControlTextarea1").val();
	    
	 // 시작일과 마감일을 가져오기
	    var startDate = $("#start-date").val();
	    var endDate = $("#end-date").val();
	    
	    console.log(title);
	    console.log(content);
	    console.log(startDate);
	    console.log(endDate);
	    console.log(status);
	    console.log(projectId);
	    console.log(managers);
	    console.log(selectedGroupId);
	    
	    
	 // 태그에 있는 모든 담당자를 배열로 가져오기
	    var managers = $('.tag').map(function() {
	  // 'x' 버튼을 제외한 텍스트만 반환
	        return $(this).clone().children().remove().end().text();
	    }).get();
	 	
	    $.ajax({
	        url: '../article/doWrite',
	        type: 'POST',
	        data: { title: title, content: content, status: status, projectId: projectId, managers: managers, selectedGroupId: selectedGroupId, startDate: startDate, endDate: endDate },
	        success: function(data) {

	          $("#title").val("");
	          $("#content").val("");
	          $('.tag').remove();
	          $('.layer-bg').hide();
			  $('.layer').hide();
			  location.reload();
	        }
	      });
	    });
      
     
		 $("#search").autocomplete({
		    source: function(request, response) {
		        $.ajax({
		            url: "../project/getMembers",
		            type: "GET",
		            data: { term: request.term },
		            success: function(data) {
		                var taggedMembers = $('.tag').map(function() {
		                    return $(this).clone().children().remove().end().text().trim();
		                }).get();
		
		                var results = $.grep(data, function(result){
		                    return $.inArray(result.trim(), taggedMembers) === -1;
		                });
		
		                response(results);
		            },
		            error: function(err) {
		                console.error(err);
		            }
		        });
		    },
		    select: function(event, ui) {
		        var newValue = ui.item.value;
		        $('#search').val('');
		
		        var tag = $('<span class="tag">' + newValue + '<button class="tag-remove btn btn-circle"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
		        $('#inputArea').prepend(tag);
		
		        $('#search').prependTo('.autocomplete-container');
		
		        tag.find('.tag-remove').on('click', function() {
		            tag.remove();
		        });
		
		        return false;
		    }
		}).on("focus", function() {
			// $(this).autocomplete("search", ""); 원래 이렇게 하려했는데 서버에서 처리를 못하고있음
			// request.term은 빈 문자열("")이 되는데, 서버에서 이를 처리하지 못하는 경우 
			// 클라이언트 측에서 빈 문자열 대신 기본 검색어(" ")를 제공 모든 가능한 검색 결과를 반환하는 기본 검색어를 사용
		    $(this).autocomplete("search", " "); 
		});
		
		
		
		
	});

</script>





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
  
  
  
	<div class="modal-exam"><span>글 작성</span></div>
	<div class="layer-bg"></div>
	<div class="layer">
		<span id="close" class="close close-btn-x">&times;</span>
		<input type="hidden" id="projectId" value="${project.id }">
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
	
			<label for="start-date">시작일:</label>
			<input type="date" id="start-date" name="start-date">
	
		    <label class ="bg-red-100" for="end-date">마감일:</label>
		    <input type="date" id="end-date" name="end-date">		
			  		
			  						  
			<select id="groupSelect" class="select w-full max-w-xs">
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
  
  
  
  
  <!-- calendar 태그 -->
  <div id='calendar-container'>
    <div id='calendar'></div>
  </div>


</div>
</div>

</body>
</html>


