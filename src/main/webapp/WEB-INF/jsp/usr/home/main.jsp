<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MAIN" />
	
	<%@ include file="../common/head.jsp" %>
	
	<div class="main-background-color">
		<div class="introduce-wrap">
			<h1>쉽고, 빠르고, 가벼운 협업툴</h1>
			<div>간편한 협업을 원한다면</div>
			<c:if test="${rq.getLoginedMemberId() == 0 }">
				<button><a href="/usr/member/login">협업랜드 시작하기</a></button>
			</c:if>
			<c:if test="${rq.getLoginedMemberId() != 0 }">
				<button><a href="/usr/dashboard/dashboard?teamId=${member.teamId }">나의 대시보드 바로가기</a></button>
			</c:if>
		</div>
	</div>
	
	<%@ include file="../common/foot.jsp" %>