<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<%@ include file="../common/head2.jsp" %>
	 
<!DOCTYPE html>
<html lang="en" >
<head>
<link rel="stylesheet" href="/resource/cards/dist/style.css" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<link rel="stylesheet" href="/resource/project/detail.css" />
<link rel="stylesheet" href="/resource/dist/style.css" />
<link rel="stylesheet" href="/resource/dashboard/dashboard.css" />
</head>


<!--   <meta charset="UTF-8"> -->
<!--   <link rel="stylesheet" href="./style.css"> -->
<!--   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css"> -->

<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->





<script>
$(document).ready(function() {
	
	
	$("#submitBtn").click(function(){
		
		// 초대 메일 전송     	    	
	var email = $("#exampleFormControlInput1").val();
	var teamId = '1';
	
	$.ajax({
	    url: '../member/doInvite',
	    type: 'POST',
	    data: { teamId: teamId, email: email },
	    success: function(data) {
	      console.log(data);
// 	      $("#email").val("");
	      $('.layer-bg').hide();
		  $('.layer').hide();
		  
	    }
	  });
	});
	
	// 채팅방 리스트에서 채팅방 클릭하면 
	$('.chat-btn').click(function() {
  	  var memberId = $(this).data('member-id');
 		  // 채팅방 URL에 memberId를 쿼리 파라미터로 추가
 		  var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
 		  // 새 창(팝업)으로 채팅방 열기
 		  window.open(chatWindowUrl, '_blank', 'width=500,height=700');
  	});
	
	 // 아코디언 버튼 클릭 이벤트
    $('.project-menu-accordion-button').click(function() {
        // 프로젝트 목록 토글
        $('.left-menu-project-list').slideToggle();

        // 아이콘 변경
        var icon = $(this).find('i');
        if (icon.hasClass('fa-chevron-down')) {
            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
        } else {
            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
        }
    });
	
    $('.chat-menu-accordion-button').click(function() {
        // 프로젝트 목록 토글
        $('.left-menu-chat-list').slideToggle();

        // 아이콘 변경
        var icon = $(this).find('i');
        if (icon.hasClass('fa-chevron-down')) {
            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
        } else {
            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
        }
    });
	
		
	
	
});

