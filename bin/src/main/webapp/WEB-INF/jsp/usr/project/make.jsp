<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<title>프로젝트 생성</title>
	
	<%@ include file="../common/head2.jsp" %>

<body>
	<script>
		const projectForm_onSubmit = function(form) {
			form.project_name.value = form.project_name.value.trim();
			
			if (form.project_name.value.length == 0) {
				alert('프로젝트 제목을 입력해주세요');
				form.loginId.focus();
				return;
			}
			
			form.submit();
		}
	</script>


		<div class="w-4/12 mx-auto mt-8 p-2" style="border: 3px solid #e3e7f7;">
			<div class="mb-10">
				<h1>프로젝트 만들기</h1>
			</div>
			<form action="doMake" method="post" onsubmit="projectForm_onSubmit(this); return false;">
			<div>제목</div>
			<input type="text" placeholder="제목을 입력하세요." name="project_name" class="input input-bordered w-full" />
			<div class="space-box h-7"></div>
			<div>설명</div>
			<input type="text" placeholder="프로젝트에 관한 설명 입력 (옵션)" name="project_description"class="input input-bordered w-full h-36" />
			<div class="flex justify-between mt-8">
				<button class="btn btn-primary" onclick="history.back();">뒤로가기</button>
				<button class="btn btn-primary">프로젝트 생성</button>
			</div>
			</form>
		</div>
</body>

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</body>