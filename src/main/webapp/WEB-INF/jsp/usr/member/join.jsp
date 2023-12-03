<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MEMBER JOIN" />
	
	<%@ include file="../common/head.jsp" %>
	
	<script>
		let validLoginId = '';
	
		const joinForm_onSubmit = function(form) {
			form.loginId.value = form.loginId.value.trim();
			form.loginPw.value = form.loginPw.value.trim();
			form.loginPwChk.value = form.loginPwChk.value.trim();
			form.name.value = form.name.value.trim();
			form.cellphoneNum.value = form.cellphoneNum.value.trim();
			
			if (form.loginId.value.length == 0) {
				alert('이메일을 입력해주세요');
				form.loginId.focus();
				return;
			}
			
			if (form.loginId.value != validLoginId) {
				alert(form.loginId.value + '은(는) 사용할 수 없는 이메일입니다');
				form.loginId.value = '';
				form.loginId.focus();
				return;
			}
			
			if (form.loginPw.value.length == 0) {
				alert('비밀번호를 입력해주세요');
				form.loginPw.focus();
				return;
			}
			
			if (form.loginPwChk.value.length == 0) {
				alert('비밀번호확인을 입력해주세요');
				form.loginPwChk.focus();
				return;
			}
			
			if (form.loginPw.value != form.loginPwChk.value) {
				alert('비밀번호가 일치하지 않습니다');
				form.loginPw.value = '';
				form.loginPwChk.value = '';
				form.loginPw.focus();
				return;
			}
			
			if (form.name.value.length == 0) {
				alert('이름을 입력해주세요');
				form.name.focus();
				return;
			}
					
			if (form.cellphoneNum.value.length == 0) {
				alert('전화번호를 입력해주세요');
				form.cellphoneNum.focus();
				return;
			}

			form.submit();
		}
		
		const loginIdDupChk = function(el) {
			el.value = el.value.trim();
			
			let loginIdDupChkMsg = $('#loginIdDupChkMsg');
			
			loginIdDupChkMsg.empty();
			
			if (el.value.length == 0) {
				loginIdDupChkMsg.removeClass('text-green-500');
				loginIdDupChkMsg.addClass('text-red-500');
				loginIdDupChkMsg.html('<span>아이디는 필수 입력 정보입니다</span>');
				return;
			}
			
			$.ajax({
				url: "loginIdDupChk",
				method: "get",
				data: {
						"loginId" : el.value
					},
				dataType: "json",
				success: function(data) {
					if (data.success) {
						loginIdDupChkMsg.removeClass('text-red-500');
						loginIdDupChkMsg.addClass('text-green-500');
						loginIdDupChkMsg.html(`<span>\${data.msg}</span>`);
						validLoginId = el.value;
					} else {
						loginIdDupChkMsg.removeClass('text-green-500');
						loginIdDupChkMsg.addClass('text-red-500');
						loginIdDupChkMsg.html(`<span>\${data.msg}</span>`);
						validLoginId = '';
					}
				},
				error: function(xhr, status, error) {
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
		
	</script>
	
	<section class="mt-24 text-xl">
		<div class="join-box">
			<h1>회원가입</h1>
			<form action="doJoin" method="post" onsubmit="joinForm_onSubmit(this); return false;">

				<div class="pb-2 font-medium">이름</div>
				<input class="input input-bordered input-primary w-full" name="name" type="text" placeholder="이름"/>
				<div class="space-box h-7"></div>
				<div class="pb-2 font-medium">팀 이름 (회사 또는 단체명)</div>
				<input class="input input-bordered input-primary w-full" name="teamName" type="text" placeholder="팀 이름 (회사 또는 단체명)"/>
				<div class="space-box h-7"></div>
				<div class="pb-2 font-medium">전화번호</div>
				<input class="input input-bordered input-primary w-full" name="cellphoneNum" type="text" placeholder="전화번호"/>
				<div class="space-box h-7"></div>
				<div class="pb-2 font-medium">이메일</div>
				<input class="input input-bordered input-primary w-full" name="loginId" type="text" placeholder="이메일"/>
				<div class="space-box h-7"></div>
				<div class="pb-2 font-medium">비밀번호</div>
				<div class="text-sm">비밀번호는 8~20자 영문, 숫자, 특수문자로 입력하세요.</div>
				<input class="input input-bordered input-primary w-full" name="loginPw" type="text" placeholder="비밀번호" />
				<div class="space-box h-7"></div>
				<input class="input input-bordered input-primary w-full" name="loginPwChk" type="text" placeholder="비밀번호 확인" />
				<button>회원가입</button>
			</form>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>