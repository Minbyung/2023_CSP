$(document).ready(function() {
    setMinDate(); // 날짜 선택할때 과거 날짜 선택 못하게 설정
    initializeDefaultStatus(); // 글 작성 시 상태 '요청' 디폴트 값
    initializeToastUIEditors(); // ToastUI (작성만)
    setupStatusButtons(); // status-btn-write 버튼
    setupLayerToggles(); // 모달 열기/닫기 & 내용 리셋
    setupArticleSubmitButton(); // submitBtn 작성 버튼
    setupSearchAutocomplete(); // 관리자 자동완성
    setupDatePickers(); // input 날짜 부분 눌러도 달력 나오게
    setupVideoMeetingButton(); // createMeetingBtn 화상회의 버튼
    setupTabNavigation(); // 글작성, 화상회의 탭 전환
    connectWebSocket(); // 웹소켓
    
    initializeCalendar(); // 달력
    initializeModal();

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
    
    function initializeCalendar() {
	    var calendarEl = $('#calendar')[0];
	    var events = projectEvents.concat(googleEvents);
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        height: '1000px',
	        expandRows: true,
	        headerToolbar: {
	            left: 'prev,next today',
	            center: 'title',
	            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
	        },
	        initialView: 'dayGridMonth',
	        navLinks: true,
	        editable: true,
	        eventDurationEditable: true,
	        eventResizableFromStart: true,
	        eventDrop: function(info) {
	            var event = info.event;
	            if (event.extendedProps.editable === false) {
	                info.revert();
	                return;
	            }
	            $.ajax({
	                url: '/usr/article/doUpdateDate',
	                method: 'POST',
	                data: {
	                    articleId: event.id,
	                    startDate: event.start.toISOString(),
	                    endDate: event.end ? event.end.toISOString() : event.start.toISOString()
	                },
	                success: function(response) {
	                    // 서버에서 성공적으로 처리됐을 때의 로직
	                },
	                error: function() {
	                    info.revert();
	                }
	            });
	        },
	        selectable: true,
	        nowIndicator: true,
	        dayMaxEvents: true,
	        locale: 'ko',
	        select: function(info) {
	            var endDate = new Date(info.endStr);
	            endDate.setDate(endDate.getDate());
	            var endStrAdjusted = endDate.toISOString().split('.')[0];
	            var startStrAdjusted = new Date(info.startStr).toISOString().split('.')[0];
	            $('#start-date').val(startStrAdjusted);
	            $('#end-date').val(endStrAdjusted);
	            showModal();
	        },
	        events: events,
	        eventClick: function(info) {
	            if (info.event.extendedProps.editable === false) {
	                return;
	            }
	            var articleId = info.event.id;
	            window.location.href = "/usr/article/detail?id=" + articleId;
	        }
	    });
	    calendar.render();
	}
    
    function initializeModal() {
        $("#close").on("click", function() {
            hideModal();
        });

        hideModal();
    }
    
    function showModal() {
        $(".modal-exam").show();
        $(".layer-bg").show();
        $(".layer").show();
    }
    
    function hideModal() {
        $(".modal-exam").hide();
        $(".layer-bg").hide();
        $(".layer").hide();
        $('.tag').remove();
        $('#exampleFormControlInput1').val('');
        $('#exampleFormControlTextarea1').val('');
        $('#groupSelect').val($('#groupSelect option:contains("그룹 미지정")').val());
    }
    
    
    

});
