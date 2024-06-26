<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>

<!DOCTYPE html>
<html lang="en" >
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<!--   <link rel="stylesheet" href="/resource/dist/style.css" /> -->
<!--   <link rel="stylesheet" href="/resource/project/detail.css" /> -->
  <link rel="stylesheet" href="/resource/home/home.css" />
  <link rel="stylesheet" href="/resource/project/task.css" />
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
  <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
<!--   웹소켓	 -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
  
  
  <title>${project.project_name }</title>
</head>
<!-- partial:index.partial.html -->
<link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet">



	<script>
	$(document).ready(function() {
		var projectId = $('#favoriteIcon').data('project-id');
		var defaultColumn = 'id';
		var defaultOrder = 'DESC';
		var column = localStorage.getItem('column') || defaultColumn;
		var order = localStorage.getItem('order') || defaultOrder;
			
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
	        url: '../project/getWriteNotifications',
	        type: 'GET',
	        data: { loginedMemberId: ${rq.getLoginedMemberId()} },
	        success: function(notifications) {
	            // 가져온 알림 목록을 페이지에 추가합니다.
	            notifications.forEach(function(notification) {
	            	// 새 알림 카드 HTML 구조 생성
		            const newNotificationCardHtml = `
				    <div class="notification-card">
		            	<div class="notification-project-name">\${notification.projectName}\</div>
				        <div class="notification-project-writername">글쓴이 : \${notification.writerName}\</div>
				        <div class="notification-project-regdate">작성날짜 : \${notification.regDate}\</div>
				        <div class="notification-project-title">제목 : \${notification.title}\</div>
				        <div class="notification-project-content">내용 : \${notification.content}\</div>
				    </div>`;

	                $('.list-notification').prepend(newNotificationCardHtml);
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

		$(document).on('click', '.status-btn-taskupdate', function(event) {
		    event.stopPropagation();
		    $(this).siblings(".status-menu").toggle();
		});

	    $(document).click(function() {
	        $(".status-menu").hide();
	    });
	    
		$(document).on('click', '.status-menu button', function() { //동적으로 생성된 요소에 이벤트 핸들러를 적용하려면, $(document).on(event, selector, function) 형태를 사용
		    var newStatus = $(this).data('status'); // 클릭한 버튼의 상태를 가져오기
		    var articleId = $(this).data('article-id');
		    $.ajax({
		        url: '../article/doUpdateStatus',
		        method: 'POST',
		        data: {
		            'articleId': articleId,
		            'newStatus': newStatus
		        },
		        success: function() {
		            // 요청이 성공하면 상태 버튼의 텍스트를 업데이트하고 상태 리스트를 숨김
		            $(".status[data-article-id=" + articleId + "] .status-btn-taskupdate").text(status);
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
	      var $inputRow = $('<tr class="inputRow"><th colspan="7"><input placeholder="추가할 그룹명을 입력해 주세요." type="text" id="groupNameInput"></th></tr>');
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
	            	//그룹명 입력 창을 제거
// 	            	$("#groupNameInput").parent().parent().remove();
	            	location.reload();
	            },
	            error: function() {
	                alert('그룹 저장에 실패했습니다.');
	            }
	        });
		
	    } 
		
		
		
//		업무 추가 버튼을 누르면		
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
    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
    	})

    	$('.layer-bg').click(function(){
    		$('.layer-bg').hide();
    		$('.layer').hide();
    		// 회색바탕 눌러서 끄면 안에 내용 빈칸으로 초기화
    		$('.tag').remove();
    		$('#exampleFormControlInput1').val('');
    		$('#exampleFormControlTextarea1').val('');
    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
    	})
    	
//       글쓰기
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
		
		
		// 그룹 내의 업무를 보이기/숨기기하는 기능
// 		 $('.toggleTasks').click(function() {
// 			    $(this).closest('tr').nextAll().toggle();
// 			});		
		$(document).on('click', '.toggleTasks', function() { // 동적으로 생성된 요소에 이벤트 핸들러를 적용하려면, $(document).on(event, selector, function) 형태를 사용
		    $(this).closest('tr').nextAll().toggle();
		});		

		//정렬 기능
// 		 $('.sort-btn').click(function() {
// 			    var column = $(this).data('column');
// 			    var order = $(this).data('order');
			    
// 				// 새로고침해도 정렬값이 유지
// 			    localStorage.setItem('column', column);
// 			    localStorage.setItem('order', order);
// 			    window.location.href = '/usr/project/task?column=' + encodeURIComponent(column) + '&order=' + encodeURIComponent(order);

// 			    $.ajax({
// 			        url: "../project/task",
// 			        type: 'GET',
// 			        data: {
// 			            projectId: projectId,
// 			            column: column,
// 			            order: order
// 			        },
// 			        success: function(data) {
// 			        	location.reload();
// 			        	// 테이블 생성
// 			            var table = $('#task-table-1');

// 			            // 기존 tbody 삭제
// 			            table.find('tbody').remove();
						       
// 			            $.each(data, function(group, articles) {
// 			                var tbody = $('<tbody></tbody>');

// 			                // 그룹 이름을 표시하는 행 생성
// 			                var groupRow = $('<tr></tr>');
// 			                groupRow.append('<th class="font-bold" colspan="7">' +
// 			                                '<button class="toggleTasks">▶</button>' + group +
// 			                                '</th>');
// 			                tbody.append(groupRow);
			            
// 			                // 각 아티클을 표시하는 행 생성
// 			                if (articles.length > 0) {
// 			                    $.each(articles, function(index, article) {
// 			                    	console.log(article.id);
// 			                        var row = $('<tr></tr>');
// 			                        row.append('<td>' + article.title + '</td>');
			                        
// 			                     // 상태를 표시하는 부분
// 			                        row.append(`
// 			                            <td class="status relative" data-id="\${article.id}">
// 			                                <button class="status-btn-taskupdate btn btn-active btn-xs btn-block" data-status="\${article.status}">
// 			                                    \${article.status}
// 			                                </button>
// 			                                <div class="status-menu" style="display: none; position: absolute; z-index: 1000;">
// 			                                    <div class="bg-white border border-black border-solid p-3 rounded">
// 			                                        <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="요청" data-article-id="\${article.id}">요청</button>
// 			                                        <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="진행" data-article-id="\${article.id}">진행</button>
// 			                                        <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="피드백" data-article-id="\${article.id}">피드백</button>
// 			                                        <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="완료" data-article-id="\${article.id}">완료</button>
// 			                                        <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="보류" data-article-id="\${article.id}">보류</button>
// 			                                    </div>
// 			                                </div>
// 			                            </td>
// 			                        `);
			                     
// 			                        row.append('<td style="text-align: center;">' + article.taggedNames + '</td>');
// 			                        row.append('<td style="text-align: center;">' + article.startDate.substring(2, 10) + '</td>');
// 			                        row.append('<td style="text-align: center;">' + article.endDate.substring(2, 10) + '</td>');
// 			                        row.append('<td style="text-align: center;">' + article.regDate.substring(2, 10) + '</td>');
// 			                        row.append('<td style="text-align: center;">' + article.id + '</td>');
// 			                        tbody.append(row);
// 			                    });
// 			                } else {
// 			                    // 아티클이 없는 경우
// 			                    var emptyRow = $('<tr></tr>');
// 			                    emptyRow.append('<td colspan="7" style="text-align: center;">작업 내용이 없습니다.</td>');
// 			                    tbody.append(emptyRow);
// 			                }

// 			                // 생성된 tbody를 테이블에 추가
// 			                table.append(tbody);
// 			            });
// 			         } 
// 			    });
// 			 });
		
		$('.sort-btn').on('click', function() {
        var column = $(this).data('column');
        var order = $(this).data('order');
        var table = $('#task-table-1');

        // Find the index of the column to sort
        var columnIndex = -1;
        table.find('th').each(function(index) {
            var thColumn = $(this).find('.sort-btn').data('column');
            if (thColumn === column) {
                columnIndex = index;
                return false; // Break the loop
            }
        });


        if (columnIndex === -1) return; // Column not found

        table.find('tbody').each(function() {
            var tbody = $(this);
            var header = tbody.find('tr:first'); // Group header row
            var rows = tbody.find('tr').not(':first').get(); // Group rows except header


            rows.sort(function(a, b) {
                var A = $(a).children('td').eq(columnIndex).text().trim();
                var B = $(b).children('td').eq(columnIndex).text().trim();

                // Handle date comparison if the column is 'startDate' or 'endDate' or 'regDate'
                if (column === 'startDate' || column === 'endDate' || column === 'regDate') {
                    A = parseDate(A);
                    B = parseDate(B);
                } else if (column === 'id') { // Handle numeric comparison if the column is 'id'
                    A = parseInt(A, 10);
                    B = parseInt(B, 10);
                }


                // Use localeCompare for string comparison, handle numeric comparison for 'id', and date comparison for dates
                return (A < B ? -1 : (A > B ? 1 : 0)) * (order === 'ASC' ? 1 : -1);
            });


            // Clear existing rows and re-append the sorted rows
            tbody.empty();
            tbody.append(header); // Re-add the group header
            $.each(rows, function(index, row) {
                tbody.append(row);
            });
        });

        // Toggle order for next click
        $(this).data('order', order === 'ASC' ? 'DESC' : 'ASC');
    });

    function parseDate(dateString) {
        // Assume the date format is YYYY-MM-DD
        var parts = dateString.split('-');
        return new Date(parts[0], parts[1] - 1, parts[2]);
    }
		
		
		
		
		
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
	     
	     
	        stompClient.subscribe('/queue/writeNotify-' + projectId + ${rq.getLoginedMemberId()}, function(lastPostedArticle) {
	            // 알림 메시지 처리 로직을 여기에 구현합니다.
	        	const writeNotificationMessage = JSON.parse(lastPostedArticle.body);

	            showMessage(writeNotificationMessage.writerName + "님이 새 글을 작성하셨습니다");
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

	
	

	</script>





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
	                            <li><a href="#">내 프로필</a></li>
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
<!-- 		    <div class="lnb-bottom-customer"> -->
<!-- 		        <a href="#" class=""> -->
<!-- 		            <i class="fa-regular fa-circle-question self-center mr-3"></i> -->
<!-- 		            <div>고객센터</div> -->
<!-- 		        </a> -->
<!-- 		    </div> -->
		</div>
		
		
		
		
		
		<div class="page-content">
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

            <div class="flex justify-end p-2">
            	<button class="btn btn-active btn-sm addGroupButton mx-2">그룹 추가</button>
            	<button class="btn btn-active btn-sm modal-exam mx-2">업무 추가</button>
            </div>	
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
            
			<div class="bg-white p-4">
			    <table id="task-table-1" class="table task-table rounded-xl">
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
			                        <td><c:out value="${article.title}"></c:out></td>						
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
    
    
    <div class="rpanel">
		<div class="rpanel-list">
			<div class="list-header">
				<div class="text-lg font-bold">알림 센터</div>
				<span id="close" class="close close-btn-x">&times;</span>
			</div>
			<div class="list-notification">
			</div>
		</div>
	</div>
	
    <div id="messageBox" class="message-box" style="display: none;"></div>  
                
</body>