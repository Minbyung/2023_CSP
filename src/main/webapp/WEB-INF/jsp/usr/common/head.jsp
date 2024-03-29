<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageTitle }</title>
<link rel="shortcut icon" href="/resource/images/favicon.ico" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
<link rel="stylesheet" href="/resource/common.css" />
<link rel="stylesheet" href="/resource/home/home.css" />
<script src="/resource/common.js" defer="defer"></script>
</head>

<script>
	$(document).ready(function() {
		$('.member-detail').click(function(){
			console.log("asd");
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
	});	

</script>

<body>
<!-- 	<div class="top flex flex-col"> -->
<!-- 		<div class="h-20 flex mx-auto text-4xl nav"> -->
<!-- 			<div class="brand"> -->
<!-- 				<a href="/"><span>로고</span></a> -->
<!-- 			</div> -->
<!-- 			<nav> -->
<!-- 				<ul class="flex"> -->
<!-- 					<li class="hover:underline menu"><a href="/"><span>제품소개</span></a></li> -->
<!-- 					<li class="hover:underline menu"><a href="/usr/article/list?boardId=1">요금안내</a></li> -->
<!-- 					<li class="hover:underline menu"><a href="/usr/article/list?boardId=2">활용사례</a></li> -->
<!-- 					<li class="hover:underline menu"><a href="/usr/article/list?boardId=2">고객지원</a></li> -->
<!-- 				</ul> -->
<!-- 			</nav> -->
<!-- 			<div class="flex-grow"></div> -->
<!-- 			<nav> -->
<!-- 				<ul class="flex"> -->
<%-- 					<c:if test="${rq.getLoginedMemberId() == 0 }"> --%>
<!-- 					<li class="hover:underline menu"><a href="/usr/member/login">로그인</a></li> -->
<%-- 					</c:if> --%>
<%-- 					<c:if test="${rq.getLoginedMemberId() != 0 }"> --%>
<!-- 					<li class="hover:underline menu"><a href="/usr/member/doLogout">로그아웃</a></li> -->
<%-- 					</c:if> --%>
<!-- 				</ul> -->
<!-- 			</nav> -->
<!-- 		</div>	 -->
<!-- 	</div>		 -->

	<div class="top-bar">
		<div class="top-bar-container">
			<div>
				<a class="flex items-center h-full" href="/">협업랜드(로고)</a>
			</div>
			<div class="flex-grow"></div>
			<div class="flex member-login-box">
				<c:if test="${rq.getLoginedMemberId() == 0 }">
					<div class="hover:underline"><a class="flex items-center h-full" href="/usr/member/login">로그인</a></div>
				</c:if>
				<c:if test="${rq.getLoginedMemberId() != 0 }">
					<div class="cursor-pointer"><i class="fa-regular fa-bell flex items-center h-full"></i></div>
					<div class="cursor-pointer">
						<div class="flex items-center h-full relative member-detail">
							<img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo">
							${member.name }님
							<ul class="member-detail-menu">
								<li><a href="#">내 프로필</a></li>
								<li><a href="/usr/dashboard/dashboard?teamId=${member.teamId }">내 대시보드</a></li>
								<li><a href="/usr/member/doLogout">로그아웃</a></li>
							</ul>
						</div>
					</div>
					<div class="hover:underline"><a class="flex items-center h-full" href="/usr/member/doLogout">로그아웃</a></div>
				</c:if>
			</div>
		</div>
	</div>



