<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

	<%@ include file="../common/head.jsp" %>
<head>
	<title>임시</title>
	<!-- 제이쿼리 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<%@ include file="../common/toastUiEditorLib.jsp" %>
	<link rel="stylesheet" href="/resource/article/detail.css" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-autocomplete/1.0.7/jquery.auto-complete.min.js"></script>
	<script>
		var projectId = ${projectId};
		var articleId = ${article.id}
		var loginedMemberId = ${rq.getLoginedMemberId()};
		var loginedMemberName = '${member.name}';
	</script>
	<script src="/resource/article/detail.js"></script>
</head>	
	
<body>	
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3 pb-8 border-bottom-line">
			<div class="table-box-type">
				<table class="table table-lg">
					<tr>
						<th>번호</th>
						<td>${article.id }</td>
						<th>조회수</th>
						<td>${article.hitCount }</td>
						<th>추천</th>
						<td>
							<c:if test="${rq.getLoginedMemberId() == 0 }">
								<span>${article.point }</span>
							</c:if>
							<c:if test="${rq.getLoginedMemberId() != 0 }">
								<button id="recommendBtn" class="mr-8 btn-text-color btn btn-outline btn-xs">좋아요👍</button>
								<span id="recommendCount">좋아요 : ${article.point }개</span>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>작성일</th>
						<td>${article.regDate.substring(2, 16) }</td>
						<th>수정일</th>
						<td>${article.updateDate.substring(2, 16) }</td>
					</tr>
					<tr>
						<c:if test="${article.startDate != '1000-01-01 00:00:00'}">
							<th>시작일</th>
							<td>${article.startDate.substring(2, 16) }</td>
						</c:if>
						<c:if test="${article.endDate != '1000-01-01 00:00:00'}">
							<th>마감일</th>
							<td>${article.endDate.substring(2, 16) }</td>
						</c:if>
					</tr>
					<tr>
						<th>프로젝트 이름</th>
						<td>${article.projectName }</td>
						<th>상태</th>
						<td>
							<div class="status-btns-update" data-current-status="${article.status }" >
						        <button class="status-btn-update btn btn-active btn-xs" data-status="요청" data-article-id="${article.id}">요청</button>
						        <button class="status-btn-update btn btn-active btn-xs" data-status="진행" data-article-id="${article.id}">진행</button>
						        <button class="status-btn-update btn btn-active btn-xs" data-status="피드백" data-article-id="${article.id}">피드백</button>
						        <button class="status-btn-update btn btn-active btn-xs" data-status="완료" data-article-id="${article.id}">완료</button>
						        <button class="status-btn-update btn btn-active btn-xs" data-status="보류" data-article-id="${article.id}">보류</button>
						    </div>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${article.title }</td>
						<th>작성자</th>
						<td>${article.writerName }</td>
						<th>담당자</th>
						<td>
							<c:forEach var="name" items="${fn:split(article.taggedNames, ',')}" varStatus="status">
			                    ${name}<c:if test="${!status.last}">, </c:if>
			                </c:forEach>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<div class="toast-ui-viewer">
								<script type="text/x-template">${article.content }</script>
							</div>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td>
							<c:if test="${not empty article.infoFiles}">
								<div class="files">
								    <ul>
								        <c:forEach var="file" items="${article.infoFiles}">
											<li><a href="../file/downloadFile?articleId=${file.article_id }&fileId=${file.id }">${file.original_name}</a></li>
										</c:forEach>
								    </ul>
								</div>
							</c:if>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="btns mt-2 flex justify-end gap-2">
				<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
				
				<c:if test="${rq.getLoginedMemberId() != null && rq.getLoginedMemberId() == article.memberId }">
					<a class="btn-text-color btn btn-outline btn-sm" href="/usr/project/detail?projectId=${article.projectId}">프로젝트</a>
					<button class="btn-text-color btn btn-outline btn-sm article-update-btn" data-article-id="${article.id}"> 수정</button>
					<a class="btn-text-color btn btn-outline btn-sm" href="doDelete?id=${article.id }" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;">삭제</a>
				</c:if>
			</div>
		</div>
	</section>
	
	<script>
		const replyWriteForm_onSubmit = function(form) {
			form.body.value = form.body.value.trim();
			
			if (form.body.value.length < 2) {
				alert('2글자 이상 입력해주세요');
				form.body.focus();
				return;
			}
			
			form.submit();
		}
		
		let originalForm = null;
		let originalId = null;
		
		const replyModify_getForm = function(replyId, i){
			
			if (originalForm != null) {
				replyModify_cancle(originalId);
			}
			
			$.ajax({
				url: "../reply/getReplyContent",
				method: "get",
				data: {
						"id" : replyId
					},
				dataType: "json",
				success: function(data) {
					
					let replyContent = $('#' + i);
					
					originalId = i;
					originalForm = replyContent.html();
					
					let addHtml = `
						<form action="../reply/doModify" method="post" class="w-full" onsubmit="replyWriteForm_onSubmit(this); return false;">
							<input name="id" type="hidden" value="\${data.data.id}\" />
							<div class="mt-6 border border-gray-400 rounded-lg p-4">
								<div class="mb-2"><span class="font-semibold">\${data.data.writerName}\</span></div>
								<textarea class="textarea textarea-bordered w-full" name="body" placeholder="댓글을 입력해보세요">\${data.data.body}\</textarea>
								<div class="flex justify-end mt-1">
									<button onclick="replyModify_cancle(\${i}\);" class="btn-text-color btn btn-outline btn-xs mr-2">취소</button>
									<button class="btn-text-color btn btn-outline btn-xs">작성</button>
								</div>
							</div>
						</form>
					`;
					
					replyContent.empty().html("");
					replyContent.append(addHtml);
				},
				error: function(xhr, status, error) {
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
		
		const replyModify_cancle = function(i){
			let replyContent = $('#' + i);
			
			replyContent.html(originalForm);
			
			originalId = null;
			originalForm = null;
		}
 	</script> 
	
	<section class="my-5 text-base">
		<div class="container mx-auto px-3">
			<h2 class="text-lg">댓글</h2>
			<c:forEach var="reply" items="${replies }" varStatus="status">
				<div id="${status.count }" class="py-2 pl-4 border-bottom-line flex">
					
					<div class="profile-photo-container flex justify-center items-center">
						<img src="/profile-photo/${reply.memberId}" alt="Profile Photo" class="profile-photo">
					</div>
					<div class="w-full">
						<div class="flex justify-between items-end w-full">
							<div class="font-semibold">${reply.writerName }</div>
							<c:if test="${rq.getLoginedMemberId() == reply.memberId }">
								<div class="dropdown dropdown-end">
									<button class="btn btn-circle btn-ghost btn-sm">
							    		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-5 h-5 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path></svg>
							    	</button>
									<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-20">
										<li><a onclick="replyModify_getForm(${reply.id}, ${status.count });">수정</a></li>
										<li><a href="../reply/doDelete?id=${reply.id }" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;">삭제</a></li>
									</ul>
								</div>
							</c:if>
						</div>
						<div class="my-1 text-lg ml-2">${reply.getForPrintBody() }</div>
						<div class="text-xs text-gray-400">${reply.updateDate }</div>
					</div>
				</div>
			</c:forEach>
			
			<c:if test="${rq.getLoginedMemberId() != 0 }">
				<form action="../reply/doWrite" method="post" onsubmit="replyWriteForm_onSubmit(this); return false;">
					<input name="relTypeCode" type="hidden" value="article" />
					<input name="relId" type="hidden" value="${article.id }" />
					<div class="mt-6 border border-gray-400 rounded-lg p-4">
						<div class="mb-2"><span class="font-semibold">${member.getNickname() }</span></div>
						<textarea class="textarea textarea-bordered w-full" name="body" placeholder="댓글을 입력해보세요"></textarea>
						<div class="flex justify-end mt-1"><button class="btn-text-color btn btn-outline btn-sm">작성</button></div>
					</div>
				</form>
			</c:if>
		</div>
	</section>
	
	<!-- 모달창 -->
	<div class="layer-bg"></div>
	<div class="update-layer p-10">
		<div class="tabs flex">
	        <button class="tab-btn tab-write" data-for-tab="1">수정</button>
	    </div>

       	<span id="close" class="close close-btn-x">&times;</span>
		<div class="flex flex-col h-full">
			<div class="write-modal-body">
				<input type="hidden" id="projectId" value="${article.projectId }">
<!-- 							<input type="file" id="fileInput" name="files" multiple> -->
				<div id="update-status" class="mt-4">
			      <button class="status-btn-write btn btn-active" data-update-status="요청">요청</button>
			      <button class="status-btn-write btn btn-active" data-update-status="진행">진행</button>
			      <button class="status-btn-write btn btn-active" data-update-status="피드백">피드백</button>
			      <button class="status-btn-write btn btn-active" data-update-status="완료">완료</button>
			      <button class="status-btn-write btn btn-active" data-update-status="보류">보류</button>
			    </div>
					<div id="inputArea">
					  <div class ="update-tag-container" id="update-tag-container"></div>
					  <div class="autocomplete-container flex flex-col mb-3">
						  <input type="text" class="form-control w-72" id="update-search" autocomplete="off" placeholder="담당자를 입력해주세요">
						  <section id="update-autocomplete-results" style="width:20%;"></section>
					  </div>
					<div class="mb-3">
						<label for="update-start-date">시작일:</label>
						<input type="datetime-local" id="update-start-date" class="start-date" name="start-date">

					    <label for="update-end-date">마감일:</label>
					    <input type="datetime-local" id="update-end-date" class="end-date"  name="end-date">		
						  		
						  						  
						<select id="updateGroupSelect" class="select select-bordered select-xs w-full max-w-xs"">
						    <c:forEach var="group" items="${groups}">
						        <c:choose>
						            <c:when test="${group.group_name eq '그룹 미지정'}">
						                <option value="${group.id}" selected>${group.group_name}</option>
						            </c:when>
						            <c:otherwise>
						                <option value="${group.id}">${group.group_name}</option>
						            </c:otherwise>
						        </c:choose>
						    </c:forEach>
						</select> 
					</div>
					
					</div>
					<div class="mb-3">
					  <label for="updateTitle" class="form-label">제목</label>
					  <input type="email" class="form-control title" id="updateTitle" placeholder="제목을 입력해주세요" required />
					</div>
<!-- 					<div class="mb-3"> -->
<!-- 					  <label for="updateContent" class="form-label h-4">내용</label> -->
<!-- 					  <textarea class="form-control h-80 content" id="updateContent" rows="3" placeholder="내용을 입력해주세요" required></textarea> -->
<!-- 					</div> -->
					<div id="update-editor"></div>
					<div class="file_list" id="update-file_list">
						<div class="file-list flex">
						
						</div>
					
						<div class="file_input pb-3 pt-3 flex items-center">
	                        <div> 첨부파일
	                            <input type="file" name="files" onchange="selectFile(this);" />
	                        </div>
	                        <button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>
                 					<button type="button" onclick="addFile();" class="btns fn_add_btn p-2 border border-gray-400"><span>파일 추가</span></button>
	                    </div>
                    </div>
				</div>	
			<div class="write-modal-footer">	
		 	   <button id="updateBtn" type="button">수정하기</button>
		    </div>
	    </div>
	</div>
</body>	