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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-autocomplete/1.0.7/jquery.auto-complete.min.js"></script>
  <title>${project.project_name }</title>
<!--chart.js -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>

</head>
<!-- partial:index.partial.html -->
<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->
<body>
	<script>
	$(document).ready(function() {
		var status = "요청"; // Default status 
		$(".status-btn-write[data-status='요청']").addClass("active"); // '요청' 버튼에 'active' 클래스를 추가합니다.
		
		var projectId = ${project.id};
		
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
	    		// 파일 입력 필드들을 제거합니다.
	    	    $('.file_list .file_input:not(:first)').remove();
	    	    // 기본 파일 입력 필드를 초기화합니다.
	    	    $('.file_list .file_input:first input[type="file"]').val('');
	    	    $('.file_list .file_input:first input[type="text"]').val('');
	    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
	    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
	    	})

	    	$('.layer-bg').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    		$('.layer-memeber-detail').hide();
	    		// 회색바탕 눌러서 끄면 안에 내용 빈칸으로 초기화
	    		$('.tag').remove();
	    		$('#exampleFormControlInput1').val('');
	    		$('#exampleFormControlTextarea1').val('');
	    		// 파일 입력 필드들을 제거합니다.
	    	    $('.file_list .file_input:not(:first)').remove();
	    	    // 기본 파일 입력 필드를 초기화합니다.
	    	    $('.file_list .file_input:first input[type="file"]').val('');
	    	    $('.file_list .file_input:first input[type="text"]').val('');
	    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
	    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
	    	})
	    	
