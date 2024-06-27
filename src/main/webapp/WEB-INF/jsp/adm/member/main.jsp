<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        .tab {
            display: none;
        }

        .tab-buttons {
            margin-bottom: 20px;
        }

        .tab-buttons button {
            margin-right: 10px;
            padding: 10px;
            cursor: pointer;
        }

        .tab-buttons .active {
            font-weight: bold;
        }

        .inactive-row {
            background-color: #d3d3d3; /* 회색 배경색 */
        }

        .inactive-row input[type="checkbox"] {
            pointer-events: none; /* 체크박스 클릭 불가 */
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            function showTab(tabIndex) {
                $('.tab').hide();
                $('.tab-button').removeClass('active');
                $('.tab').eq(tabIndex).show();
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
            
            // 전체 선택 체크박스 
            $('#selectAllAllUsers').click(function() {
                $('.selectAllUsers').prop('checked', this.checked);
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
    <h1>User Management</h1>
    <div class="tab-buttons">
        <button class="tab-button">All Users</button>
        <button class="tab-button">Active Users</button>
        <button class="tab-button">Inactive Users</button>
    </div>
	
	<form id="deleteForm" action="/member/delete" method="post">
	    <div id="allUsers" class="tab">
	        <h2>All Users</h2>
	        <table>
	            <thead>
	                <tr>
	                    <th><input type="checkbox" id="selectAllAllUsers"></th>
	                    <th>ID</th>
	                    <th>Username</th>
	                    <th>Email</th>
	                    <th>팀이름</th>
	                    <th>Status</th>
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
	                    </tr>
	                </c:forEach>
	            </tbody>
	        </table>
	        <button type="button" class="deleteButton">Delete Selected Users</button>
	    </div>
	
	    <div id="activeUsers" class="tab">
	        <h2>Active Users</h2>
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
	        <button type="button" class="deleteButton"">Delete Selected Users</button>
	    </div>
	
	    <div id="inactiveUsers" class="tab">
	        <h2>Inactive Users</h2>
	        <table>
	            <thead>
	                <tr>
	                    <th><input type="checkbox" id="selectAllInactiveUsers"></th>
	                    <th>ID</th>
	                    <th>Username</th>
	                    <th>Email</th>
	                    <th>팀이름</th>
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
	                    </tr>
	                </c:forEach>
	            </tbody>
	        </table>
	        <button type="button" id="activateButton">Activate Selected Users</button>
	    </div>
	    
        
    </form>
</body>
</html>