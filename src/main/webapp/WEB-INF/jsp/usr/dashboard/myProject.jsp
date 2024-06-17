<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ include file="../common/head.jsp" %>   
	 
<!DOCTYPE html>
<html lang="en" >
<head>
<link rel="stylesheet" href="/resource/cards/dist/style.css" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<!-- <link rel="stylesheet" href="/resource/project/detail.css" /> -->
<!-- <link rel="stylesheet" href="/resource/dist/style.css" /> -->
<link rel="stylesheet" href="/resource/dashboard/dashboard.css" />
<link rel="stylesheet" href="/resource/dashboard/myproject.css" />
</head>


<!--   <meta charset="UTF-8"> -->
<!--   <link rel="stylesheet" href="./style.css"> -->
<!--   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css"> -->

<!-- <link href="https://fonts.googleapis.com/css?family=DM+Sans:400,500,700&display=swap" rel="stylesheet"> -->





<script>




$(document).ready(function() {
	$('.favoriteIcon').each(function() {
	    // this는 현재 순회 중인 '.favoriteIcon' 요소를리킵니다.
	    var $icon = $(this);
   		var projectId = $icon.data('project-id');
	    
	    $.ajax({
		    url: '../favorite/getFavorite',
		    method: 'GET',
		    data: {
		        "projectId": projectId
		    },
		    dataType: "json",
		    // context: $icon을 통해 jQuery AJAX 요청에 this 컨텍스트를 현재 순회 중인 아이콘의 jQuery 객체로 설정
		    // context: $icon은 'AJAX 요청에 대한 응답을 처리할 때는 이 아이콘을 기억해!'라고 jQuery에게 지시하는 거라고 생각
		    context: $icon,
		    success: function(data) {
		   	 if (data) {
		   		 	// success 콜백 내에서 this를 사용해 현재 아이콘에만 클래스를 추가하거나 제거, fas 노란별 
		   			this.addClass('fas').removeClass('far');
		        } 
		   	 else {
		   		 	// far 빈별
		   			this.addClass('far').removeClass('fas');
		        }
		    }
		});
	});
	
	

    $('.favoriteIcon').click(function(e) {
     e.preventDefault(); // a 태그의 기본 이벤트를 방지합니다.	
     
     
     var $icon = $(this); // 현재 클릭한 아이콘
     var projectId = $icon.data('project-id');
     var isFavorite = $icon.hasClass('fas');
     
     
       $.ajax({
           url: '../favorite/updateFavorite',
           method: 'POST',
           data: {
               "projectId": projectId, 
               "isFavorite": !isFavorite 
           },
           success: function(response) {
           	console.log(response);
           	$icon.toggleClass('far fas'); // 현재 클릭된 아이콘만 클래스 토글
         	// AJAX 요청 성공 후 페이지 새로고침
            location.reload();
           }
       });
   });
	
	
	
	
	
	
	
	
	$("#submitBtn").click(function(){
	//초대 메일 전송     	    	
	var email = $("#exampleFormControlInput1").val();
	var teamId = '1';
	
	$.ajax({
	    url: '../member/doInvite',
	    type: 'POST',
	    data: { teamId: teamId, email: email },
	    success: function(data) {
		  $(".invite-email-input").val('');
	      $('.layer-bg').hide();
		  $('.invite-layer').hide();
		  alert("메일 전송이 완료되었습니다.");
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
	
		
	
	
});

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
	<div class="detail-header">
		    <div class="h-full flex justify-end items-center">
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
	    
	    <div class="lnb-bottom-customer">
	        <a href="#" class="">
	            <i class="fa-regular fa-circle-question self-center mr-3"></i>
	            <div>고객센터</div>
	        </a>
	    </div>
	</div>
	<div class="page-content">
		<div class="myproject-container">
	    	<div class="main-content scroll-mask overflow-auto">
	    		<div class="project-home-wrap">
	    			<div class="project-group">
	    			<div class="mb-2.5 text-xl box-shadow">즐겨찾기</div>
	    				<div class="cards">
				    			<c:forEach items="${favoriteProjects}" var="project">
				    				<a href="../project/detail?projectId=${project.id}">
										<article class="information [ card ] bg-gray-50">
											<div class="flex card-detail">
												<div class="card-project-participantsCount">
												<div><i class="fa-solid fa-user-group mr-1"></i>${project.participantsCount}</div>
												<div><i data-project-id="${project.id}" class="far fa-star favoriteIcon"></i></div>
												</div>
												<div class="card-project-name">${project.project_name }</div>
												<div class="card-project-description">
													<div>${project.project_description}</div>
												</div>
											</div>
										</article>
									</a>
								</c:forEach>	
							</div>
	    			
	    			
	    			
					<div class="mt-8 mb-2.5"></div>
	    				<div class="text-xl box-shadow">진행중</div>
		    				<div class="cards">
				    			<c:forEach items="${projects}" var="project">
				    				<a href="../project/detail?projectId=${project.id}">
										<article class="information [ card ] bg-gray-50">
											<div class="flex card-detail">
												<div class="card-project-participantsCount">
												<div><i class="fa-solid fa-user-group mr-1"></i>${project.participantsCount}</div>
												<div><i data-project-id="${project.id}" class="far fa-star favoriteIcon"></i></div>
												</div>
												<div class="card-project-name">${project.project_name }</div>
												<div class="card-project-description">
													<div>${project.project_description}</div>
												</div>
											</div>
										</article>
									</a>
								</c:forEach>	
							</div>
	    			</div>
	    		</div>
	    	</div>
		</div>
	</div>
</div>  
<!-- partial -->
  
</body>
</html>
