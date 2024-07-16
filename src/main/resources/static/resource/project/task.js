$(document).ready(function() {
    setMinDate(); // 날짜 선택할때 과거 날짜 선택 못하게 설정
    initializeDefaultStatus(); // 글 작성 시 상태 '요청' 디폴트 값
    initializeToastUIEditors(); // ToastUI (작성만)
    setupStatusButtons(); // status-btn-write 버튼
    setupArticleSubmitButton(); // submitBtn 작성 버튼
    setupSearchAutocomplete(); // 관리자 자동완성
    setupVideoMeetingButton(); // createMeetingBtn 화상회의 버튼
    setupTabNavigation(); // 글작성, 화상회의 탭 전환
    connectWebSocket(); // 웹소켓
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

    

    function setupStatusButtons() {
        $(".status-btn-write").click(function() {
            $(".status-btn-write").removeClass("active");
            $(this).addClass("active");
            window.status = $(this).data('status');
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

    function setupVideoMeetingButton() {
        $('#createMeetingBtn').click(function() {
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
