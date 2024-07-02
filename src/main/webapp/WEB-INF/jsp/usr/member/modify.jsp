<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="MEMBER MODIFY" />
	
	<%@ include file="../common/head.jsp" %>
	
	<script>
	    $(document).ready(function(){
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
	    });
		const memberModifyForm_onSubmit = function(form) {
			form.name.value = form.name.value.trim();
			form.nickname.value = form.nickname.value.trim();
			form.cellphoneNum.value = form.cellphoneNum.value.trim();
			form.email.value = form.email.value.trim();
			
			if (form.name.value.length == 0) {
				alert('이름을 입력해주세요');
				form.name.focus();
				return;
			}
			
			if (form.nickname.value.length == 0) {
				alert('닉네임을 입력해주세요');
				form.nickname.focus();
				return;
			}
			
			if (form.cellphoneNum.value.length == 0) {
				alert('전화번호를 입력해주세요');
				form.cellphoneNum.focus();
				return;
			}
			
			if (form.email.value.length == 0) {
				alert('이메일을 입력해주세요');
				form.email.focus();
				return;
			}
			
			form.submit();
		}
	</script>
	
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<form action="doModify" method="post" enctype="multipart/form-data" onsubmit="memberModifyForm_onSubmit(this); return false;">
				<input type="hidden" name="existingProfilePhoto" value="${member.profilePhotoPath}" />
				<label for="profilePhotoInput" class="profile-photo-label">
			        <div class="profile-photo-container">
					    <img src="/profile-photo/${member.id}" id="profilePhotoPreview" alt="" />
					    <div class="profile-photo-text">프로필 사진</div>
					</div>
			        <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/*" style="display: none;">
			    </label>
				<div class="table-box-type">
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
							<td><input class="input input-bordered input-primary w-9/12" name="name" type="text" value="${member.name }" placeholder="이름을 입력해주세요" /></td>
						</tr>
						<tr>
							<th>닉네임</th>
							<td><input class="input input-bordered input-primary w-9/12" name="nickname" type="text" value="${member.nickname }" placeholder="닉네임을 입력해주세요" /></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td><input class="input input-bordered input-primary w-9/12" name="cellphoneNum" type="text" value="${member.cellphoneNum }" placeholder="전화번호를 입력해주세요" /></td>
						</tr>
						<tr>
							<td class="text-center" colspan="2"><button class="btn-text-color btn btn-wide btn-outline">수정</button></td>
						</tr>
					</table>
				</div>
			</form>
			<div class="btns mt-2">
				<div class="flex justify-between">
					<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
					<a class="btn-text-color btn btn-outline btn-sm" href="passwordModify">비밀번호변경</a>
				</div>
			</div>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>