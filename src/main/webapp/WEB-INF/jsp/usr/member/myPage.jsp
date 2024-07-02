<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MYPAGE" />
	
	<%@ include file="../common/head.jsp" %>
	<link rel="stylesheet" href="/resource/member/myPage.css" />
	
	
	<section class="warp text-xl h-full">
		
		<div class="center-container">
			<div class="container mx-auto">
				<div class="header font-bold text-3xl">마이페이지</div>
				<div class="table-box-type">
					<div class="profile-photo-container"><img src="/profile-photo/${member.id}" alt="Profile Photo" class="profile-photo"></div>
					<table class="table table-lg">
						<tr>
							<th>번호</th>
							<td>${member.id }</td>
						</tr>
						<tr>
							<th>가입일</th>
							<td>${member.regDate.substring(2, 16) }</td>
						</tr>
						<tr>
							<th>정보 수정일</th>
							<td>${member.updateDate.substring(2, 16) }</td>
						</tr>
						<tr>
							<th>아이디</th>
							<td>${member.loginId }</td>
						</tr>
						<tr>
							<th>이름</th>
							<td>${member.name }</td>
						</tr>
						<tr>
							<th>닉네임</th>
							<td>${member.nickname }</td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td>${member.cellphoneNum }</td>
						</tr>
					</table>
				</div>
				
				<div class="btns mt-2">
					<div class="flex justify-between">
						<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
						<div class="flex gap-4">
							<a class="btn-text-color btn btn-outline btn-sm" href="checkPassword?loginId=${member.loginId }&action=modify">회원정보수정</a>
							<a class="btn-text-color btn btn-outline btn-sm" href="checkPassword?loginId=${member.loginId }&action=delete">회원 탈퇴</a>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>