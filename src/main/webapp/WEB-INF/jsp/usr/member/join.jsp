<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MEMBER JOIN" />
	
	<%@ include file="../common/head.jsp" %>
	
	<script>
		let validLoginId = '';
		var isUserTaken = false; // 중복 상태를 추적하는 변수
		let isEmailChecked = false; // 이메일 중복 체크 여부
		
		$(document).ready(function(){
			  
			  
			  // 비밀번호 유효성 검사
			  $('#loginPw').on('input', function(){
			    var userPw = $(this).val();
				// 비밀번호 유효성 검사를 위한 정규 표현식
		        var pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/;
			    

		        if (!pwRegex.test(userPw)) {
		            $('#loginPw-result').text('비밀번호는 8~20자 영문, 숫자, 특수문자로 설정해야 합니다.');
// 		            $('#submit-button').prop('disabled', true);
		            isUserTaken = true;
		            
		        } else {
		            $('#loginPw-result').hide();
// 		            $('#submit-button').prop('disabled', false);
		            isUserTaken = false;
		        }
			    
		        
			  });

			// 폼 제출 핸들러
				$('#registrationForm').on('submit', function(e){
					if (isUserTaken) {
						alert('사용할 수 없는 비밀번호입니다. 다른 비밀번호를 입력해 주세요.');
						$('#loginPw').focus(); // 포커스 설정
						e.preventDefault(); // 폼 제출 막기
					} else if (!isEmailChecked || validLoginId === '') {
						alert('이메일 중복 검사를 완료해 주세요.');
						$('#loginId').focus(); // 포커스 설정
						e.preventDefault(); // 폼 제출 막기
					} else if (validLoginId !== $('#loginId').val().trim()) {
						alert('이메일이 중복됩니다. 다른 이메일을 입력해 주세요.');
						$('#loginId').focus(); // 포커스 설정
						e.preventDefault(); // 폼 제출 막기
					} else {
						joinForm_onSubmit(this);
						e.preventDefault(); // Ensure form isn't submitted before validation is complete
					}
				});
			  
			  //#profilePhotoInput 아이디를 가진 HTML 요소에 대한 변경 사건(change event)을 감지 
			  //이는 사용자가 파일 입력 필드에 파일을 선택할 때 발생. 사용자가 파일을 선택하면, 이 코드 블록 안의 함수가 실행.
			  $('#profilePhotoInput').change(function(event) {
			        var reader = new FileReader();
			        // 파일 읽기 작업이 성공적으로 완료되면 이 함수가 호출
			        reader.onload = function(e) {
			            $('#profilePhotoPreview').attr('src', e.target.result);
			        };
			        
			        reader.readAsDataURL(event.target.files[0]);
			    });
			    
			    $('.profile-photo-label').click(function() {
			        $('#profilePhotoInput').click();
			    });
			});
		
		

		const joinForm_onSubmit = function(form) {
			form.loginId.value = form.loginId.value.trim();
			form.loginPw.value = form.loginPw.value.trim();
			form.loginPwChk.value = form.loginPwChk.value.trim();
			form.teamName.value = form.teamName.value.trim();
			form.name.value = form.name.value.trim();
			form.cellphoneNum.value = form.cellphoneNum.value.trim();
			
			if (form.loginId.value.length == 0) {
				alert('이메일을 입력해주세요');
				form.loginId.focus();
				return;
			}
			
// 			if (form.loginId.value != validLoginId) {
// 				alert(form.loginId.value + '은(는) 사용할 수 없는 이메일입니다');
// 				form.loginId.value = '';
// 				form.loginId.focus();
// 				return;
// 			}

// 			if (!isEmailChecked) {
// 				alert('이메일 중복 검사를 완료해 주세요');
// 				form.loginId.focus();
// 				return;
// 			}
			
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
			
			if (form.teamName.value.length == 0) {
				alert('팀 이름을 입력해주세요');
				form.teamName.value = '';
				form.teamName.focus();
				return;
			}
			
			if (form.cellphoneNum.value.length == 0) {
				alert('전화번호를 입력해주세요');
				form.cellphoneNum.focus();
				return;
			}

			form.submit();
		}
		
		const loginIdDupChk = function() {
	        let el = $('#loginId')[0];
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
	                    loginIdDupChkMsg.html(`<span>\${data.msg}\</span>`);
	                    validLoginId = el.value;
	                    isEmailChecked = true;

	                } else {
	                    loginIdDupChkMsg.removeClass('text-green-500');
	                    loginIdDupChkMsg.addClass('text-red-500');
	                    loginIdDupChkMsg.html(`<span>\${data.msg}\</span>`);
	                    validLoginId = '';
	                }
	                
	            },
	            error: function(xhr, status, error) {
	                console.error("ERROR : " + status + " - " + error);
	            }
	        });
	    }
	</script>
	
	<section class="mt-24 text-xl">
		<div class="join-box">
			<h1>회원가입</h1>
			<form id="registrationForm" action="doJoin" method="post" enctype="multipart/form-data">
				
				<label for="profilePhotoInput" class="profile-photo-label">
			        <div class="profile-photo-container">
					    <img src="https://i.namu.wiki/i/JY_fQfNyNBg4YeiWvstXPThRcS2dXl3wx_TwMbgT54u6AEDgoVOxFNP-zV9midwZvQn6fUAW1nz-_L9NmV9HRee3AWSjQE1kspjLzyxMc4ZASNZr81IOkVNtm3OZR71-2i9pQWsZGN8DS7oFeY0nHA.webp" id="profilePhotoPreview" alt="" />
					    <div class="profile-photo-text">프로필 사진</div>
					</div>
			        <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/*" style="display: none;">
			    </label>

				<div class="pb-2 font-medium">이름</div>
				<input class="input input-bordered input-primary w-full" name="name" type="text" placeholder="이름"/>
				<div class="space-box h-7"></div>
				
				<div class="pb-2 font-medium">닉네임</div>
				<input class="input input-bordered input-primary w-full" name="nickname" type="text" placeholder="이름"/>
				<div class="space-box h-7"></div>
				
				<div class="pb-2 font-medium">팀 이름 (회사 또는 단체명)</div>
				<input class="input input-bordered input-primary w-full" name="teamName" type="text" placeholder="팀 이름 (회사 또는 단체명)"/>
				<div class="space-box h-7"></div>
				
				<div class="pb-2 font-medium">전화번호</div>
				<input class="input input-bordered input-primary w-full" name="cellphoneNum" type="text" placeholder="전화번호"/>
				<div class="space-box h-7"></div>
				
				<div class="pb-2 font-medium">이메일</div>
                <div class="flex">
                    <input class="input input-bordered input-primary w-full" id="loginId" name="loginId" type="text" placeholder="이메일"/>
                    <button type="button" class="" onclick="loginIdDupChk()">중복 검사</button>
                </div>
                <span id="loginIdDupChkMsg" class="text-sm"></span>
                <div class="space-box h-7"></div>
				
				<div class="pb-2 font-medium">비밀번호</div>
				<input class="input input-bordered input-primary w-full" id="loginPw" name="loginPw" type="text" placeholder="비밀번호" />
				<small id="passwordHelp" class="form-text text-muted hidden">비밀번호는 8~20자 영문, 숫자, 특수문자로만 설정해주세요.</small>
				<span class="text-sm text-red-400" id="loginPw-result"></span>
				
				<div class="space-box h-7"></div>
				<input class="input input-bordered input-primary w-full" name="loginPwChk" type="text" placeholder="비밀번호 확인" />
				<button id="submit-button">회원가입</button>
			</form>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>