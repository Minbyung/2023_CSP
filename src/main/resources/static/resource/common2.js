$(document).ready(function() {
	setupFavoriteIcon(); // 즐겨찾기아이콘 상태 가져오기
	setupFavoriteIconClick(); // 즐겨찾기아이콘 수정
	setupAccordionButtons(); // left-bar 아코디언 버튼
	setupMemberDetailMenu(); // 상단 바 member-detail 누를시
	setupChatButton(); // 채팅방 진입
	setupNotifications(); // rpanel
	setupLayerToggles(); // 모달 열기/닫기 & 내용 리셋
	setupDatePickers(); // input 날짜 부분 눌러도 달력 나오게
	
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
	
	function setupDatePickers() {
        $('#start-date, #end-date').on('click', function() {
            this.showPicker();
        });
    }
	
	
	
	
	
	
	
	
});	