//  		글쓰기	     	    	
	    	$("#submitBtn").click(function(){
	    	var selectedGroupId = parseInt($('#groupSelect').val());
	    	if (!selectedGroupId) {
	            // 아무 것도 선택되지 않았다면 '그룹 미지정' 그룹의 ID 설정
	            $('#groupSelect').val('그룹 미지정');
	        }
		    var title = $("#exampleFormControlInput1").val();
		    var content = $("#exampleFormControlTextarea1").val();
		    
		    
		 // 시작일과 마감일을 가져옵니다.
		    var startDate = $("#start-date").val();
		    var endDate = $("#end-date").val();
		    
		    
		 // 태그에 있는 모든 담당자를 배열로 가져옵니다.
		    var managers = $('.tag').map(function() {
		  // 'x' 버튼을 제외한 텍스트만 반환합니다.
		        return $(this).clone().children().remove().end().text();
		    }).get();
		 
		 
		    var formData = new FormData();
		 
		 // 기존 폼 데이터를 FormData 객체에 추가
		    formData.append('title', title);
		    formData.append('content', content);
		    formData.append('status', status); // status 변수가 정의되어 있어야 합니다.
		    formData.append('projectId', projectId); // projectId 변수가 정의되어 있어야 합니다.
		    formData.append('selectedGroupId', selectedGroupId);
		    formData.append('startDate', startDate);
		    formData.append('endDate', endDate);
		    
		    // 담당자 정보를 FormData 객체에 추가
		    $.each(managers, function(i, manager) {
		        formData.append('managers[]', manager);
		    });
		    
		 // 파일 데이터 추가
		    $('.file_input input[type="file"]').each(function(index, element) {
		        if (element.files.length > 0) {
		            // 'files[]'를 사용하여 서버에 배열로 전송
		            formData.append('fileRequests[]', element.files[0]);
		        }
		    });
		 	
		    $.ajax({
		        url: '../article/doWrite',
		        type: 'POST',
		        data: formData,
		        contentType: false, // 필수: 폼 데이터의 인코딩 타입을 multipart/form-data로 설정
		        processData: false, // 필수: FormData를 사용할 때는 processData를 false로 설정
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
	      
	     
			 $("#search").autocomplete({
			    source: function(request, response) {
			        $.ajax({
			            url: "../project/getMembers",
			            type: "GET",
			            data: { term: request.term },
			            success: function(data) {
			            	console.log("클릭1");
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
			
			        var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
			        $('#tag-contianer').prepend(tag);
			
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



//			상태 chart.js
			$.ajax({
		    url: '../article/getArticleCountsByStatus',
		    type: 'GET',
		    data: { 'projectId': projectId },
		    success: function(data) {
		        var labels = data.map(function(item) {
		            return item.status;
		        });
		        var counts = data.map(function(item) {
		            return item.count;
		        });

		        var ctx = document.getElementById('donutChart').getContext('2d');
		        var chartData = {
		            labels: labels,
		            datasets: [{
		                data: counts,
		                backgroundColor: [
		                    'rgba(255, 99, 132, 0.2)',
		                    'rgba(54, 162, 235, 0.2)',
		                    'rgba(255, 206, 86, 0.2)',
		                    'rgba(75, 192, 192, 0.2)',
		                    'rgba(153, 102, 255, 0.2)'
		                ],
		                borderColor: [
		                    'rgba(255, 99, 132, 1)',
		                    'rgba(54, 162, 235, 1)',
		                    'rgba(255, 206, 86, 1)',
		                    'rgba(75, 192, 192, 1)',
		                    'rgba(153, 102, 255, 1)'
		                ],
		                borderWidth: 1
		            }]
		        };
		
		        var options = {
		            responsive: true,
		            cutout: '80%'
		        };
		
		        var myChart = new Chart(ctx, {
		            type: 'doughnut',
		            data: chartData,
		            options: options
		        });
		
		
				var totalCount = counts.reduce(function(acc, val) {
					return acc + val;
				}, 0);
				
				var $infoContainer = $('#infoContainer'); // 정보를 표시할 컨테이너 가져오기
				$.each(data, function(i, item) {
					var percentage = ((item.count / totalCount) * 100).toFixed(0); // 각 항목의 비율 계산
					var $infoElement = $('<p>'); // 각 항목에 대한 정보를 표시할 요소를 생성
					$infoElement.text(item.status + ': ' + item.count + ' (' + percentage + '%)'); // 요소의 내용을 설정
					$infoContainer.append($infoElement); // 요소를 컨테이너에 추가
				});
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		        console.log(textStatus, errorThrown);
		    }
		});
		


// 			function inviteProjectMember(memberId) {
// 				console.log("작동");
// 		        var projectId = ${projectId}; // 현재 페이지의 프로젝트 ID
// 		        $.ajax({
// 		            url: '../project/inviteProjectMember',
// 		            method: 'POST',
// 		            data: { memberId: memberId, projectId: projectId },
// 		            success: function(response) {
// 		                alert('팀원이 초대되었습니다.');
// 		            },
// 		            error: function(err) {
// 		                alert('초대에 실패했습니다.');
// 		            }
// 		        });
// 		    }

			// invite-btn 클래스를 가진 버튼에 대해 클릭 이벤트 리스너를 바인딩
		    $('.invite-btn').on('click', function() {
		        var memberId = $(this).data('member-id');
		        var projectId = ${projectId}; // 현재 페이지의 프로젝트 ID
		        // AJAX 요청을 통해 서버에 memberId와 projectId를 전송합니다.
		        $.ajax({
		            url: '../project/inviteProjectMember',
		            method: 'POST',
		            data: { memberId: memberId, projectId: projectId },
		            success: function(data) {
						if (data.resultCode === "F-1") {
				            alert(data.msg);
				        } else {
				            // 초대 성공 후, 멤버를 목록에서 제거
				            alert('팀원이 프로젝트에 초대되었습니다.');
				            location.reload();
				        }
		            },
		            error: function(err) {
		                alert('초대에 실패했습니다.');
		            }
		        });
		    });
			
			
		    $('.chat-btn').click(function() {
		    	  var memberId = $(this).data('member-id');
		   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
		   		  var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
		   		  // 새 창(팝업)으로 채팅방 열기
		   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
		   		  $('#member-modal').hide();
		    	});



		    
		    
		    $('.article-content').each(function() {
		        var $content = $(this);
		        var $summary = $content.find('.content-summary');
		        var $fullContent = $content.find('.content-full');
		        var $moreBtn = $content.find('.more-btn');
		        
		        // 5줄 이상일 경우 더보기 버튼을 표시하고, 5줄 미만이면 숨깁니다.
		        // 이를 위해 CSS에서 설정한 line-height와 비교합니다.
		        var lineHeight = parseInt($summary.css('line-height'));
		        var contentHeight = $summary[0].scrollHeight;
		        var maxLines = 5;

		        if (contentHeight > lineHeight * maxLines) {
		          // 내용이 5줄 이상이면 '더보기' 버튼을 표시합니다.
		          $moreBtn.show();
		        } else {
		          // 5줄 미만이면 '더보기' 버튼을 숨깁니다.
		          $moreBtn.hide();
		        }
		      });

		      $('.more-btn').click(function() {
		        var $this = $(this);
		        var $content = $this.closest('.article-content');
		        var $summary = $content.find('.content-summary');
		        var $fullContent = $content.find('.content-full');
		        
		        $summary.toggleClass('hidden');
		        $fullContent.toggleClass('hidden');
		        
		        $this.text($fullContent.hasClass('hidden') ? '더보기' : '접기');
		      });

		    


		 // 멤버 이름 클릭 이벤트
		    $('.participants-container').on('click', '.participant div[id^=member-]', function() {
		    	
		      var memberId = $(this).data('member-id');
		      var memberName = $(this).text();
		      var $memberDetails = $('#member-details');
		      
		      $('.chat-btn').data('member-id', memberId);
		      
		   // AJAX 요청을 통해 멤버의 세부 정보를 가져옵니다.
		      $.ajax({
		        url: '../member/getMemberDetails', 
		        type: 'GET',
		        data: { memberId: memberId }, // 요청과 함께 서버로 보낼 데이터
		        dataType: 'json', // 서버로부터 기대하는 응답의 데이터 타입
		        success: function(data) {
		          // 성공 시, 응답 데이터로 모달의 내용을 채웁니다.
		          $memberDetails.html('<p>이름: ' + data.name + '</p>' +
		                              '<p>이메일: ' + data.email + '</p>' +
		                              '<p>전화번호: ' + data.cellphoneNum + '</p>'
		                              );
		          // 모달 창 표시.
		          $('#member-modal').fadeIn();
		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		          // 오류 처리
		          console.error('AJAX 요청에 실패했습니다: ' + textStatus, errorThrown);
		        }
		      });
		    });


		    // 모달 닫기 버튼
		    $('.close').click(function() {
		      $('#member-modal').fadeOut();
		    });

		    // 모달 외부 클릭 시 모달 숨기기
		    $(window).click(function(event) {
		      if ($(event.target).hasClass('modal')) {
		        $('#member-modal').fadeOut();
		      }
		    });	

		    $('.group-chat-btn').click(function() {
		    	  var groupChatRoomProjectId = $(this).data('groupChatRoomProjectId');
		    	  console.log(groupChatRoomProjectId);
		   		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
		   		  var chatWindowUrl = '/usr/home/groupChat?groupChatRoomProjectId=' + encodeURIComponent(groupChatRoomProjectId);
		   		  // 새 창(팝업)으로 채팅방 열기
		   		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
		    	});
		    

	});

	
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
		<div class="page-content bg-red-100 p-0 overflow-auto relative">
  		  <div class="h-20 bg-gray-100 detail-header">
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
    				<li><a class="block" href="">파일</a></li>
    				<li><a class="block" href="">알림</a></li>
    			</ul>
    		</nav>
    		<div class="project-detail-content pt-5 flex">
    		<section class="project-detail-container overflow-auto">
				<div class="detail-wrap mx-auto flex">
    				<div class="postTimeline">
    					<div class="reportArea">
    					<h1>업무 리포트</h1>
    					<div class="flex">
							<div style="width: 250px;">
								<!--차트가 그려질 부분-->
								<canvas id="donutChart"></canvas>
							</div>
							<div id="infoContainer" class="pl-5"></div>
						</div>


    					</div>
						<!-- 모달창 -->
						<div class="layer-bg"></div>
						<div class="layer">
							
							<span id="close" class="close close-btn-x">&times;</span>
							
							
							<div class="flex flex-col">
								<div class="write-modal-body">
									<input type="hidden" id="projectId" value="${project.id }">
		<!-- 							<input type="file" id="fileInput" name="files" multiple> -->
									<div id="status">
								      <button class="status-btn-write btn btn-active" data-status="요청">요청</button>
								      <button class="status-btn-write btn btn-active" data-status="진행">진행</button>
								      <button class="status-btn-write btn btn-active" data-status="피드백">피드백</button>
								      <button class="status-btn-write btn btn-active" data-status="완료">완료</button>
								      <button class="status-btn-write btn btn-active" data-status="보류">보류</button>
								    </div>
										<div id="inputArea">
										  <div id ="tag-contianer"></div>
										  <div class="autocomplete-container flex flex-col">
											  <!-- 기존의 입력 필드 -->
											  <input type="text" class="form-control w-72" id="search" autocomplete="off" placeholder="담당자를 입력해주세요">
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
										
										<div class="file_list">
											<div class="file_input pb-3 flex items-center">
						                        <div> 첨부파일
						                            <input type="file" name="files" onchange="selectFile(this);" />
						                        </div>
						                        <button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>
			                   					<button type="button" onclick="addFile();" class="btns fn_add_btn p-2 border border-gray-400"><span>파일 추가</span></button>
						                    </div>
					                    </div>
									</div>	
								<div class="write-modal-footer flex justify-end">	
							 	   <button id="submitBtn" type="button">제출</button>
							    </div>
						    </div>
						    
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
								    <div class="flex">
									    <div>시작일: ${article.startDate.substring(2, 10)}</div>
									    <div class="ml-4">마감일: ${article.endDate.substring(2, 10)}</div>
								    </div>
								    <div class="article-content">
<%-- 									    <p class="content-summary">${fn:substring(article.contentBr, 0, 100) }</p> --%>
									    <p class="content-summary">${article.contentBr }</p>
									    <p class="content-full hidden">${article.contentBr }</p>
									    <a href="#!" class="more-btn">더보기</a>
								    </div>
									<c:if test="${not empty article.infoFiles}">
										<div class="files">
										    <ul>
										        <c:forEach var="file" items="${article.infoFiles}">
													<li><a href="../file/downloadFile?articleId=${file.article_id }&fileId=${file.id }">${file.original_name}</a></li>
<%-- 													<li><a href="#">${file.original_name}</a></li> --%>
												</c:forEach>
										    </ul>
										</div>
									</c:if>
								  </div>
								</div>
							</c:forEach>
						</div>
					 </div>
				</div>	
			</section>
			<div class="right-detail-content flex flex-col">
						 <div class="participants-section">
							 <div class="participants-container">
							 	<div class="p-3">
								 	<h1>우리 소속 멤버</h1>
									<c:forEach items="${teamMembers}" var="member">
									    <div class="participant flex justify-between">
										    <div id="member-${member.id}" data-member-id="${member.id}">
										        ${member.name}
										    </div>
										    <div>   
										        <!-- 버튼에 클래스와 data- 속성 추가 -->
										        <button class="invite-btn" data-member-id="${member.id}" data-member-name="${member.name}" >초대하기</button>
										        <button class="chat-btn" data-member-id="${member.id}" data-member-name="${member.name}" >채팅하기</button>
										    </div>
									    </div>
									</c:forEach>
									 
									<h1>현재 참여중인 프로젝트 멤버</h1>
									<c:forEach items="${projectMembers}" var="projectMember">
									    <div>
									  		${projectMember.name}
									    </div>
									</c:forEach>
								</div>
								<div class="flex">
									<button class="group-chat-btn p-4 flex-grow text-center w-1/2 border border-red-300" data-group-chat-room-project-id="${projectId}">그룹 채팅</button>
							 		<button class="p-4 flex-grow text-center w-1/2 border border-red-300">화상 회의</button>
						 		</div>
						 		
							 	</div>
						 </div>
						 <div id="member-modal" class="member-modal">
						 	<div class="modal-memberContent">
						 		<span class="close">&times;</span>
						 		<h2>멤버 세부 정보</h2>
						 		<div id="member-details" >
						 		<!--  멤버 정보 -->
						 		</div>
						 		<div class="flex justify-center">
						 			<button class="chat-btn p-4 flex-grow text-center border border-red-300">채팅하기</button>
						 			<a class="p-4 flex-grow text-center border border-red-300" href="#">화상회의</a>
						 		</div>	
						 	</div>
						 </div>
					</div>
			</div>
    	</div>
    	<div class="write-pen modal-exam"><i class="fa-solid fa-pen"></i></div>
    	
    	
    	
	</div>
    		







		

</body>	

</html>