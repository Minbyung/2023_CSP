<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MEMBER LOGIN" />
	
	<%@ include file="../common/head.jsp" %>
	
	<script>
		const loginForm_onSubmit = function(form) {
			form.loginId.value = form.loginId.value.trim();
			form.loginPw.value = form.loginPw.value.trim();
			
			if (form.loginId.value.length == 0) {
				alert('아이디를 입력해주세요');
				form.loginId.focus();
				return;
			}
			
			if (form.loginPw.value.length == 0) {
				alert('비밀번호를 입력해주세요');
				form.loginPw.focus();
				return;
			}
			
			form.submit();
		}
	</script>

	<section class="mt-48 text-xl">
		<div class="login-box">
			<h1>로그인</h1>
			<form action="doLogin" method="post" onsubmit="loginForm_onSubmit(this); return false;">
				<input class="input input-bordered input-primary w-full" name="loginId" type="text" placeholder="이메일을 입력해주세요"/>
				<div class="space-box h-7"></div>

				<input class="input input-bordered input-primary w-full" name="loginPw" type="text" placeholder="비밀번호를 입력해주세요" />
			
				<button>로그인</button>

			</form>
			
			<div class="joinus">
				<div class="text-gray-400 mt-12">가제가 처음이신가요?</div>
				<a href="/usr/member/join">
					<button class="mt-12" >회원가입</button>
				</a>
			</div>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>