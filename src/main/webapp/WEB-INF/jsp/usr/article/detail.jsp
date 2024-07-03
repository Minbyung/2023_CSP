<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="ARTICLE DETAIL" />
	
	<%@ include file="../common/head.jsp" %>
	<%@ include file="../common/toastUiEditorLib.jsp" %>
	<link rel="stylesheet" href="/resource/article/detail.css" />
	
	<script>
		$(document).ready(function(){
			getRecommendPoint();
			
			
			$('#recommendBtn').click(function(){
				let recommendBtn = $('#recommendBtn').hasClass('btn-active');
				console.log(recommendBtn);
				$.ajax({
					url: "../recommendPoint/doRecommendPoint",
					method: "get",
					data: {
							"relTypeCode" : "article",
							"relId" : ${article.id },
							"recommendBtn" : recommendBtn
						},
					dataType: "text",
					success: function(data) {
						$('#recommendBtn').toggleClass('btn-active');
                        $('#recommendCount').text(`좋아요 : \${data}\개`);
					},
					error: function(xhr, status, error) {
						console.error("ERROR : " + status + " - " + error);
					}
				})
				
			});
			//상태버튼 현재 상태 활성화 표시
		     $('.status-btns-update').each(function() {
		         var currentStatus = $(this).data('current-status');
		         $(this).find('.status-btn-update').each(function() {
		             if ($(this).data('status') === currentStatus) {
		                 $(this).addClass("active");
		             }
		         });
		     });
			
		});
		
		const getRecommendPoint = function(){
				$.ajax({
					url: "../recommendPoint/getRecommendPoint",
					method: "get",
					data: {
							"relTypeCode" : "article",
							"relId" : ${article.id }
						},
					dataType: "json",
					success: function(data) {
						if (data.success) {
							$('#recommendBtn').addClass('btn-active');
						}
					},
					error: function(xhr, status, error) {
						console.error("ERROR : " + status + " - " + error);
					}
				})
			}
		
		
		
	</script>
	
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
						<th>시작일</th>
						<td>${article.startDate.substring(2, 16) }</td>
						<th>마감일</th>
						<td>${article.endDate.substring(2, 16) }</td>
					</tr>
					<tr>
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
			
			<div class="btns mt-2">
				<button class="btn-text-color btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
				
				<c:if test="${rq.getLoginedMemberId() != null && rq.getLoginedMemberId() == article.memberId }">
					<a class="btn-text-color btn btn-outline btn-sm" href="modify?id=${article.id }">수정</a>
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
	
	<%@ include file="../common/foot.jsp" %>