function detailModal(memberId) {
	console.log(memberId);
	
	var memberName = $(this).text();
	   var $memberDetails = $('#member-details');
	   
	   $('.chat-btn').data('member-id', memberId);
	   
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




<body>
<div class="task-manager">
	<div class="left-bar flex flex-col">
	    <div class="upper-part">
	      <div class="actions">
	        <div class="circle"></div>
	        <div class="circle-2"></div>
	      </div>
	    </div>
	    <div class="left-content">
	      <ul class="action-list flex flex-col">
	       	<div>
		       	<a href="../project/make?teamId=${teamId }" class="self-center block">
		        	<button class="new-project-btn">새 프로젝트</button>
		        </a>
	        </div>
	        <li class="item mt-8">
	          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
	            stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-inbox"
	            viewBox="0 0 24 24">
	            <path d="M22 12h-6l-2 3h-4l-2-3H2" />
	            <path
	              d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z" />
	          </svg>
	          
	          <a href="../dashboard/dashboard?teamId=${teamId }" class="text-blue-500 font-bold">
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
	          <a href="../dashboard/myProject?teamId=${teamId }">
	          	<span>내 프로젝트</span>
	          </a>
	        </li>        
	      </ul>
	      <ul class="menu-accordion-group">
	          <li class="menu-accordion-button project-menu-accordion-button">
		          <div class="flex justify-between">
			          <div>프로젝트</div>
			          <div><i class="fa-solid fa-chevron-down"></i></div>
				  </div>	
				  <div class="left-menu-project-list mt-4">
			          <c:forEach items="${projects}" var="project">
		   					<div class="project-list">
			    				<a href="../project/detail?projectId=${project.id}">
									<div>${project.project_name }</div>
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
				  <div class="left-menu-chat-list mt-4">
			          <c:forEach items="${chatRooms}" var="chatRoom">
					    	<div class="member-list flex chat-btn" data-member-id="${chatRoom.recipientId}">
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div>${chatRoom.name}</div>
						    	</div>
					    	</div>
						</c:forEach>
			      </div>
	     	  </li>	
	      </ul>
	      
	    </div>
	    
	    <div class="mt-auto lnb-bottom-customer">
	    	<a href="#" class="">
		    	<i class="fa-regular fa-circle-question self-center mr-3"></i> 
		    	<div>고객센터</div>
	    	</a>
	    </div>
	    
	  </div>
	<div class="page-content">
		<div class="dashboard-container">
	    	<div class="flex">
		    	<div class="dashboard-profile-name">${member.name}님 즐거운 ${amOrPm }입니다😊 </div>
		    	<div class="flex-grow"></div>
		    	<div class="widget-date">${currentDate }요일</div>
	    	</div>
	    	<div class="widget-container flex flex-wrap">
	    		<div class="card-long">
		   			<div class="card-long-header">
		   				<p>내 프로젝트</p>
		   			</div>
		   			<div class="card-long-body flex flex-wrap">
		   				<c:forEach items="${projects}" var="project">
		   					<div class="project-list">
			    				<a href="../project/detail?projectId=${project.id}">
									<div>${project.project_name }</div>
								</a>
							</div>
						</c:forEach>
	   				</div>
	    		</div>
	    		<div class="card-short">
	    			<div class="card-short-header">
	    				<p>구성원</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<div class="member-list flex modal-exam">
	    					<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-solid fa-user-plus"></i></span></div>
	    					<div class="member-list-detail flex flex-col justify-center">
	    						<div class="team-invite">직원 초대</div>
	    					</div>	
	    				</div>
	    				<div class="layer-bg"></div>
						<div class="layer">
							<span id="close" class="close close-btn-x">&times;</span>
							<div>직원초대</div>
							<div>직원들과 협업을 시작해보세요</div>
							
							<input type="email" class="form-control" id="exampleFormControlInput1" placeholder="초대하고싶은 직원의 이메일을 입력해주세요" required />
						    <button id="submitBtn" type="button" class="btn btn-primary">전송하기</button>
						</div>
	    				<c:forEach items="${teamMembers}" var="member">
					    	<div class="member-list flex" onclick="detailModal('${member.id}')">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-regular fa-user"></i></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="font-bold">${member.name}</div>
							    	<div class="text-xs">${member.teamName}</div>
						    	</div>
					    	</div>
						</c:forEach>
						
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
	    		<div class="card-long">
		   			<div class="card-long-header">
		   				<p>내가 담당중인 업무</p>
		   			</div>
		   			<div class="card-long-body flex flex-wrap">
		   				<c:forEach items="${taggedArticles}" var="taggedArticle">
		   					<div class="project-list">
									<div>${taggedArticle.title }</div>
							</div>
						</c:forEach>
	   				</div>
	    		</div>
	    		<div class="card-short">
	    			<div class="card-short-header">
	    				<p>채팅 방</p>
	    			</div>
	    			<div class="card-short-body overflow-y-auto">
	    				<c:forEach items="${chatRooms}" var="chatRoom">
					    	<div class="member-list flex chat-btn" data-member-id="${chatRoom.recipientId}">
						    	<div class="member-icon-wrap"><span class="member-icon flex justify-center items-center"><i class="fa-regular fa-user"></i></span></div>
						    	<div class="member-list-detail flex flex-col justify-center">
							    	<div class="font-bold">${chatRoom.name}</div>
						    	</div>
					    	</div>
						</c:forEach>
	    			</div>
	    		</div>
			</div>
		</div>
	</div>  
</div>
  
</body>
</html>
