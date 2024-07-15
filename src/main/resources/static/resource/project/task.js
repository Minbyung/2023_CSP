$(document).ready(function() {
    setMinDate();
    initializeDefaultStatus();
    initializeToastUIEditors();
    setupFavoriteIcon();
    setupFavoriteIconClick();
    setupStatusButtons();
    setupFileRemoveClick();
    setupLayerToggles();
    setupArticleSubmitButton();
    setupSearchAutocomplete();
    setupDatePickers();
    setupAccordionButtons();
    setupVideoMeetingButton();
    setupTabNavigation();
    setupMemberDetailMenu();
    connectWebSocket();
    setupChatButton();
    setupNotifications();
    setupStatusUpdateButtons(); // 상태 업데이트 버튼
    setupGroupButtons(); //그룹 추가 버튼
    setupToggleTasks(); // 그룹 접기/펴기 버튼
    setupSortButtons(); // 정렬 버튼

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
    }

    function setupFavoriteIcon() {
        $.ajax({
            url: '../favorite/getFavorite',
            method: 'GET',
            data: { "projectId": projectId },
            dataType: "json",
            success: function(data) {
                $('#favoriteIcon').addClass(data ? 'fas' : 'far');
            }
        });
    }

    function setupFavoriteIconClick() {
        $('#favoriteIcon').click(function() {
            var isFavorite = $(this).hasClass('fas');
            $.ajax({
                url: '../favorite/updateFavorite',
                method: 'POST',
                data: {
                    "projectId": projectId,
                    "isFavorite": !isFavorite
                },
                success: function(response) {
                    $('#favoriteIcon').toggleClass('far fas');
                }
            });
        });
    }

    function setupStatusButtons() {
        $(".status-btn-write").click(function() {
            $(".status-btn-write").removeClass("active");
            $(this).addClass("active");
            window.status = $(this).data('status');
        });
    }

    function setupFileRemoveClick() {
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
                    if (response == "S-1") {
                        $fileItem.remove();
                    } else {
                        alert('파일 삭제에 실패했습니다.');
                    }
                }
            });
        });
    }

    function setupLayerToggles() {
        $('.modal-exam').click(function() {
            $('.layer-bg').show();
            $('.layer').show();
        });

        $('.close-btn-x').click(closeLayer);
        $('.layer-bg').click(closeLayer);

        function closeLayer() {
            $('.layer-bg').hide();
            $('.layer').hide();
            $('.update-layer').hide();
            $('.rpanel').hide();
            $('.member-modal').hide();
            resetLayerFields();
        }

        function resetLayerFields() {
            $('.tag').remove();
            $('#exampleFormControlInput1').val('');
            $('#exampleFormControlTextarea1').val('');
            $('#file_list .file_input:not(:first)').remove();
            $('#file_list .file_input:first input[type="file"]').val('');
            $('#file_list .file_input:first input[type="text"]').val('');
            $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
            $('#start-date').val('');
            $('#end-date').val('');
        }
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

    function setupDatePickers() {
        $('#start-date, #end-date').on('click', function() {
            this.showPicker();
        });
    }

    function setupAccordionButtons() {
        $('.project-menu-accordion-button > .flex').click(function() {
            toggleAccordion('.left-menu-project-list-box', $(this).find('i'));
        });

        $('.chat-menu-accordion-button > .flex').click(function() {
            toggleAccordion('.left-menu-chat-list-box', $(this).find('i'));
        });

        function toggleAccordion(selector, icon) {
            $(selector).slideToggle();
            if (icon.hasClass('fa-chevron-down')) {
                icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
            } else {
                icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
            }
        }
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

    function setupMemberDetailMenu() {
        $('.member-detail').click(function() {
            $('.member-detail-menu').toggle();
        });

        $(document).click(function(event) {
            var $target = $(event.target);
            if (!$target.closest('.member-detail-menu').length && !$target.hasClass('member-detail')) {
                $('.member-detail-menu').hide();
            }
        });
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

    function setupChatButton() {
        $('.chat-btn').click(function() {
            var memberId = $(this).data('member-id');
            var chatWindowUrl = '/usr/home/chat?memberId=' + encodeURIComponent(memberId);
            window.open(chatWindowUrl, '_blank', 'width=500,height=700');
        });
    }

    function setupNotifications() {
        $('.notification').click(function() {
            $('.rpanel').toggle();
            $('.notification-badge').hide();
        });

        $.ajax({
            url: '/getTaggedNotifications',
            type: 'GET',
            data: { loginedMemberId: loginedMemberId },
            success: function(notifications) {
                notifications.forEach(function(notification) {
                    const newNotificationCardHtml = `
                        <div class="notification-card-wrap" style="position: relative;">
                            <a href="/usr/article/detail?id=${notification.articleId}" class="notification-link">
                                <div class="notification-card">
                                    <div class="notification-project-name">${notification.projectName}</div>
                                    <div class="notification-project-writername">글쓴이 : ${notification.writerName}</div>
                                    <div class="notification-project-regdate">작성날짜 : ${notification.regDate}</div>
                                    <div class="notification-project-title">제목 : ${notification.title}</div>
                                </div>
                            </a>
                            <button class="delete-notification-btn" data-id="${notification.id}" style="position: absolute; top: 10px; right: 10px; background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
                        </div>
                    `;
                    $('.list-notification').prepend(newNotificationCardHtml);
                });
                $('.delete-notification-btn').click(function() {
                    const notificationId = $(this).data('id');
                    deleteNotification(notificationId);
                });
                $('.clear-all-btn').click(function() {
                    deleteAllNotifications();
                });
            }
        });
    }

    function showMessage(message) {
        $("#messageBox").text(message).fadeIn();
        setTimeout(function() {
            $("#messageBox").fadeOut();
        }, 3000);
    }

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

    function deleteNotification(notificationId) {
        $.ajax({
            url: '/deleteNotificationById',
            type: 'POST',
            data: { notificationId: notificationId },
            success: function(response) {
                if (response.success) {
                    $(`button[data-id="${notificationId}"]`).closest('.notification-card-wrap').remove();
                } else {
                    alert('Failed to delete notification.');
                }
            }
        });
    }

    function deleteAllNotifications() {
        $.ajax({
            url: '/deleteAllNotification',
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    $('.list-notification').empty();
                } else {
                    alert('Failed to delete notifications.');
                }
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
    
    
    function setupStatusUpdateButtons() {
        $(document).on('click', '.status-btn-taskupdate', function(event) {
            event.stopPropagation();
            $(this).siblings(".status-menu").toggle();
        });

        $(document).on('click', '.status-menu button', function() {
            const newStatus = $(this).data('status');
            const articleId = $(this).data('article-id');
            updateStatus(articleId, newStatus);
        });
    }

    function updateStatus(articleId, newStatus) {
        $.ajax({
            url: '../article/doUpdateStatus',
            method: 'POST',
            data: {
                'articleId': articleId,
                'newStatus': newStatus
            },
            success: function() {
                location.reload();
            },
            error: function() {
                alert('상태 업데이트에 실패했습니다.');
            }
        });
    }
    
    function setupGroupButtons() {
        $(".addGroupButton").click(function(){
            const $inputRow = $('<tr class="inputRow"><th colspan="7"><input placeholder="추가할 그룹명을 입력해 주세요." type="text" id="groupNameInput"></th></tr>');
            $(".task-table").prepend($inputRow);
            $("#groupNameInput").focus();
        });

        $(document).on('keypress', '#groupNameInput', function(event) {
            if(event.keyCode == 13) {
                saveGroup();
            }
        });
    }

    function saveGroup() {
        const group_name = $("#groupNameInput").val().trim();
        if (group_name.length === 0) {
            alert('그룹 이름을 입력해주세요.');
            return;
        }

        $.ajax({
            url: '../group/doMake',
            method: 'POST',
            data: {
                'projectId': projectId,
                'group_name': group_name
            },
            success: function() {
                location.reload();
            },
            error: function() {
                alert('그룹 저장에 실패했습니다.');
            }
        });
    }
    
    function setupToggleTasks() {
        $(document).on('click', '.toggleTasks', function() {
            $(this).closest('tr').nextAll().toggle();
        });
    }
    
    function setupSortButtons() {
        $('.sort-btn').on('click', function() {
            const column = $(this).data('column');
            const order = $(this).data('order');
            sortTable(column, order);
            $(this).data('order', order === 'ASC' ? 'DESC' : 'ASC');
        });
    }

    function sortTable(column, order) {
        const table = $('#task-table-1');
        const columnIndex = getColumnIndex(table, column);
        if (columnIndex === -1) return;

        table.find('tbody').each(function() {
            const tbody = $(this);
            const header = tbody.find('tr:first');
            const rows = tbody.find('tr').not(':first').get();

            rows.sort((a, b) => compareRows(a, b, columnIndex, column, order));

            tbody.empty();
            tbody.append(header);
            rows.forEach(row => tbody.append(row));
        });
    }

    function getColumnIndex(table, column) {
        let columnIndex = -1;
        table.find('th').each(function(index) {
            const thColumn = $(this).find('.sort-btn').data('column');
            if (thColumn === column) {
                columnIndex = index;
                return false;
            }
        });
        return columnIndex;
    }

    function compareRows(a, b, columnIndex, column, order) {
        let A = $(a).children('td').eq(columnIndex).text().trim();
        let B = $(b).children('td').eq(columnIndex).text().trim();

        if (['startDate', 'endDate', 'regDate'].includes(column)) {
            A = parseDate(A);
            B = parseDate(B);
        } else if (column === 'id') {
            A = parseInt(A, 10);
            B = parseInt(B, 10);
        }

        return (A < B ? -1 : (A > B ? 1 : 0)) * (order === 'ASC' ? 1 : -1);
    }

    function parseDate(dateString) {
        const parts = dateString.split('-');
        return new Date(parts[0], parts[1] - 1, parts[2]);
    }
    
    
});
