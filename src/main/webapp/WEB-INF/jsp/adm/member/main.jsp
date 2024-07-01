<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../../usr/common/head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
	<link rel="stylesheet" href="/resource/adm/main.css" />    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            function showTab(tabIndex) {
                $('.adm-tab').hide();
                $('.tab-button').removeClass('active');
                $('.adm-tab').eq(tabIndex).show();
                $('.tab-button').eq(tabIndex).addClass('active');
            }

            $('.tab-button').click(function () {
                var index = $(this).index();
                showTab(index);
            });

            showTab(0); // 초기에는 첫 번째 탭을 표시
            
            $('.deleteButton').click(function () {
                $('#deleteForm').attr('action', '/member/delete');
                $('#deleteForm').submit();
            });

            $('#activateButton').click(function () {
                $('#deleteForm').attr('action', '/member/activate');
                $('#deleteForm').submit();
            });
            
            $('tbody tr').click(function(event) {
                if (event.target.type !== 'checkbox') {
                    var checkbox = $(this).find('input[type="checkbox"]');
                    if (!checkbox.prop('disabled')) {
                        checkbox.prop('checked', !checkbox.prop('checked'));
                    }
                }
            });
            
            // 전체 선택 체크박스 
             $('#selectAllAllUsers').change(function() {
		        $('.selectAllUsers').each(function() {
		            if (!$(this).prop('disabled')) {
		                $(this).prop('checked', $('#selectAllAllUsers').prop('checked'));
		            }
		        });
		    });

            $('#selectAllActiveUsers').click(function() {
                $('.selectActiveUsers').prop('checked', this.checked);
            });

            $('#selectAllInactiveUsers').click(function() {
                $('.selectInactiveUsers').prop('checked', this.checked);
            });
            
        });
    </script>
</head>
<body>
	<div class="wrap">
		<div class="header">
			<h1 class="pt-4"><a href="main">회원 관리</a></h1>
			<div>
				<a class="home-button" href="/usr/home/main">HOME</a>
			</div>
		</div>
		<div class="container">   
		    <div class="tab-buttons">
		        <button class="tab-button">모든 회원</button>
		        <button class="tab-button">활성화된 회원</button>
		        <button class="tab-button">비활성화된 회원</button>
		    </div>
		    <div class="flex justify-end">
