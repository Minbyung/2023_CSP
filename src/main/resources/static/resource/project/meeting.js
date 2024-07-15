$(document).ready(function() {
    setupVideoMeetingButton(); // createMeetingBtn 화상회의 버튼
    connectWebSocket(); // 웹소켓

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

    
});
