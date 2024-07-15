<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ include file="../common/head2.jsp" %>    
<%@ include file="../common/toastUiEditorLib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>${project.project_name }</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link rel="stylesheet" href="/resource/project/schd.css" />
  <link rel="stylesheet" href="/resource/home/home.css" />	
  <!-- fullcalendar CDN -->
  <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
  <!-- fullcalendar 언어 CDN -->
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<!--   웹소켓 -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>  
  
<style>
 /* body 스타일 */
 html, body {
   overflow: hidden;
 }
 /* 캘린더 위의 해더 스타일(날짜가 있는 부분) */
 .fc-header-toolbar {
   padding-top: 1em;
   padding-left: 1em;
   padding-right: 1em;
 }
 #calendar-container {
/*  	padding-top: 5px; */
 	padding-left: 30px;
 	padding-right: 30px;
 	padding-bottom: 150px;
 }
</style>

<!-- 새로운 JSP 파일 포함 -->
<jsp:include page="../common/checkCredential.jsp"/>

<script>

	$(document).ready(function() {
		setMinDate();
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
		
		var projectId = ${projectId};
		var status = "요청"; // Default status 
		$(".status-btn-write[data-status='요청']").addClass("active");
		
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
	    	  console.log(groupChatRoomProjectId);
	   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
	   		  var chatWindowUrl = '/usr/home/groupChat?groupChatRoomProjectId=' + encodeURIComponent(groupChatRoomProjectId);
	   		  // 새 창(팝업)으로 채팅방 열기
	   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
	    	});
		    
		    
		    $('.notification').click(function() {
		    	$('.rpanel').toggle();
		    	$('.notification-badge').hide();
		    });
		    
		    $('.close-btn-x').click(function(){
		    	$('.layer-bg').hide();
		    	$('.rpanel').hide();
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
		
		
		var calendarEl = $('#calendar')[0]; // 제이쿼리를 사용하여 DOM 요소를 선택
		
		var projectEvents = [
            <c:forEach var="article" items="${articles}">
                {
                    id: "${article.id}",
                    title: "${article.title}",
                    start: "${article.startDate}",
                    end: "${article.endDate}",
                    color: getColor("${article.status}"),
                    textColor: "#fff",
                    editable: true
                }<c:if test="${!status.last}">,</c:if> // 마지막 JSON배열엔 ","가 없어야함
            </c:forEach>
        ];
		
		var googleEvents = [
            <c:forEach var="event" items="${googleEvents}" varStatus="status">
                {
                    id: "${event.id}",
                    title: "${event.summary}",
                    start: "${event.start.dateTime != null ? event.start.dateTime : event.start.date}",
                    end: "${event.end.dateTime != null ? event.end.dateTime : event.end.date}",
                    extendedProps: {
                        editable: false // Google Calendar 이벤트는 수정 불가
                    }
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
		
		var events = projectEvents.concat(googleEvents);
		
		var calendar = new FullCalendar.Calendar(calendarEl, {
			height: '1000px', // calendar 높이 설정
 			expandRows: true, // 화면에 맞게 높이 재설정
			// 해더에 표시할 툴바        
			headerToolbar: {
				left: 'prev,next today',
				center: 'title',
				right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
				},
			initialView: 'dayGridMonth', // 초기 뷰 설정
			navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
			editable: true, // 수정 가능?
			eventDurationEditable: true,
			eventResizableFromStart: true,
			eventDrop: function(info) {
				var event = info.event;
				if (event.extendedProps.editable === false) {
                    info.revert();
                    return;
                }
                console.log(event.start.toISOString());
                $.ajax({
                    url: '/usr/article/doUpdateDate',
                    method: 'POST',
                    data: {
                        articleId: event.id,
                        startDate: event.start.toISOString(),
                        endDate: event.end ? event.end.toISOString() : event.start.toISOString()
                    },
                    success: function(response) {
                        // 서버에서 성공적으로 처리됐을 때의 로직
                    },
                    error: function() {
                        // 오류 처리
                        info.revert();
                    }
                });
				console.log(info.event.title + "이(가) " + info.event.start + "부터 " + info.event.end + "까지로 이동되었습니다.");
			},
			
// 			eventLimit: true,
			selectable: true, // 달력 일자 드래그 설정가능
			nowIndicator: true, // 현재 시간 마크
			dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)        
			locale: 'ko', // 한국어 설정
			select: function(info) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
				// 종료일이 하루가 더 추가되어서 하루 빼줌
		        var endDate = new Date(info.endStr);
		        endDate.setDate(endDate.getDate() - 1);
		        var endStrAdjusted = endDate.toISOString().split('.')[0];
		        var startStrAdjusted = new Date(info.startStr).toISOString().split('.')[0];
		        $('#start-date').val(startStrAdjusted);
		        $('#end-date').val(endStrAdjusted);
			    showModal();
			},
			// 이벤트 
	        events: events,
	        eventClick: function(info) {
	        	if (info.event.extendedProps.editable === false) {
                    return;
                }
	        	
                var articleId = info.event.id;
                window.location.href = "/usr/article/detail?id=" + articleId;
	        },
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

		const { Editor } = toastui;
	    const { colorSyntax } = Editor.plugin;

	    const editor = new Editor({
		    el: document.querySelector('#editor'),
		    previewStyle: 'vertical',
		    height: '500px',
		    initialEditType: 'wysiwyg',
		    initialValue: '',
		    plugins: [colorSyntax]

	    });
	    		
	 	// 상태 버튼 누를때 활성화
		$(".status-btn-write").click(function(){
	 	    $(".status-btn-write").removeClass("active");
	 	    $(this).addClass("active");
	 	    status = $(this).data('status');
	 	 });

//		글쓰기	     	    	
    	$("#submitBtn").click(function(){
	    	var selectedGroupId = parseInt($('#groupSelect').val());
	    	if (!selectedGroupId) {
	            $('#groupSelect').val('그룹 미지정');
	        }
		    var title = $("#exampleFormControlInput1").val();
		    var content = editor.getHTML(); 
		    var startDate = $("#start-date").val();
		    var endDate = $("#end-date").val();
		    
		    if (!startDate) {
                $('#start-date').val('1000-01-01T00:00:00');
                startDate = $("#start-date").val();
            }

            if (!endDate) {
                $('#end-date').val('1000-01-01T00:00:00');
                endDate = $("#end-date").val();
            }
		    
		    var managers = $('.tag').map(function() {
		        return $(this).clone().children().remove().end().text();
		    }).get();
		 	
		    var formData = new FormData();
		 
		    formData.append('title', title);
		    formData.append('content', content);
		    formData.append('status', status); 
		    formData.append('projectId', projectId); 
		    formData.append('selectedGroupId', selectedGroupId);
		    formData.append('startDate', startDate);
		    formData.append('endDate', endDate);
		    
		    $.each(managers, function(i, manager) {
		        formData.append('managers[]', manager);
		    });
		    
		    $('.file_input input[type="file"]').each(function(index, element) {
		        if (element.files.length > 0) {
		            formData.append('fileRequests[]', element.files[0]);
		        }
		    });
		 	
		    var writeNotification = {
		    		writerId: loginedMemberId,
		    		writerName: loginedMemberName,
		    		title: title,
		    		content: content,
		    		managers: managers // managers 정보를 추가
		        };
		 
		 
		    $.ajax({
		        url: '../article/doWrite',
		        type: 'POST',
		        data: formData,
		        contentType: false, // 필수: 폼 데이터의 인코딩 타입을 multipart/form-data로 설정
		        processData: false, // 필수: FormData를 사용할 때는 processData를 false로 설정
		        success: function(data) {
		          stompClient.send("/app/write.notification." + projectId, {}, JSON.stringify(writeNotification));	
				  location.reload();
		        }
		      });
		    });
	      
	     
		    $("#search").autocomplete({
				// source 는 자동완성의 대상(배열)
				// request는 현재 입력 필드에 입력된 값(term)을 포함하고 있으며, 이 값을 사용하여 서버에 데이터를 요청할 때 필요한 매개변수로 사용
			    source: function(request, response) {
			        $.ajax({
			            url: "../project/getMembers",
			            type: "GET",
			            data: { term: request.term, "projectId": projectId },
			            success: function(data) {
			            	console.log(data);
			                var taggedMembers = $('#tag-container .tag').map(function() {
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
			
			        var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
			        $('#tag-container').prepend(tag);
			
			        $('#search').prependTo('#autocomplete-container');
			
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

			// 달력아이콘과 옆 년월일 눌러도 달력나오게
			    $('#start-date, #end-date').on('click', function() {
			        this.showPicker(); 
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
		    
		 // 글쓰기 탭
		    $(".tab-btn").click(function() {
		        // 모든 탭 내용을 숨깁니다.
		        $(".tab-content").hide();

		        // 모든 탭 버튼에서 'active' 클래스를 제거합니다.
		        $(".tab-btn").removeClass('active active-tab');

		        // 선택된 탭에 'active' 클래스를 추가합니다.
		        $(this).addClass('active active-tab');

		        // data-for-tab 속성 값을 사용하여 해당 탭의 내용을 보여줍니다.
		        var tabId = $(this).data('for-tab');
		        $("#tab-" + tabId).show();
		    });

		    // 기본적으로 첫 번째 탭을 활성화합니다.
		    $(".tab-btn:first").click();
		    
		    $('#helpIcon').hover(
	            function() {
	                $('#tooltip').addClass('show');
	            }, 
	            function() {
	                $('#tooltip').removeClass('show');
	            }
	        );

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
	
	
	
	
	
	
	function selectFile(element) {
        var file = $(element).prop('files')[0];
        var filename = $(element).closest('.file_input').find('input[type="text"]');

        if (!file) {
            filename.val('');
            return false;
        }

        var fileSize = Math.floor(file.size / 1024 / 1024);
        if (fileSize > 10) {
            alert('10MB 이하의 파일로 업로드해 주세요.');
            filename.val('');
            $(element).val('');
            return false;
        }

        filename.val(file.name);
    }
    
	function addFile() {
		console.log("작동");
	    var fileInputHTML =
	        '<div class="file_input pb-3 flex items-center">' +
	        '<div> 첨부파일 ' +
	        '<input type="file" name="files" onchange="selectFile(this); " />' +
	        '</div>' +
	        '<button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>';

	    $('.file_list').append(fileInputHTML);
	}
    
    function removeFile(element) {
        var fileAddBtn = $(element).next('.fn_add_btn');
        if (fileAddBtn.length) {
            var inputs = $(element).prev('.file_input').find('input');
            inputs.val('');
            return false;
        }
        $(element).parent().remove();
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
    
    function getColor(status) {
        switch(status) {
            case '요청':
                return 'rgba(255, 99, 132, 0.8)';
            case '진행':
                return 'rgba(54, 162, 235, 0.8)';
            case '피드백':
                return 'rgba(255, 206, 86, 0.8)';
            case '완료':
                return 'rgba(75, 192, 192, 0.8)';
            case '보류':
                return 'rgba(153, 102, 255, 0.8)';
            default:
                return '#8b00ea';
        }
    }
    
    
    
</script>





</head>
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
    	   <button id="googleCalendarButton" onclick="location.href='/authorize?projectId=${projectId}'">Google Calendar 연동</button>
		  <!--물음표 아이콘 -->
           <div class="relative helpIcon-box">
               <i class="fas fa-question-circle text-2xl cursor-pointer" id="helpIcon"></i>
               <div class="tooltip" id="tooltip">
               		 날짜 칸을 드래그하여 업무 추가를 할 수 있어요.
               		<br>막대를 드래그하여 시작일을 변경할 수 있어요.
               		<br>구글 캘린더와 연동해 일정을 관리해보세요.
               </div>
           </div>
		  
		  <!-- calendar 태그 -->
		  <div id='calendar-container'>
		    <div id='calendar'></div>
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
</html>


