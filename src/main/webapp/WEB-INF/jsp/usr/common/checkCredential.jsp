<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>
    $(document).ready(function() {
        var projectId = ${projectId};
        
        // AJAX 요청을 통해 세션에 credential이 있는지 확인합니다.
        $.ajax({
            url: '/checkCredential',
            method: 'GET',
            success: function(response) {
                if (response.hasCredential) {
                    // 세션에 credential이 있으면 google로 이동
                    $('#calendarLink').attr('href', '/usr/project/schd/google?projectId=' + projectId);
                    $('#googleCalendarButton').text('Google Calendar 연동되었습니다');
                    $('#googleCalendarButton').removeAttr('onclick');
                } else {
                    // 세션에 credential이 없으면 기본 schd로 이동
                    $('#calendarLink').attr('href', '/usr/project/schd?projectId=' + projectId);
                }
            },
            error: function() {
                // 오류가 발생한 경우 기본 schd로 이동
                $('#calendarLink').attr('href', '/usr/project/schd?projectId=' + projectId);
            }
        });
    });
</script>
