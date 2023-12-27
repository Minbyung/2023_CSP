<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
    
<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8' />
  <!-- 화면 해상도에 따라 글자 크기 대응(모바일 대응) -->
  <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <!-- jquery CDN -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <!-- fullcalendar CDN -->
  <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
  <!-- fullcalendar 언어 CDN -->
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<style>
  /* body 스타일 */
  html, body {
    overflow: hidden;
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
    font-size: 14px;
  }
  /* 캘린더 위의 해더 스타일(날짜가 있는 부분) */
  .fc-header-toolbar {
    padding-top: 1em;
    padding-left: 1em;
    padding-right: 1em;
  }
</style>
</head>
<body style="padding:30px;">
  <!-- calendar 태그 -->
  <div id='calendar-container'>
    <div id='calendar'></div>
  </div>
<script>

	$(document).ready(function() {
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
			selectable: true, // 달력 일자 드래그 설정가능
			nowIndicator: true, // 현재 시간 마크
			dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)        
			locale: 'ko', // 한국어 설정
// 			select: function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
// 				var title = prompt('Event Title:');         
// 				if (title) {
// 					calendar.addEvent({              
// 						title: title,              
// 						start: arg.start,             
// 						end: arg.end,              
// 						allDay: arg.allDay            
// 					})          
// 				}          
// 				calendar.unselect();
// 			}
			// 이벤트 
	        events: function(fetchInfo, successCallback, failureCallback) { 
	        	$.ajax({
	        		url: '/usr/project/getGroupedArticles', // 서버의 API 엔드포인트
	                method: 'GET',
	                dataType: 'json',
	                data: {
	                	projectId: 1
	                  // 필요한 경우 서버에 전송할 추가 데이터를 여기에 포함시킵니다.
	                  // 예: start: fetchInfo.startStr, end: fetchInfo.endStr
	                },	
	                success: function(data) {
	                	let events = [];
	                	
	                	for (let group in data) {
	                		var articles = data[group];
	                	
	                	    console.log(articles);
	                	    for (var i = 0; i < articles.length; i++) {
	                            var article = articles[i];
	                            events.push({
	                                id: article.id,
	                                title: article.title,
	                                start: article.startDate,
	                                end: article.endDate,
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
	});

</script>
</body>
</html>


