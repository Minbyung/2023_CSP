$(document).ready(function() {
    setMinDate(); // 날짜 선택할때 과거 날짜 선택 못하게 설정
    initializeDefaultStatus(); // 글 작성 시 상태 '요청' 디폴트 값
    initializeToastUIEditors(); // ToastUI
    setupStatusButtons(); // status-btn-write 버튼
    setupArticleUpdateButton(); // article-update-btn 수정 버튼
    setupUpdateSubmitButton(); // updateBtn 수정하기 버튼
    setupUpdateSearchAutocomplete(); // 업데이트 관리자 자동완성
    setupArticleSubmitButton(); // submitBtn 작성 버튼
    setupSearchAutocomplete(); // 관리자 자동완성
    initializeStatusButtons(); // 작성글 수정시 상태버튼 초기화
    setupStatusUpdate(); // status-btn-update 누르면 상태 수정
    fetchArticleCountsByStatus(); // 도넛 차트
    memberDetailModal(); // member-list 누를시 멤버 상세 정보 모달
    inviteProjectMember(); // 팀멤버를 프로젝트멤버에 초대
    setupVideoMeetingButton(); // createMeetingBtn 화상회의 버튼
    setupTabNavigation(); // 글작성, 화상회의 탭 전환
    connectWebSocket(); // 웹소켓
    setupUpdateFileDelete(); // 글 수정시 기존 파일 삭제

	
	
	function setMinDate() {
        var now = new Date();
        var year = now.getFullYear();
        var month = String(now.getMonth() + 1).padStart(2, '0');
        var day = String(now.getDate()).padStart(2, '0');
        var hours = String(now.getHours()).padStart(2, '0');
        var minutes = String(now.getMinutes()).padStart(2, '0');

        var minDate = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;

        $('#start-date').attr('min', minDate);
        $('#end-date').attr('min', minDate);
        $('#update-start-date').attr('min', minDate);
        $('#update-end-date').attr('min', minDate);
    }

    function initializeDefaultStatus() {
        window.status = "요청"; // Default status 
        $(".status-btn-write[data-status='요청']").addClass("active");
    }

    function initializeToastUIEditors() {
        const { Editor } = toastui;
        const { colorSyntax } = Editor.plugin;

        window.editor = new Editor({
            el: document.querySelector('#editor'),
            previewStyle: 'vertical',
            height: '500px',
            initialEditType: 'wysiwyg',
            initialValue: '',
            plugins: [colorSyntax]
        });

        window.updateEditor = new Editor({
            el: document.querySelector('#update-editor'),
            previewStyle: 'vertical',
            height: '500px',
            initialEditType: 'wysiwyg',
            initialValue: '',
            plugins: [colorSyntax]
        });
    }

    function setupStatusButtons() {
        $(".status-btn-write").click(function() {
            $(".status-btn-write").removeClass("active");
            $(this).addClass("active");
            window.status = $(this).data('status');
        });
    }

    function setupArticleUpdateButton() {
        $(document).on('click', '.article-update-btn', function() {
            var articleId = $(this).data('article-id');
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

    function setupArticleSubmitButton() {
        $("#submitBtn").click(function() {
            var selectedGroupId = parseInt($('#groupSelect').val());
            if (!selectedGroupId) {
                $('#groupSelect').val('그룹 미지정');
            }
            var title = $("#exampleFormControlInput1").val();
            var content = editor.getHTML();
            var startDate = $("#start-date").val();
            var endDate = $("#end-date").val();
            var managers = $('.tag').map(function() {
                return $(this).clone().children().remove().end().text();
            }).get();
            
            if (managers.length === 0) {
            	alert("담당자를 입력하세요.");
	            return; 
	        }

            if (!startDate) {
                $('#start-date').val('1000-01-01T00:00:00');
                startDate = $("#start-date").val();
            }

            if (!endDate) {
                $('#end-date').val('1000-01-01T00:00:00');
                endDate = $("#end-date").val();
            }

            var formData = new FormData();
            formData.append('title', title);
            formData.append('content', content);
            formData.append('status', window.status);
            formData.append('projectId', projectId);
            formData.append('selectedGroupId', selectedGroupId);
            formData.append('startDate', startDate);
            formData.append('endDate', endDate);

            $.each(managers, function(i, manager) {
                formData.append('managers[]', manager);
            });

            $('.file_input input[type="file"]').each(function(index, element) {
                if (element.files.length > 0) {
                    formData.append('fileRequests[]', element.files[0]);
                }
            });

            var writeNotification = {
                writerId: loginedMemberId,
                writerName: loginedMemberName,
                title: title,
                content: content,
                managers: managers
            };

            $.ajax({
                url: '../article/doWrite',
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function(data) {
                    stompClient.send("/app/write.notification." + projectId, {}, JSON.stringify(writeNotification));
                    location.reload();
                }
            });
        });
    }

    function setupSearchAutocomplete() {
        $("#search").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../project/getMembers",
                    type: "GET",
                    data: { term: request.term, "projectId": projectId },
                    success: function(data) {
                        var taggedMembers = $('#tag-container .tag').map(function() {
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
                $('#search').val('');
                var tag = $('<span class="tag">' + newValue + '<button class="tag-remove"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg></button></span>');
                $('#tag-container').prepend(tag);
                tag.find('.tag-remove').on('click', function() {
                    tag.remove();
                });
                return false;
            }
        }).on("focus", function() {
            $(this).autocomplete("search", " ");
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
    }

    function setupStatusUpdate() {
        $('.status-btn-update').click(function() {
            var newStatus = $(this).data('status');
            var articleId = $(this).data('article-id');
            $.ajax({
                url: '../article/doUpdateStatus',
                type: 'POST',
                data: {
                    'articleId': articleId,
                    'newStatus': newStatus
                },
                success: function(response) {
                    location.reload();
                }
            });
        });
    }

    function fetchArticleCountsByStatus() {
        $.ajax({
            url: '../article/getArticleCountsByStatus',
            type: 'GET',
            data: { 'projectId': projectId },
            success: function(data) {
                createDonutChart(data);
                displayArticleStatusInfo(data);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('Error fetching data:', textStatus, errorThrown);
            }
        });
    }

    function createDonutChart(data) {
        var statusColors = {
            '요청': 'rgba(255, 99, 132, 0.2)',
            '진행': 'rgba(54, 162, 235, 0.2)',
            '피드백': 'rgba(255, 206, 86, 0.2)',
            '완료': 'rgba(75, 192, 192, 0.2)',
            '보류': 'rgba(153, 102, 255, 0.2)'
        };

        var borderColors = {
            '요청': 'rgba(255, 99, 132, 1)',
            '진행': 'rgba(54, 162, 235, 1)',
            '피드백': 'rgba(255, 206, 86, 1)',
            '완료': 'rgba(75, 192, 192, 1)',
            '보류': 'rgba(153, 102, 255, 1)'
        };

        var labels = data.map(function(item) {
            return item.status;
        });
        var counts = data.map(function(item) {
            return item.count;
        });

        var backgroundColor = labels.map(function(label) {
            return statusColors[label];
        });

        var borderColor = labels.map(function(label) {
            return borderColors[label];
        });

        var ctx = document.getElementById('donutChart').getContext('2d');
        var chartData = {
            labels: labels,
            datasets: [{
                data: counts,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                borderWidth: 1
            }]
        };

        var options = {
            responsive: true,
            cutout: '80%'
        };

        new Chart(ctx, {
            type: 'doughnut',
            data: chartData,
            options: options
        });
    }

    function displayArticleStatusInfo(data) {
        var desiredOrder = ['요청', '진행', '피드백', '완료', '보류'];
        data.sort(function(a, b) {
            return desiredOrder.indexOf(a.status) - desiredOrder.indexOf(b.status);
        });

        var totalCount = data.reduce(function(acc, val) {
            return acc + val.count;
        }, 0);

        var $infoContainer = $('#infoContainer');
        $infoContainer.empty();
        $.each(data, function(i, item) {
            var percentage = ((item.count / totalCount) * 100).toFixed(0);
            var $infoElement = $('<p>').text(item.status + ': ' + item.count + ' (' + percentage + '%)');
            $infoContainer.append($infoElement);
        });
    }

	function memberDetailModal() {
	    $(document).on('click', '.participant', function() {
	        var memberId = $(this).find('div[id^=member-]').data('member-id');
	        var $memberDetails = $('#member-details');
	        console.log("작동");  // 디버깅을 위해 로그 추가
	
	        $('.chat-btn').data('member-id', memberId);
	
	        $.ajax({
	            url: '../member/getMemberDetails',
	            type: 'GET',
	            data: { memberId: memberId },
	            dataType: 'json',
	            success: function(data) {
	                $memberDetails.html('<p>이름: ' + data.name + '</p>' +
	                    '<p>이메일: ' + data.email + '</p>' +
	                    '<p>전화번호: ' + data.cellphoneNum + '</p>'
	                );
	                $('.layer-bg').show();
	                $('#member-modal').show();
	            },
	            error: function(xhr, status, error) {
	                console.log("에러 발생: " + error);  // 에러 로그 추가
	            }
	        });
	    });
	
	    $('.close').click(function() {
	        $('#member-modal').hide();
	        $('.layer-bg').hide();
	    });
	}
	
	function inviteProjectMember() {
	    $('.invite-btn').click(function(event) {
	        event.stopPropagation(); // 이벤트 전파 중단
	
	        var memberId = $(this).data('member-id');
	
	        // AJAX 요청을 통해 서버에 memberId와 projectId를 전송합니다.
	        $.ajax({
	            url: '../project/inviteProjectMember',
	            method: 'POST',
	            data: { memberId: memberId, projectId: projectId },
	            success: function(data) {
	                if (data.resultCode === "F-1") {
	                    alert(data.msg);
	                } else {
	                    alert('팀원이 프로젝트에 초대되었습니다.');
	                    location.reload();
	                }
	            },
	            error: function(err) {
	                alert('초대에 실패했습니다.');
	            }
	        });
	    });
	}
	
    function setupVideoMeetingButton() {
        $('#createMeetingBtn').click(function() {
            const projectId = projectId;
            const topic = $('#meetingTopic').val();
            const duration = $('#meetingDuration').val();
            const startTime = $('#meetingStartTime').val();
            const password = $('#meetingPassword').val();
            const isoStartTime = new Date(startTime).toISOString();

            const requestData = {
                topic: topic,
                type: 2,
                start_time: isoStartTime,
                duration: duration,
                password: password
            };

            localStorage.setItem('zoomMeetingRequest', JSON.stringify(requestData));

            const state = encodeURIComponent(projectId);

            $.ajax({
                url: '/saveZoomMeetingRequest',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(requestData),
                success: function(response) {
                    var authUrl = `https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/oauth/callback&state=${state}`;
                    window.location.href = authUrl;
                }
            });
        });
    }

    function setupTabNavigation() {
        $(".tab-btn").click(function() {
            $(".tab-content").hide();
            $(".tab-btn").removeClass('active active-tab');
            $(this).addClass('active active-tab');
            var tabId = $(this).data('for-tab');
            $("#tab-" + tabId).show();
        });

        $(".tab-btn:first").click();
    }

    function connectWebSocket() {
		
        var socket = new SockJS('/ws_endpoint');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            stompClient.subscribe('/queue/notify-' + loginedMemberId, function(notification) {
                const message = JSON.parse(notification.body);
                showMessage(message.senderName + "님이 새 채팅을 보냈습니다");
            });

            stompClient.subscribe('/queue/tagNotify-' + projectId + loginedMemberId, function(lastPostedArticle) {
                const writeNotificationMessage = JSON.parse(lastPostedArticle.body);
                console.log("sadaasddadddadadadad");
                showMessage(writeNotificationMessage.writerName + "님이 태그하셨습니다");
                $('.notification-badge').show();
            });
        });
    }

    function showMessage(message) {
        $("#messageBox").text(message).fadeIn();
        setTimeout(function() {
            $("#messageBox").fadeOut();
        }, 3000);
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
});