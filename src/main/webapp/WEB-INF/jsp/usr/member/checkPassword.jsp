<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="PASSWORD CHECK" />
	
	<%@ include file="../common/head.jsp" %>
	<link rel="stylesheet" href="/resource/member/myPage.css" />
	
	<script>
		const checkPasswordForm_onSubmit = function(form) {
			form.loginPw.value = form.loginPw.value.trim();
			
			if (form.loginPw.value.length == 0) {
				alert('비밀번호를 입력해주세요');
				form.loginPw.focus();
				return;
			}
			
			form.submit();
		}
	</script>
	
	<section class="wrap text-xl h-full flex flex-col">
		<div class="center-container">
			<div class="container mx-auto">
				<div class="header font-bold text-3xl">비밀번호 재확인</div>
				<form action="doCheckPassword" method="post" onsubmit="checkPasswordForm_onSubmit(this); return false;">
					<input type="hidden" name="action" value="${action}">
					<div class="table-box-type">
						<table class="table table-lg">
							<tr>
								<th>아이디</th>
								<td>${loginId }</td>
							</tr>
							<tr>
								<th>비밀번호</th>
								<td><input class="input input-bordered input-primary w-9/12" name="loginPw" type="text" placeholder="비밀번호를 입력해주세요" /></td>
							</tr>
							<tr>
								<td class="text-center" colspan="2"><button class="btn-text-color btn btn-wide btn-outline">확인</button></td>
							</tr>
						</table>
					</div>
				</form>
				
				<div class="btns mt-2">
					<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
				</div>
			</div>
		</div>
	</section>
	
