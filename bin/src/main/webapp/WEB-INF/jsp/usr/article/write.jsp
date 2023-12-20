<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="ARTICLE WRITE" />
	
	<%@ include file="../common/head.jsp" %>
	<%@ include file="../common/toastUiEditorLib.jsp" %>
	
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<form action="doWrite" method="post" onsubmit="submitForm(this); return false;">
				<input name="body" type="hidden" />
				<div class="table-box-type">
					<table class="table table-lg">
						<tr>
							<th>게시판</th>
							<td>
								<div class="flex">
									<div>
										<label class="flex items-center">
											<input class="radio radio-primary radio-sm" name="boardId" type=radio value="1" checked/>
											&nbsp;&nbsp;&nbsp;공지사항
										</label>
									</div>
									<div class="w-20"></div>
									<div>
										<label class="flex items-center">
											<input class="radio radio-primary radio-sm" name="boardId" type=radio value="2"/>
											&nbsp;&nbsp;&nbsp;자유
										</label>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input class="input input-bordered input-primary w-9/12" name="title" type="text" placeholder="제목을 입력해주세요" /></td>
						</tr>
						<tr>
							<th>내용</th>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template"></script>
								</div>
							</td>
						</tr>
						<tr>
							<td class="text-center" colspan="2"><button class="btn-text-color btn btn-wide btn-outline">작성</button></td>
						</tr>
					</table>
				</div>
			</form>
			
			<div class="btns mt-2">
				<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</section>
	
	<%@ include file="../common/foot.jsp" %>