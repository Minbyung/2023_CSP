$(document).ready(function() {
	initializeToastUIEditors();
	getRecommendPoint();
	$('#recommendBtn').click(handleRecommendButtonClick);
	initializeStatusButtons();
	setupArticleUpdateButton();
	setupUpdateSubmitButton();
	setupUpdateSearchAutocomplete();
	setupUpdateFileDelete();
	setupModalCloseButtons();
	
	function initializeToastUIEditors() {
        const { Editor } = toastui;
        const { colorSyntax } = Editor.plugin;

        window.updateEditor = new Editor({
            el: document.querySelector('#update-editor'),
            previewStyle: 'vertical',
            height: '500px',
            initialEditType: 'wysiwyg',
            initialValue: '',
            plugins: [colorSyntax]
        });
    }
	
	function getRecommendPoint() {
        $.ajax({
            url: "../recommendPoint/getRecommendPoint",
            method: "get",
            data: {
                "relTypeCode": "article",
                "relId": articleId
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
        });
    }
    
    function handleRecommendButtonClick() {
        let recommendBtn = $('#recommendBtn').hasClass('btn-active');
        $.ajax({
            url: "../recommendPoint/doRecommendPoint",
            method: "get",
            data: {
                "relTypeCode": "article",
                "relId": articleId,
                "recommendBtn": recommendBtn
            },
            dataType: "text",
            success: function(data) {
                $('#recommendBtn').toggleClass('btn-active');
                $('#recommendCount').text(`좋아요 : ${data}개`);
            },
            error: function(xhr, status, error) {
                console.error("ERROR : " + status + " - " + error);
            }
        });
    }
    
    function initializeStatusButtons() {
        $('.status-btns-update').each(function() {
            var currentStatus = $(this).data('current-status');
            $(this).find('.status-btn-update').each(function() {
                if ($(this).data('status') === currentStatus) {
                    $(this).addClass("active");
                }
            });
        });
        $(".status-btn-write").click(function() {
            $(".status-btn-write").removeClass("active");
            $(this).addClass("active");
            status = $(this).data('status');
        });
    }
    
    function setupArticleUpdateButton() {
        $(document).on('click', '.article-update-btn', function() {
            $('.layer-bg').show();
	    	$('.update-layer').show();
            fetchArticleDetails(articleId);
            fetchArticleFiles(articleId);
        });
    }
    
    function fetchArticleDetails(articleId) {
        $.ajax({
            url: '../article/modify',
            type: 'GET',
            data: { "projectId": projectId, "articleId": articleId },
            success: function(data) {
				if (data.resultCode.startsWith("F-")) {
					alert(data.msg);
					history.back();
				} else {
					populateArticleDetails(data.data);
				}
            }
        });
    }

    function fetchArticleFiles(articleId) {
        $.ajax({
            url: '../file/findFile',
            method: 'GET',
            data: { "projectId": projectId, "articleId": articleId },
            success: function(data) {
                data.forEach(file => {
                    var fileItem = $('<div class="file-item" data-filename="' + file.original_name + '" data-articleid="' + file.article_id + '" data-projectid="' + file.project_id + '">' + file.original_name + '<button class="file-remove btns del_btn p-2 border border-gray-400">삭제</button></div>');
                    $('.file-list').prepend(fileItem);
                });
            }
        });
    }
    
    function populateArticleDetails(data) {
        var startDate = (data.startDate === "1000-01-01 00:00:00") ? null : data.startDate.replace(" ", "T");
        var endDate = (data.endDate === "1000-01-01 00:00:00") ? null : data.endDate.replace(" ", "T");

        var taggedNamesArray = data.taggedNames.split(',');
        taggedNamesArray.forEach(function(name) {
            var tag = $('<span class="tag">' + name + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
            $('#update-tag-container').prepend(tag);
            tag.find('.tag-remove').on('click', function() {
                tag.remove();
            });
        });
		
        $("#updateBtn").data("article-id", data.id);
        $("#updateTitle").val(data.title);
        updateEditor.setMarkdown(data.content);
        $("#update-start-date").val(startDate);
        $("#update-end-date").val(endDate);
        $('#update-status .status-btn-write').each(function() {
            if ($(this).data('update-status') === data.status) {
                $(this).addClass('active');
            }
        });
    }
    
    function setupUpdateSubmitButton() {
        $("#updateBtn").click(function() {
            var selectedGroupId = parseInt($('#updateGroupSelect').val());
            var title = $("#updateTitle").val();
            var content = updateEditor.getHTML();
            var startDate = $("#update-start-date").val();
            var endDate = $("#update-end-date").val();
            var managers = $('.tag').map(function() {
                return $(this).clone().children().remove().end().text();
            }).get();
            var status = $('#update-status .status-btn-write.active').data('update-status');
            var articleId = $(this).data('article-id');
            
            if (managers.length === 0) {
            	alert("담당자를 입력하세요.");
	            return; 
	        }

            if (!startDate) {
                $('#update-start-date').val('1000-01-01T00:00:00');
                startDate = $("#update-start-date").val();
            }

            if (!endDate) {
                $('#update-end-date').val('1000-01-01T00:00:00');
                endDate = $("#update-end-date").val();
            }

            var formData = new FormData();
            formData.append('title', title);
            formData.append('content', content);
            formData.append('status', status);
            formData.append('projectId', projectId);
            formData.append('selectedGroupId', selectedGroupId);
            formData.append('startDate', startDate);
            formData.append('endDate', endDate);
            formData.append('articleId', articleId);
            $.each(managers, function(i, manager) {
                formData.append('managers[]', manager);
            });

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
                    location.reload();
                }
            });
        });
    }

    function setupUpdateSearchAutocomplete() {
        $("#update-search").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../project/getMembers",
                    type: "GET",
                    data: { term: request.term, "projectId": projectId },
                    success: function(data) {
                        var taggedMembers = $('#update-tag-container .tag').map(function() {
                            return $(this).clone().children().remove().end().text().trim();
                        }).get();
                        var results = $.grep(data, function(result) {
                            return $.inArray(result.trim(), taggedMembers) === -1;
                        });
                        response(results);
                    }
                });
            },
            select: function(event, ui) {
                var newValue = ui.item.value;
                $('#update-search').val('');
                var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
                $('#update-tag-container').prepend(tag);
                tag.find('.tag-remove').on('click', function() {
                    tag.remove();
                });
                return false;
            }
        }).on("focus", function() {
            $(this).autocomplete("search", " ");
        });
    }
    
    function setupUpdateFileDelete() {
        $(document).on('click', '.file-remove', function() {
            const $fileItem = $(this).closest('.file-item');
            const fileName = $fileItem.data('filename');
            const articleId = $fileItem.data('articleid');
            const projectId = $fileItem.data('projectid');
			console.log(projectId);
            deleteFile(fileName, projectId, articleId, $fileItem);
        });
    }

    function deleteFile(fileName, projectId, articleId, $fileItem) {
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
    }
    
    
    window.selectFile = function(element) {
        const file = $(element).prop('files')[0];
        const filename = $(element).closest('.file_input').find('input[type="text"]');

        if (!file) {
            filename.val('');
            return false;
        }

        const fileSize = Math.floor(file.size / 1024 / 1024);
        if (fileSize > 10) {
            alert('10MB 이하의 파일로 업로드해 주세요.');
            filename.val('');
            $(element).val('');
            return false;
        }

        filename.val(file.name);
    }

    window.addFile = function() {
        const fileInputHTML = `
            <div class="file_input pb-3 flex items-center">
                <div> 첨부파일 
                    <input type="file" name="files" onchange="selectFile(this);" />
                </div>
                <button type="button" onclick="removeFile(this);" class="btns del_btn p-2 border border-gray-400"><span>삭제</span></button>
            </div>
        `;
        $('.file_list').append(fileInputHTML);
    }

    window.removeFile = function(element) {
        const fileAddBtn = $(element).next('.fn_add_btn');
        if (fileAddBtn.length) {
            const inputs = $(element).prev('.file_input').find('input');
            inputs.val('');
            return false;
        }
        $(element).parent().remove();
    }
	
	function setupModalCloseButtons() {
        $('.close-btn-x, .layer-bg').click(function() {
            $('.layer-bg').hide();
            $('.update-layer').hide();
            $('.tag').remove();
        });
    }
	
	
})