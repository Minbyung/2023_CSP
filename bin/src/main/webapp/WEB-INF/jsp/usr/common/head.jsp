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
<script src="/resource/common.js" defer="defer"></script>
</head>
<body>
	<div class="top">
		<div class="h-20 flex mx-auto text-4xl nav">
			<div class="brand">
				<a href="/"><span>로고</span></a>
			</div>
			<nav>
				<ul class="flex">
					<li class="hover:underline menu"><a href="/"><span>제품소개</span></a></li>
					<li class="hover:underline menu"><a href="/usr/article/list?boardId=1">요금안내</a></li>
					<li class="hover:underline menu"><a href="/usr/article/list?boardId=2">활용사례</a></li>
					<li class="hover:underline menu"><a href="/usr/article/list?boardId=2">고객지원</a></li>
				</ul>
			</nav>
			<div class="flex-grow"></div>
			<nav>
				<ul class="flex">
					<c:if test="${rq.getLoginedMemberId() == 0 }">
					<li class="hover:underline menu"><a href="/usr/member/login">로그인</a></li>
					</c:if>
					<c:if test="${rq.getLoginedMemberId() != 0 }">
					<li class="hover:underline menu"><a href="/usr/member/doLogout">로그아웃</a></li>
					</c:if>
				</ul>
			</nav>
			
			</div>
	</div>		
	<section class="my-3 text-2xl">
		<div class="container mx-auto px-3">
			<h1>${pageTitle }</h1>
		</div>
	</section>