<!-- 			    <form action="/adm/member/main" method="get"> -->
<%-- 			        <input type="text" name="keyword" placeholder="Search by username or email" value="${keyword}"> --%>
<!-- 			        <button type="submit">Search</button> -->
<!-- 			    </form> -->
			    
			    <div class="search-box flex justify-end">
					<form action="/adm/member/main" method="get">
						<input class="search-txt" type="text" name="keyword" placeholder="Search by username or email" value="${keyword}">
						<button class="search-btn" type="submit">
							<i class="fa-solid fa-magnifying-glass"></i>
						</button>
					</form>
				</div>
		    </div>
		     
			<form id="deleteForm" action="/member/delete" method="post">
			    <div id="allUsers" class="adm-tab">
			        <h2 class="text-xl font-bold">모든 회원</h2>
			        <table>
			            <thead>
			                <tr>
			                    <th><input type="checkbox" id="selectAllAllUsers"></th>
			                    <th>ID</th>
			                    <th>Username</th>
			                    <th>Email</th>
			                    <th>팀이름</th>
			                    <th>Status</th>
			                    <th>비활성 날짜</th>
			                </tr>
			            </thead>
			            <tbody>
			                <c:forEach items="${allMembers}" var="member">
			                    <tr class="${member.delStatus == 1 ? 'inactive-row' : ''}">
			                        <td><input type="checkbox" class="selectAllUsers" name="memberIds" value="${member.id}" ${member.delStatus == 1 ? 'disabled' : ''}></td>
			                        <td>${member.id}</td>
			                        <td>${member.name}</td>
			                        <td>${member.loginId}</td>
			                        <td>${member.teamName}</td>
			                        <td>${member.delStatus == 0 ? 'Active' : 'Inactive'}</td>
			                        <td>
				                        <c:choose>
					                        <c:when test="${not empty member.delDate}">
					                            ${member.delDate}
					                        </c:when>
					                        <c:otherwise>
					                            
					                        </c:otherwise>
					                    </c:choose>
			                        </td>
			                    </tr>
			                </c:forEach>
			            </tbody>
			        </table>
				    <div class="pagination">
				        <c:if test="${page > 1}">
				            <a href="?page=${page - 1}">&laquo; Previous</a>
				        </c:if>
				        <c:forEach begin="1" end="${allMembersPagesCnt}" var="pageNum">
				            <a href="?page=${pageNum}" class="${pageNum == page ? 'current' : ''}">${pageNum}</a>
				        </c:forEach>
				        <c:if test="${page < allMembersPagesCnt}">
				            <a href="?page=${page + 1}">Next &raquo;</a>
				        </c:if>
				    </div>
			        <div class="flex justify-end">
			        	<button type="button" class="deleteButton submit-btn">회원 비활성화</button>
			        </div>
			    </div>
			
			    <div id="activeUsers" class="adm-tab">
			        <h2 class="text-xl font-bold">활성화된 회원</h2>
			        <table>
			            <thead>
			                <tr>
			                    <th><input type="checkbox" id="selectAllActiveUsers"></th>
			                    <th>ID</th>
			                    <th>Username</th>
			                    <th>Email</th>
			                    <th>팀이름</th>
			                </tr>
			            </thead>
			            <tbody>
			                <c:forEach items="${activeMembers}" var="member">
			                    <tr>
			                        <td><input type="checkbox" class="selectActiveUsers" name="memberIds" value="${member.id}"></td>
			                        <td>${member.id}</td>
			                        <td>${member.name}</td>
			                        <td>${member.loginId}</td>
			                        <td>${member.teamName}</td>
			                    </tr>
			                </c:forEach>
			            </tbody>
			        </table>
			        <div class="pagination">
				        <c:if test="${page > 1}">
				            <a href="?page=${page - 1}">&laquo; Previous</a>
				        </c:if>
				        <c:forEach begin="1" end="${activeMembersPagesCnt}" var="pageNum">
				            <a href="?page=${pageNum}" class="${pageNum == page ? 'current' : ''}">${pageNum}</a>
				        </c:forEach>
				        <c:if test="${page < activeMembersPagesCnt}">
				            <a href="?page=${page + 1}">Next &raquo;</a>
				        </c:if>
				    </div>
			        <div class="flex justify-end">
			        	<button type="button" class="deleteButton submit-btn">회원 비활성화</button>
			        </div>
			    </div>
			
			    <div id="inactiveUsers" class="adm-tab">
			        <h2 class="text-xl font-bold">비활성화된 회원</h2>
			        <table>
			            <thead>
			                <tr>
			                    <th><input type="checkbox" id="selectAllInactiveUsers"></th>
			                    <th>ID</th>
			                    <th>Username</th>
			                    <th>Email</th>
			                    <th>팀이름</th>
			                    <th>비활성 날짜</th>
			                </tr>
			            </thead>
			            <tbody>
			                <c:forEach items="${inactiveMembers}" var="member">
			                    <tr>
			                        <td><input type="checkbox" class="selectInactiveUsers" name="memberIds" value="${member.id}"></td>
			                        <td>${member.id}</td>
			                        <td>${member.name}</td>
			                        <td>${member.loginId}</td>
			                        <td>${member.teamName}</td>
			                        <td>
				                        <c:choose>
					                        <c:when test="${not empty member.delDate}">
					                            ${member.delDate}
					                        </c:when>
					                        <c:otherwise>
					                            
					                        </c:otherwise>
					                    </c:choose>
			                        </td>
			                    </tr>
			                </c:forEach>
			            </tbody>
			        </table>
			        <div class="pagination">
				        <c:if test="${page > 1}">
				            <a href="?page=${page - 1}">&laquo; Previous</a>
				        </c:if>
				        <c:forEach begin="1" end="${inactiveMembersPagesCnt}" var="pageNum">
				            <a href="?page=${pageNum}" class="${pageNum == page ? 'current' : ''}">${pageNum}</a>
				        </c:forEach>
				        <c:if test="${page < inactiveMembersPagesCnt}">
				            <a href="?page=${page + 1}">Next &raquo;</a>
				        </c:if>
				    </div>
			        <div class="flex justify-end">
			        	<button type="button" class="submit-btn" id="activateButton">회원 활성화</button>
			        </div>
			    </div>
	
		    </form>
	    </div>
    </div>
</body>
</html>