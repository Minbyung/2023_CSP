<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="/resource/images/favicon.ico" />
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
<link rel="stylesheet" href="/resource/common.css" />
<link rel="stylesheet" href="/resource/home/home.css" />
<script src="/resource/common.js" defer="defer"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</head>

<script>
	$(document).ready(function() {
		$('.member-detail').click(function(){
			$('.member-detail-menu').toggle();
		})
		// .member-detail-menu 이외의 부분 클릭 시 숨김 처리
	    $(document).click(function(event) {
	        var $target = $(event.target);
	        if(!$target.closest('.member-detail-menu').length && 
	           !$target.hasClass('member-detail')) {
	            $('.member-detail-menu').hide();
	        }
	    });
	});	

</script>

<body>
</body>
	

</html>

