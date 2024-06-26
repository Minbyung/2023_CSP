<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>

<!DOCTYPE html>
<html lang="en" >
<head>
  <link rel="stylesheet" href="/resource/project/detail.css" />
  <link rel="stylesheet" href="/resource/home/home.css" />
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-autocomplete/1.0.7/jquery.auto-complete.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stomp-websocket/lib/stomp.min.js"></script>
<!--chart.js -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
  <title>${project.project_name }</title>

</head>
<!-- partial:index.partial.html -->
<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->
<body>
	<script>
	$(document).ready(function() {
		var status = "요청"; // Default status 
		$(".status-btn-write[data-status='요청']").addClass("active"); // '요청' 버튼에 'active' 클래스를 추가합니다.
		
		var projectId = ${project.id};
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${loginedMember.name}';
		
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

	 	    status = $(this).data('status');
	 	  });
	     
// 임시
	     $('.article-update-btn').click(function(){
	    		$('.layer-bg').show();
	    		$('.update-layer').show();
	    		$('.file-list').empty();
	    		var articleId = $(this).data('article-id');
	    		
	    		$.ajax({
			        url: '../article/modify',
			        type: 'GET',
			        data: {"projectId": projectId,
			        	"articleId": articleId 
			        },
			        success: function(data) {
			          console.log(data);
			         // startDate를 YYYY-MM-DD 형식으로 변환
		              var startDate = data.startDate.split(' ')[0];
		              var endDate = data.endDate.split(' ')[0];
		              
			          // taggedNames 필드를 콤마(,)로 분리
					  var taggedNamesArray = data.taggedNames.split(',');
		              // 분리된 값을 각각 요소로 추가
		              $.each(taggedNamesArray, function(index, name) {
		              	  var tag = $('<span class="tag">' + name + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
				          $('#update-tag-container').prepend(tag);
				          tag.find('.tag-remove').on('click', function() {
				          	tag.remove();
				       	  });
		              });
 				      $("#updateBtn").data("article-id", data.id);
					  $("#updateTitle").val(data.title);
 			          $("#updateContent").val(data.content);
		              $("#upadte-start-date").val(startDate);
 				      $("#upadte-end-date").val(endDate);
 				      $('#update-status .status-btn-write').each(function() {
 		                 if ($(this).data('update-status') === data.status) {
 		                    $(this).addClass('active');
 		                    
 		                 }
 		              });
 				      
			        }
			      });
				  // 기존 파일 목록 가져오기
			      $.ajax({
			          url: '../file/findFile',
			          method: 'GET',
			          data: {"projectId": projectId,
				        	"articleId": articleId 
			          },
			          success: function(data) {
			        	  console.log(data)
			              data.forEach(file => {
			                  var fileItem = $('<div class="file-item" data-filename="' + file.original_name + '" data-articleid="' + file.article_id + '" data-projectid="' + file.project_id + '">' + file.original_name + '<button class="file-remove btns del_btn p-2 border border-gray-400">삭제</button></div>');
			                  $('.file-list').prepend(fileItem);
			              });
			          }
			      });
	    	})
	    	
	     $("#updateBtn").click(function(){
	    	 var selectedGroupId = parseInt($('#updateGroupSelect').val());
	    	 var title = $("#updateTitle").val();
	    	 var content = $("#updateContent").val();
	    	 var startDate = $("#upadte-start-date").val();
			 var endDate = $("#upadte-end-date").val();
			 var managers = $('.tag').map(function() {
			 // 'x' 버튼을 제외한 텍스트만 반환합니다.
		        return $(this).clone().children().remove().end().text();
		     }).get();
			 var status = $('#update-status .status-btn-write.active').data('update-status');
			 var articleId = $(this).data('article-id');

			 console.log(selectedGroupId);
			 var formData = new FormData();
			 
			 // 기존 폼 데이터를 FormData 객체에 추가
		     formData.append('title', title);
		     formData.append('content', content);
		     formData.append('status', status); // status 변수가 정의되어 있어야 합니다.
		     formData.append('projectId', projectId); 
		     formData.append('selectedGroupId', selectedGroupId);
		     formData.append('startDate', startDate);
		     formData.append('endDate', endDate);
		     formData.append('articleId', articleId);
		    

		     $.each(managers, function(i, manager) {
		         formData.append('managers[]', manager);
		     });
		    
		  // 파일 데이터 추가
		     $('.file_input input[type="file"]').each(function(index, element) {
		         if (element.files.length > 0) {
		             formData.append('fileRequests[]', element.files[0]);
		         }
		     });
		  
		     $.ajax({
			        url: '../article/doUpdate',
			        type: 'POST',
			        data: formData,
			        contentType: false, 
			        processData: false, 
			        success: function(data) {
// 			          $("#title").val("");
// 			          $("#content").val("");
// 			          $('.tag').remove();
			          $('.layer-bg').hide();
					  $('.layer').hide();
					  location.reload();
			        }
			      });
	    	  
	    	 
	      });	
	      
	     $("#update-search").autocomplete({
				// source 는 자동완성의 대상(배열)
				// request는 현재 입력 필드에 입력된 값(term)을 포함하고 있으며, 이 값을 사용하여 서버에 데이터를 요청할 때 필요한 매개변수로 사용
			    source: function(request, response) {
			        $.ajax({
			            url: "../project/getMembers",
			            type: "GET",
			            data: { term: request.term, "projectId": projectId },
			            success: function(data) {
			            	console.log(data);
			                var taggedMembers = $('#update-tag-container .tag').map(function() {
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
			        $('#update-search').val('');
			
			        var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
			        $('#update-tag-container').prepend(tag);
			
					$('#update-autocomplete-container').prepend($('#update-search'));
					
			        tag.find('.tag-remove').on('click', function() {
			            tag.remove();
			        });
			
			        return false;
			    }
			}).on("focus", function() {
			    $(this).autocomplete("search", " "); 
			});
	     
	     $(document).on('click', '.file-remove', function() {
	    	 var $fileItem = $(this).closest('.file-item');
	    	 var fileName = $fileItem.data('filename');
	    	 var articleId = $fileItem.data('articleid');
	    	 var projectId = $fileItem.data('projectid');
	    	 
	    	 $.ajax({
	    	        url: '../file/deleteFile',
	    	        type: 'POST',
	    	        data: { fileName: fileName, projectId: projectId, articleId: articleId },
	    	        success: function(response) {
	    	        	console.log(response);
	    	            if (response == "S-1") {
	    	                $fileItem.remove();
	    	            } else {
	    	                alert('파일 삭제에 실패했습니다.');
	    	            }
	    	        },
	    	        error: function(err) {
	    	            console.error(err);
	    	            alert('파일 삭제 중 오류가 발생했습니다.');
	    	        }
	    	    });
	     });
	     
	     

		 
	     $('.modal-exam').click(function(){
	    		$('.layer-bg').show();
	    		$('.layer').show();
	    	})

// 	    	$('.close-btn').click(function(){
// 	    		$('.layer-bg').hide();
// 	    		$('.layer').hide();
// 	    	})

	    	$('.close-btn-x').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    		$('.update-layer').hide();
	    		$('.project-invite-modal').hide();
	    		$('.rpanel').hide();
	    		// x버튼으로 끄면 안에 내용 빈칸으로 초기화
	    		$('.tag').remove();
	    		$('#exampleFormControlInput1').val('');
	    		$('#exampleFormControlTextarea1').val('');
	    		// 파일 입력 필드들을 제거합니다.
	    	    $('#file_list .file_input:not(:first)').remove();
	    	    // 기본 파일 입력 필드를 초기화합니다.
	    	    $('#file_list .file_input:first input[type="file"]').val('');
	    	    $('#file_list .file_input:first input[type="text"]').val('');
	    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
	    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
	    	    $('#start-date').val('');
	    	    $('#end-date').val('');
	    	})

	    	$('.layer-bg').click(function(){
	    		$('.layer-bg').hide();
	    		$('.layer').hide();
	    		$('.update-layer').hide();
	    		$('.project-invite-modal').hide();
	    		$('.layer-memeber-detail').hide();
	    		// 회색바탕 눌러서 끄면 안에 내용 빈칸으로 초기화
	    		$('.tag').remove();
	    		$('#exampleFormControlInput1').val('');
	    		$('#exampleFormControlTextarea1').val('');
	    		// 파일 입력 필드들을 제거합니다.
	    	    $('#file_list .file_input:not(:first)').remove();
	    	    // 기본 파일 입력 필드를 초기화합니다.
	    	    $('#file_list .file_input:first input[type="file"]').val('');
	    	    $('#file_list .file_input:first input[type="text"]').val('');
	    		// select 박스의 선택 항목을 '그룹 미지정'으로 변경
	    	    $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
	    	    $('#start-date').val('');
	    	    $('#end-date').val('');
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
		    formData.append('projectId', projectId); 
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
		 	
		 
		    var writeNotification = {
		    		writerId: loginedMemberId,
		    		writerName: loginedMemberName,
		    		title: title,
		    		content: content,
		    		regDate: '${lastPostedArticle.regDate}',
		    		projectName: '${lastPostedArticle.projectName}'
		        };
		 
		 
		    $.ajax({
		        url: '../article/doWrite',
		        type: 'POST',
		        data: formData,
		        contentType: false, // 필수: 폼 데이터의 인코딩 타입을 multipart/form-data로 설정
		        processData: false, // 필수: FormData를 사용할 때는 processData를 false로 설정
		        success: function(data) {
		          stompClient.send("/app/write.notification." + projectId, {}, JSON.stringify(writeNotification));	
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

			$.ajax({
                url: '../article/getArticleCountsByStatus',
                type: 'GET',
                data: { 'projectId': projectId },
                success: function(data) {
                    // 상태와 색상 매핑
                    var statusColors = {
                        '요청': 'rgba(255, 99, 132, 0.2)',
                        '진행': 'rgba(54, 162, 235, 0.2)',
                        '피드백': 'rgba(255, 206, 86, 0.2)',
                        '완료': 'rgba(75, 192, 192, 0.2)',
                        '보류': 'rgba(153, 102, 255, 0.2)'
                    };

                    var borderColors = {
                        '요청': 'rgba(255, 99, 132, 1)',
                        '진행': 'rgba(54, 162, 235, 1)',
                        '피드백': 'rgba(255, 206, 86, 1)',
                        '완료': 'rgba(75, 192, 192, 1)',
                        '보류': 'rgba(153, 102, 255, 1)'
                    };

                    // 데이터를 라벨과 카운트로 분리
                    var labels = data.map(function(item) {
                        return item.status;
                    });
                    var counts = data.map(function(item) {
                        return item.count;
                    });

                    // 상태에 맞는 색상 배열 생성
                    var backgroundColor = labels.map(function(label) {
                        return statusColors[label];
                    });

                    var borderColor = labels.map(function(label) {
                        return borderColors[label];
                    });

                    // 차트 생성
                    var ctx = document.getElementById('donutChart').getContext('2d');
                    var chartData = {
                        labels: labels,
                        datasets: [{
                            data: counts,
                            backgroundColor: backgroundColor,
                            borderColor: borderColor,
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

                 // 데이터 순서 정렬
                    var desiredOrder = ['요청', '진행', '피드백', '완료', '보류'];
                    data.sort(function(a, b) {
                        return desiredOrder.indexOf(a.status) - desiredOrder.indexOf(b.status);
                    });

                    // 정보 표시
                    var totalCount = counts.reduce(function(acc, val) {
                        return acc + val;
                    }, 0);

                    var $infoContainer = $('#infoContainer'); // 정보를 표시할 컨테이너 가져오기
                    $infoContainer.empty(); // 기존 내용을 지움
                    $.each(data, function(i, item) {
                        var percentage = ((item.count / totalCount) * 100).toFixed(0); // 각 항목의 비율 계산
                        var $infoElement = $('<p>'); // 각 항목에 대한 정보를 표시할 요소를 생성
                        $infoElement.text(item.status + ': ' + item.count + ' (' + percentage + '%)'); // 요소의 내용을 설정
                        $infoContainer.append($infoElement); // 요소를 컨테이너에 추가
                    });
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error('Error fetching data:', textStatus, errorThrown);
                }
            });
		

			// invite-btn 클래스를 가진 버튼에 대해 클릭 이벤트 리스너를 바인딩
		    $('.invite-btn').on('click', function(event) {
		    	event.stopPropagation(); // 이벤트 전파 중단

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
		    
		    
		    $('.notification').click(function() {
		    	$('.rpanel').toggle();
		    	$('.notification-badge').hide();
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

		 	$('#project-invite').click(function() {
		 		$('.layer-bg').show();
		 		$('#project-invite-modal').show();
		 	    
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
		 	
		    
		    $('#createMeetingBtn').click(function() {
                var projectId = ${project.id}; // 프로젝트 ID는 예시 값입니다. 실제 값으로 대체 필요
                var topic = $('#meetingTopic').val(); // 사용자가 입력한 토픽 제목
                var duration = $('#meetingDuration').val(); // 사용자가 입력한 회의 길이
                var startTime = $('#meetingStartTime').val(); // 사용자가 입력한 회의 시작시간
                var password = $('#meetingPassword').val(); 
                
                // state 파라미터에 프로젝트 ID와 토픽 제목을 포함
                var state = encodeURIComponent(projectId + ',' + topic + ',' + duration + ',' + startTime + ',' + password);
                console.log(state);
                // Zoom OAuth 인증 URL 구성
                var authUrl = `https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/usr/meeting/zoomApi&state=\${state}`;
//                 var authUrl = `https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/usr/meeting/zoomApi&state=1,\${topic}`;
                
                // 사용자를 Zoom 인증 페이지로 리디렉션
                window.location.href = authUrl;
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

    // 예제를 위해 페이지 로드 시 자동으로 메시지를 보여줍니다.
    
    
    
    
    function detailModal(memberId) {
    	
    	var memberName = $(this).text();
    	   var $memberDetails = $('#member-details');
    	   
    	   $('.chat-btn').data('member-id', memberId);
    	   
    	$.ajax({
           url: '../member/getMemberDetails', 
           type: 'GET',
           data: { memberId: memberId }, // 요청과 함께 서버로 보낼 데이터
           dataType: 'json', // 서버로부터 기대하는 응답의 데이터 타입
           success: function(data) {
        	 console.log(data.id);
             // 성공 시, 응답 데이터로 모달의 내용을 채웁니다.
             $memberDetails.html(`<span class="member-icon flex justify-center items-center profile-photo-container"><img src="/profile-photo/\${data.id}\" alt="Profile Photo" class="profile-photo"></span>` +
            		 			 '<p>이름: ' + data.name + '</p>' +
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
    	
    	 // 모달 닫기 버튼
        $('.close').click(function() {
          $('#member-modal').fadeOut();
        });

     	// 모달 외부 클릭 시 모달 숨기기
        $('.member-modal').click(function() {
            $('.member-modal').fadeOut();
        });
     	
     	// 모달 내부 클릭 시, 이벤트가 상위로 전파되지 않도록 중지
        $('.member-modal .modal-memberContent').click(function(event) {
            event.stopPropagation();
        });
    }


    
</script>
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
    		<div class="project-detail-content">
    		<section class="project-detail-container">
				<div class="detail-wrap">
    				<div class="postTimeline">
    					<div class="search-box">
	    					<form action="../article/search">
	    						<input type="hidden" name="projectId" value="1" />
	    						<input class="search-txt" type="text" name="searchTerm" placeholder="검색어를 입력하세요"/>
	    						<button class="search-btn" type="submit">
	    							<i class="fa-solid fa-magnifying-glass"></i>
	    						</button>
	    					</form>
    					</div>
    				
    					<div class="reportArea">
    					<h1>업무 리포트</h1>
    					<div class="flex">
							<div style="width: 200px;">
								<!--차트가 그려질 부분-->
								<canvas id="donutChart"></canvas>
							</div>
							<div id="infoContainer" class="pl-5"></div>
						</div>


    					</div>
						
						
						<div id="postList">
							<c:forEach var="article" items="${articles }">
								<div class="card shadow-xl z-0">
								  <div class="card-body z-0">
								  	<div class="flex justify-between">
								  		<div class="flex">
									  		<h6 class="card-subtitle text-muted">${article.writerName }</h6>
									  		<h6 class="card-subtitle ml-4 text-muted">${article.regDate }</h6>
								  		</div>
								  		<div>
								  			<a href="/usr/article/detail?id=${article.id}"><i class="fa-solid fa-arrow-right"></i></a>
								  		</div>
								  		
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
									<c:if test="${article.memberId == rq.getLoginedMemberId()}">
								  		<div class="flex justify-end">
								  			<button class="card-subtitle article-update-btn" data-article-id="${article.id}">수정</button>
								  			<a class="card-subtitle ml-4" href="../article/doDelete?id=${article.id }" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;">삭제</a>
								  		</div>
							  		</c:if>
								  </div>
								</div>
							</c:forEach>
						</div>
					 </div>
				</div>	
			</section>
			
			<div class="ml-24">
				<div class="card-short">
    				<div class="card-short-header">
	    				<p>프로젝트 팀원(${projectMembersCnt})</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<c:forEach items="${projectMembers}" var="member">
					    	<div class="member-list flex" onclick="detailModal('${member.id}')">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center profile-photo-container"><img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo"></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="font-bold">
							    		${member.name}
							    		<c:if test="${member.id == rq.getLoginedMemberId()}">(나)</c:if>
							    	</div>
							    	<div class="text-xs">${member.project_name}</div>
						    	</div>
					    	</div>
						</c:forEach>
	    			</div>
	    		</div>
				<div class="card-short">
    				<div class="card-short-header">
	    				<p>팀원(${teamMembersCnt})</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<c:forEach items="${teamMembers}" var="member">
					    	<div class="member-list" onclick="detailModal('${member.id}')">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center profile-photo-container"><img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo"></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="flex justify-between w-48">
							    		<div class="font-bold">
							    			${member.name}
							    			<c:if test="${member.id == rq.getLoginedMemberId()}">(나)</c:if>
							    		</div>
							    		<c:if test="${member.id != rq.getLoginedMemberId()}">
							    			<div class="invite-btn" data-member-id="${member.id}" data-member-name="${member.name}">초대하기</div>
							    		</c:if>
							    	</div>
							    	<div class="text-xs">${member.teamName}</div>
						    	</div>
					    	</div>
						</c:forEach>
	    			</div>
	    		</div>

			</div>
			</div>
    	</div>
    	<div class="write-pen modal-exam">
    		<i class="fa-solid fa-pen"></i>
    		<div class="balloon">글 작성 및 화상 회의 생성</div>
    	
    	</div>
	</div>
    		
    <!-- 모달창 -->
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
							<input type="date" id="start-date" name="start-date">
	
						    <label for="end-date">마감일:</label>
						    <input type="date" id="end-date" name="end-date">		
							  		
							  						  
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
						<div class="mb-3">
						  <label for="exampleFormControlTextarea1" class="form-label h-4">내용</label>
						  <textarea class="form-control h-80" id="exampleFormControlTextarea1" rows="3" placeholder="내용을 입력해주세요" required></textarea>
						</div>
						
						<div class="file_list" id="file_list">
							<div class="file_input pb-3 flex items-center">
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
	
	<div class="update-layer p-10">
		<div class="tabs flex">
	        <button class="tab-btn tab-write" data-for-tab="1">수정</button>
	    </div>

       	<span id="close" class="close close-btn-x">&times;</span>
		<div class="flex flex-col h-full">
			<div class="write-modal-body">
				<input type="hidden" id="projectId" value="${project.id }">
<!-- 							<input type="file" id="fileInput" name="files" multiple> -->
				<div id="update-status" class="mt-4">
			      <button class="status-btn-write btn btn-active" data-update-status="요청">요청</button>
			      <button class="status-btn-write btn btn-active" data-update-status="진행">진행</button>
			      <button class="status-btn-write btn btn-active" data-update-status="피드백">피드백</button>
			      <button class="status-btn-write btn btn-active" data-update-status="완료">완료</button>
			      <button class="status-btn-write btn btn-active" data-update-status="보류">보류</button>
			    </div>
					<div id="inputArea">
					  <div class ="update-tag-container" id="update-tag-container"></div>
					  <div class="autocomplete-container flex flex-col mb-3">
						  <input type="text" class="form-control w-72" id="update-search" autocomplete="off" placeholder="담당자를 입력해주세요">
						  <section id="update-autocomplete-results" style="width:20%;"></section>
					  </div>
					<div class="mb-3">
						<label for="upadte-start-date">시작일:</label>
						<input type="date" id="upadte-start-date" class="start-date" name="start-date">

					    <label for="upadte-end-date">마감일:</label>
					    <input type="date" id="upadte-end-date" class="end-date"  name="end-date">		
						  		
						  						  
						<select id="updateGroupSelect" class="select select-bordered select-xs w-full max-w-xs"">
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
					  <label for="updateTitle" class="form-label">제목</label>
					  <input type="email" class="form-control title" id="updateTitle" placeholder="제목을 입력해주세요" required />
					</div>
					<div class="mb-3">
					  <label for="updateContent" class="form-label h-4">내용</label>
					  <textarea class="form-control h-80 content" id="updateContent" rows="3" placeholder="내용을 입력해주세요" required></textarea>
					</div>
					
					<div class="file_list" id="update-file_list">
						<div class="file-list flex">
						
						</div>
					
						<div class="file_input pb-3 flex items-center">
	                        <div> 첨부파일
	                            <input type="file" name="files" onchange="selectFile(this);" />
	                        </div>
	                        <button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>
                 					<button type="button" onclick="addFile();" class="btns fn_add_btn p-2 border border-gray-400"><span>파일 추가</span></button>
	                    </div>
                    </div>
				</div>	
			<div class="write-modal-footer">	
		 	   <button id="updateBtn" type="button">수정하기</button>
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
	 			<button class="chat-btn p-4 flex-grow text-center border border-red-300">1:1 채팅</button>
	 		</div>	
	 	</div>
	</div>

		
	<div id="messageBox" class="message-box" style="display: none;"></div>



		

</body>	

</html>