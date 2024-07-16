$(document).ready(function() {
	setupAccordionButtons();
	setupChatButton();
	setupNotifications();
	setupLayerToggles();
	memberDetailModal();
	setupInviteEmail();
	
	
	
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
        $('.invite-modal').click(function() {
            $('.layer-bg').show();
            $('.invite-layer').show();
        });
        
        $('.close-btn-x').click(closeLayer);
        $('.layer-bg').click(closeLayer);

        function closeLayer() {
            $('.layer-bg').hide();
            $('.rpanel').hide();
            $('.member-modal').hide();
            $('.invite-layer').hide();
            resetLayerFields();
        }

        function resetLayerFields() {
            $(".invite-email-input").val('');
        }
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
	    
	    $('.layer-bg').click(function() {
			$('#member-modal').hide();
	        $('.layer-bg').hide();
		});
	}
	
	function setupInviteEmail() {
        $("#submitBtn").click(function() {
            var email = $("#exampleFormControlInput1").val();
            
            $.ajax({
                url: '../member/doInvite',
                type: 'POST',
                data: { teamId: teamId, email: email },
                success: function(data) {
                    $(".invite-email-input").val('');
                    $('.layer-bg').hide();
                    $('.invite-layer').hide();
                    alert("메일 전송이 완료되었습니다.");
                }
            });
        });
    }
	
	
})