<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

	<c:set var="pageTitle" value="ARTICLE DETAIL" />
	
	<%@ include file="../common/head.jsp" %>
	<!-- 제이쿼리 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<%@ include file="../common/toastUiEditorLib.jsp" %>
	<link rel="stylesheet" href="/resource/article/detail.css" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-autocomplete/1.0.7/jquery.auto-complete.min.js"></script>
	
	<script>
		$(document).ready(function(){
			var projectId = ${article.projectId};
			const { Editor } = toastui;
		    const { colorSyntax } = Editor.plugin;
			
		    const updateEditor = new Editor({
	            el: document.querySelector('#update-editor'),
	            previewStyle: 'vertical',
	            height: '500px',
	            initialEditType: 'wysiwyg',
	            initialValue: '',
	            plugins: [colorSyntax]
	        });
		    
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
		     $(".status-btn-write").click(function(){
		 	     $(".status-btn-write").removeClass("active");
		 	     $(this).addClass("active");
	 
		 	     status = $(this).data('status');
		 	  });
		     
			 // 수정
		     $('.article-update-btn').click(function(){
		    	 $('.layer-bg').show();
		    	 $('.update-layer').show();
		    	 $('.file-list').empty();
		    	 var articleId = $(this).data('article-id');
		    	 
		    	 $.ajax({
				        url: '../article/modify',
				        type: 'GET',
				        data: {"projectId": projectId,
				        	"articleId": articleId 
				        },
				        success: function(data) {
				       	  // startDate를 YYYY-MM-DD YYYY-MM-DDT시간:분'형식으로 변환
			              var startDate = (data.startDate === "1000-01-01 00:00:00") ? null : data.startDate.replace(" ", "T");
			          	  var endDate = (data.endDate === "1000-01-01 00:00:00") ? null : data.endDate.replace(" ", "T");
			             
				          // taggedNames 필드를 콤마(,)로 분리
						  var taggedNamesArray = data.taggedNames.split(',');
			              // 분리된 값을 각각 요소로 추가
			              $.each(taggedNamesArray, function(index, name) {
			              	  var tag = $('<span class="tag">' + name + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
					          $('#update-tag-container').prepend(tag);
					          tag.find('.tag-remove').on('click', function() {
					          	tag.remove();
					       	  });
			              });
	 				      $("#updateBtn").data("article-id", data.id);
						  $("#updateTitle1").val(data.title);
						  updateEditor.setMarkdown(data.content);
			              $("#update-start-date").val(startDate);
	 				      $("#update-end-date").val(endDate);
	 				      $('#update-status .status-btn-write').each(function() {
	 		                 if ($(this).data('update-status') === data.status) {
	 		                    $(this).addClass('active');
	 		                    
	 		                 }
	 		              });
	 				      
				        }
				      });
			    	  // 기존 파일 목록 가져오기
				      $.ajax({
				          url: '../file/findFile',
				          method: 'GET',
				          data: {"projectId": projectId,
					        	"articleId": articleId 
				          },
				          success: function(data) {
				        	  console.log(data)
				              data.forEach(file => {
				                  var fileItem = $('<div class="file-item" data-filename="' + file.original_name + '" data-articleid="' + file.article_id + '" data-projectid="' + file.project_id + '">' + file.original_name + '<button class="file-remove btns del_btn p-2 border border-gray-400">삭제</button></div>');
				                  $('.file-list').prepend(fileItem);
				              });
				          }
				      });
		     });
		     $("#updateBtn").click(function(){
		    	 var selectedGroupId = parseInt($('#updateGroupSelect').val());
		    	 var title = $("#updateTitle1").val();
		    	 var content = updateEditor.getHTML(); // TOAST UI Editor에서 내용 가져오기
		    	 var startDate = $("#update-start-date").val();
				 var endDate = $("#update-end-date").val();
				 
				 if (!startDate) {
		                $('#update-start-date').val('1000-01-01T00:00:00');
		                startDate = $("#update-start-date").val();
		         }
		
	            if (!endDate) {
	                $('#update-end-date').val('1000-01-01T00:00:00');
	                endDate = $("#update-end-date").val();
	           	}

				 var managers = $('.tag').map(function() {
				 // 'x' 버튼을 제외한 텍스트만 반환합니다.
			        return $(this).clone().children().remove().end().text();
			     }).get();
				 var status = $('#update-status .status-btn-write.active').data('update-status');
				 var articleId = $(this).data('article-id');
				 
				 var formData = new FormData();
				 
				 // 기존 폼 데이터를 FormData 객체에 추가
			     formData.append('title', title);
			     formData.append('content', content);
			     formData.append('status', status); // status 변수가 정의되어 있어야 합니다.
			     formData.append('projectId', projectId); 
			     formData.append('selectedGroupId', selectedGroupId);
			     formData.append('startDate', startDate);
			     formData.append('endDate', endDate);
			     formData.append('articleId', articleId);
			    

			     $.each(managers, function(i, manager) {
			         formData.append('managers[]', manager);
			     });
			    
			  // 파일 데이터 추가
			     $('.file_input input[type="file"]').each(function(index, element) {
			         if (element.files.length > 0) {
			             formData.append('fileRequests[]', element.files[0]);
			         }
			     });
			  
			     $.ajax({
				        url: '../article/doUpdate',
				        type: 'POST',
				        data: formData,
				        contentType: false, 
				        processData: false, 
				        success: function(data) {
//	 			          $("#title").val("");
//	 			          $("#content").val("");
//	 			          $('.tag').remove();
				          $('.layer-bg').hide();
						  $('.layer').hide();
						  location.reload();
				        }
				      });
		    	  
		    	 
		      });	
		      
		     $("#update-search").autocomplete({
					// source 는 자동완성의 대상(배열)
					// request는 현재 입력 필드에 입력된 값(term)을 포함하고 있으며, 이 값을 사용하여 서버에 데이터를 요청할 때 필요한 매개변수로 사용
				    source: function(request, response) {
				        $.ajax({
				            url: "../project/getMembers",
				            type: "GET",
				            data: { term: request.term, "projectId": projectId },
				            success: function(data) {
				            	console.log(data);
				                var taggedMembers = $('#update-tag-container .tag').map(function() {
				                    return $(this).clone().children().remove().end().text().trim();
				                }).get();
				                var results = $.grep(data, function(result){
				                    return $.inArray(result.trim(), taggedMembers) === -1;
				                });
				
				                response(results);
				            },
				            error: function(err) {
				                console.error(err);
				            }
				        });
				    },
				    select: function(event, ui) {
				        var newValue = ui.item.value;
				        $('#update-search').val('');
				
				        var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
				        $('#update-tag-container').prepend(tag);
				
						$('#update-autocomplete-container').prepend($('#update-search'));
						
				        tag.find('.tag-remove').on('click', function() {
				            tag.remove();
				        });
				
				        return false;
				    }
				}).on("focus", function() {
				    $(this).autocomplete("search", " "); 
				});
		     
		     $(document).on('click', '.file-remove', function() {
		    	 var $fileItem = $(this).closest('.file-item');
		    	 var fileName = $fileItem.data('filename');
		    	 var articleId = $fileItem.data('articleid');
		    	 var projectId = $fileItem.data('projectid');
		    	 
		    	 $.ajax({
		    	        url: '../file/deleteFile',
		    	        type: 'POST',
		    	        data: { fileName: fileName, projectId: projectId, articleId: articleId },
		    	        success: function(response) {
		    	        	console.log(response);
		    	            if (response == "S-1") {
		    	                $fileItem.remove();
		    	            } else {
		    	                alert('파일 삭제에 실패했습니다.');
		    	            }
		    	        },
		    	        error: function(err) {
		    	            console.error(err);
		    	            alert('파일 삭제 중 오류가 발생했습니다.');
		    	        }
		    	    });
		     });
		     $('.close-btn-x').click(function(){
		    		$('.layer-bg').hide();
		    		$('.update-layer').hide();
		    		$('.tag').remove();
		     });
		     $('.layer-bg').click(function(){
		    		$('.layer-bg').hide();
		    		$('.update-layer').hide();
		    		$('.tag').remove();
		    	})
			
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
		
		
		function selectFile(element) {
	        var file = $(element).prop('files')[0];
	        var filename = $(element).closest('.file_input').find('input[type="text"]');

	        if (!file) {
	            filename.val('');
	            return false;
	        }

	        var fileSize = Math.floor(file.size / 1024 / 1024);
	        if (fileSize > 10) {
	            alert('10MB 이하의 파일로 업로드해 주세요.');
	            filename.val('');
	            $(element).val('');
	            return false;
	        }

	        filename.val(file.name);
	    }
	    
		function addFile() {
			console.log("작동");
		    var fileInputHTML =
		        '<div class="file_input pb-3 flex items-center">' +
		        '<div> 첨부파일 ' +
		        '<input type="file" name="files" onchange="selectFile(this); " />' +
		        '</div>' +
		        '<button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>';

		    $('.file_list').append(fileInputHTML);
		}
	    
	    function removeFile(element) {
	        var fileAddBtn = $(element).next('.fn_add_btn');
	        if (fileAddBtn.length) {
	            var inputs = $(element).prev('.file_input').find('input');
	            inputs.val('');
	            return false;
	        }
	        $(element).parent().remove();
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
					  <label for="updateTitle1" class="form-label">제목</label>
					  <input type="email" class="form-control title" id="updateTitle1" placeholder="제목을 입력해주세요" required />
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