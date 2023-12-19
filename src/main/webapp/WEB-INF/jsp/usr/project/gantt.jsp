<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>




<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<!-- 	<link rel="stylesheet" href="/resource/dist/style.css" /> -->
	<link rel="stylesheet" href="/resource/project/detail.css" />
	<link href="https://cdn.jsdelivr.net/npm/daisyui@4.3.1/dist/full.min.css" rel="stylesheet" type="text/css" />
	<script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
	<link rel="stylesheet" href="https://code.highcharts.com/css/highcharts.css">
    <script src="https://code.highcharts.com/gantt/highcharts-gantt.js"></script>
	<script src="https://code.highcharts.com/gantt/modules/draggable-points.js"></script>
	<script src="https://code.highcharts.com/gantt/modules/accessibility.js"></script>
	
</head>


<script>
	$(document).ready(function() {

/*
	    http://api.highcharts.com/gantt.
*/

	let today = new Date(),
	isAddingTask = false;
	let thirtyDaysLater = new Date();
	thirtyDaysLater.setDate(today.getDate() + 30);
	
	var projectId = '1';
	var defaultColumn = 'id';
	var defaultOrder = 'DESC';
	var column = localStorage.getItem('column') || defaultColumn;
	var order = localStorage.getItem('order') || defaultOrder;

	
	const day = 1000 * 60 * 60 * 24,
	    each = Highcharts.each,
	    reduce = Highcharts.reduce,
	    btnShowDialog = document.getElementById('btnShowDialog'),
	    btnRemoveTask = document.getElementById('btnRemoveSelected'),
	    btnAddTask = document.getElementById('btnAddTask'),
	    btnCancelAddTask = document.getElementById('btnCancelAddTask'),
	    addTaskDialog = document.getElementById('addTaskDialog'),
	    inputName = document.getElementById('inputName'),
	    selectDepartment = document.getElementById('selectDepartment'),
	    selectDependency = document.getElementById('selectDependency'),
	    chkMilestone = document.getElementById('chkMilestone');

	// Set to 00:00:00:000 today
	today.setUTCHours(0);
	today.setUTCMinutes(0);
	today.setUTCSeconds(0);
	today.setUTCMilliseconds(0);
	today = today.getTime();
	let thirtyDaysLaterTimestamp = thirtyDaysLater.getTime();

	// Update disabled status of the remove button, depending on whether or not we
	// have any selected points.
	function updateRemoveButtonStatus() {
	    const chart = this.series.chart;
	    // Run in a timeout to allow the select to update
	    setTimeout(function () {
	        btnRemoveTask.disabled = !chart.getSelectedPoints().length ||
	            isAddingTask;
	    }, 10);
	}

	$.ajax({
        url: '/usr/project/getGroupedArticles',
        type: 'GET',
        data: {
            projectId: '1' // 실제 프로젝트 ID로 대체해야 합니다.
        },
        dataType: 'json',
        success: function(data) {
        	
            var chartData = [];
            var categories = [];  // 이 배열을 채워야 합니다.
            let minDate = Infinity;
    	    let maxDate = -Infinity;
    	    var groupId;
    	    
    	    for (var group in data) {
    	    	
                var articles = data[group];  // 해당 그룹의 articles 가져오기
                
                var groupStart = Infinity;  // 그룹의 시작 날짜를 저장하는 변수
                var groupEnd = -Infinity;  // 그룹의 끝 날짜를 저장하는 변수
                     
                var groupName = articles.length > 0 ? articles[0].groupName : null;
                
                categories.push(groupName);
                
                for (var i = 0; i < articles.length; i++) {
                    var article = articles[i];
                    
                    let start = new Date(article.startDate).getTime();
                    let end = new Date(article.endDate).getTime();
                    
                    groupId = article.groupId;
                    groupName = article.groupName;
                    
                    
                    
                    if (start < minDate) {
                        minDate = start;
                    }
                    if (end > maxDate) {
                        maxDate = end;
                    }

                    if (start < groupStart) {
                        groupStart = start;
                    }
                    if (end > groupEnd) {
                        groupEnd = end;
                        
                    }
                    
 
                    chartData.push({
                        id: article.id,
                        name: article.title,
                        start: start,
                        end: end,
                        groupId: groupId,
                        y: categories.length, // 각 데이터 포인트에 대해 다른 'y' 값을 설정
                        color: '#0293fa'
                    });
                    
                    categories.push(article.title);
                    
                }
                // 막대 관련
                chartData.push({
                	id: 'group-' + groupId,  // 그룹의 ID
                    name: group,  // 그룹의 이름
                    start: groupStart,
                    end: groupEnd,
                    y: categories.length - articles.length - 1,  // 그룹에 해당하는 막대의 'y' 값
                    color: groupName === '그룹 미지정' ? 'transparent' : '#acadad',  // '그룹미지정'인 그룹의 막대 색상을 투명하게 설정		
                });
                
                
                
                
                // 그룹의 시작 날짜와 끝 날짜를 바탕으로 그룹에 해당하는 막대를 추가
                
                   
            }
         // 30일 밀리초로 변환
            const THIRTY_DAYS = 30 * 24 * 60 * 60 * 1000;

            // 만약 범위가 30일 미만이면, 범위를 30일로 늘립니다.
            if (maxDate - minDate < THIRTY_DAYS) {
                maxDate = minDate + THIRTY_DAYS;
            }
            
	// Create the chart
	var chart = Highcharts.ganttChart('gantt-container', {

	    chart: {
	        spacingLeft: 1
	    },

// 	    title: {
// 	        text: 'Interactive Gantt Chart'
// 	    },

// 	    subtitle: {
// 	        text: 'Drag and drop points to edit'
// 	    },

	    lang: {
	        accessibility: {
	            axis: {
	                xAxisDescriptionPlural: 'The chart has a two-part X axis showing time in both week numbers and days.'
	            }
	        }
	    },

	    accessibility: {
	        point: {
	            descriptionFormat: '{#if milestone}' +
	                '{name}, milestone for {yCategory} at {x:%Y-%m-%d}.' +
	                '{else}' +
	                '{name}, assigned to {yCategory} from {x:%Y-%m-%d} to {x2:%Y-%m-%d}.' +
	                '{/if}'
	        }
	    },

	    plotOptions: {
	        series: {
	            animation: false, // Do not animate dependency connectors
	            dragDrop: {
	                draggableX: true,
	                draggableY: false,
	                dragMinY: 0,
	                dragMaxY: 6,    // 7행 밑으로 드래그 되지 않음
	                dragPrecisionX: day / 3 // Snap to eight hours
	            },
	            dataLabels: {
	                enabled: true,
	                format: '{point.name}',
	                style: {
	                    cursor: 'default',
	                    pointerEvents: 'none'
	                }
	            },
	            allowPointSelect: true,
	            point: {
	                events: {
	                	drag: function(e) {
	                		if (typeof this.options.id === 'string' && this.options.id.startsWith('group-')) {
	                        	return false; // 그룹 바일 경우 드래그 이벤트 막기
	                        }
	                    },
      	
	                	click: function() {
	                        if (typeof this.options.id === 'string' && this.options.id.startsWith('group-')) {
	                            return false; // 그룹 바일 경우 클릭 이벤트 무시
	                        }
	                    },
	                    mouseOver: function() {
	                        if (typeof this.options.id === 'string' && this.options.id.startsWith('group-')) {
	                            return false; // 그룹 바일 경우 마우스 오버 이벤트 무시
	                        }
	                    },
	                	
	                	
	                    select: updateRemoveButtonStatus,
	                    unselect: updateRemoveButtonStatus,
	                    remove: updateRemoveButtonStatus,
	                    update: function(event) {
	                        // 막대의 시작과 종료 날짜를 가져옵니다.
	                        var start = this.start;
	                        var end = this.end;

	                        // 현재 차트의 범위를 가져옵니다.
	                        var min = this.series.xAxis.min;
	                        var max = this.series.xAxis.max;

	                     // 막대가 차트의 앞쪽 범위를 벗어나려 한다면, xAxis의 범위를 업데이트하여 뒤쪽 범위를 확장합니다.
	                        if (start < min) {
	                            this.series.xAxis.update({
	                                min: start,
	                                max: max - (min - start)
	                            });
	                        }

	                        // 막대가 차트의 뒤쪽 범위를 벗어나려 한다면, xAxis의 범위를 업데이트하여 앞쪽 범위를 확장합니다.
	                        if (end > max) {
	                            this.series.xAxis.update({
	                                min: min + (end - max),
	                                max: end
	                            });
	                        }
	                    },
	                  drop: function() {
	                	  

                        if (typeof this.options.id === 'string' && this.options.id.startsWith('group-')) {
                       		return false; // 그룹 바일 경우 드롭 이벤트 막기
                        }

	                      var point = this;
	                      var startDate = new Date(point.start).toISOString().split('T')[0];
	                      var endDate = new Date(point.end).toISOString().split('T')[0];
	                  	 // 'yyyy-mm-dd'를 'yy-mm-dd'로 변환
	                      startDate = startDate.slice(2);
	                      endDate = endDate.slice(2);
	                      var groupStart = Infinity;
	                      var groupEnd = -Infinity;
	                      console.log(endDate);   
	                      // 서버에 AJAX 요청을 보내 데이터베이스를 업데이트합니다.
	                      $.ajax({
	                          url: '../article/doUpdateDate',  // 실제 업데이트 URL로 대체해야 합니다.
	                          type: 'POST',
	                          data: {
	                              articleId: point.id,  // 각 task에 대한 고유 식별자가 필요합니다.
	                              startDate: startDate,
	                              endDate: endDate
	                          },
	                          success: function(response) {
	                        	  
	                              // 요청이 성공적으로 처리되었을 때의 처리를 작성합니다.
	                              console.log('Task updated successfully.');
	                              var $row = $('#task-table-1').find('tr').filter(function() {
	                                  return $(this).find('.status').data('id') === point.id;
	                              });

	                              $row.find('td:nth-child(4)').text(startDate);  // 'startDate'를 표시하는 셀의 내용을 업데이트합니다.
	                              $row.find('td:nth-child(5)').text(endDate);  // 'endDate'를 표시하는 셀의 내용을 업데이트합니다.
	                             
	                              
	                          },
	                          error: function(xhr, status, error) {
	                              // 에러가 발생했을 때의 처리를 작성합니다.
	                              console.error('Failed to update task:', error);
	                          }
	                      });
	                      
	                      for (var i = 0; i < this.series.data.length; i++) {
	                    	    var task = this.series.data[i].options;
	                    	    if (task.groupId === this.groupId) {
	                    	        var taskStart = task.start;
	                    	        var taskEnd = task.end;
	                    	        
	                    	        groupStart = Math.min(groupStart, taskStart);
	                    	        groupEnd = Math.max(groupEnd, taskEnd);
	                    	        
	      	                     
	                    	    }
	                    	}
	                      groupStart = new Date(groupStart).toISOString().split('T')[0];
	                      groupEnd = new Date(groupEnd).toISOString().split('T')[0];
	                      // 그룹 막대를 찾아서 시작 날짜와 종료 날짜를 업데이트합니다.
	                     
	                      var groupBar = this.series.chart.get('group-' + this.groupId);
	                      
	                      
	                      if (groupBar) {
	                    	  //Highcharts Gantt에서는 일반적으로 start와 end 값으로 유닉스 타임스탬프(밀리초 단위)를 사용
	                    	  var startTimestamp = new Date(groupStart).getTime();
	                    	  var endTimestamp = new Date(groupEnd).getTime();
	                    	  
	                          groupBar.update({
	                              start: startTimestamp,
	                              end: endTimestamp
	                          }, false);  // 차트를 여기서는 업데이트하지 않습니다.
	                         
	                      }
	                      
	                      // 차트를 업데이트합니다.
	                      this.series.chart.redraw();
	                  }

	                }
	            }
	        },
	    },

// 	    yAxis: {
// 	        type: 'category',
// 	        categories: ['Group 1 Duration', 'Task 1', 'Task 2', 'Group 2 Duration', 'Task 3', 'Task 4'],
// 	        accessibility: {
// 	            description: 'Organization departments'
// 	        },
// 	        min: 0,
// 	        max: 6
// 	    },
		yAxis: {
		    type: 'category',
		    categories: categories,  // 이 배열을 채워야 합니다.
		    accessibility: {
		        description: 'Organization departments'
		    },
		    labels: {
	            style: {
	                fontSize: '14px', // 레이블의 글자 크기를 14px로 설정
	               	fontFamily: 'NanumSquareNeo-Variable'
	            } 
	        },
		    min: 0,
		    max: categories.length - 1,  // 이 부분은 그룹과 그룹의 업무 수에 따라 달라집니다.
		    staticScale: 32 // y축 행 높이
		},



	        
	    xAxis: [{
	        currentDateIndicator: true,
	        min: minDate,
	        max: maxDate,
	        labels: {
	            format: '{value:%e}' // Display the day of the month
	        },
	        tickInterval: 24 * 3600 * 1000, // A day
	    }, {
	        linkedTo: 0,
	        labels: {
	            format: '{value:%Y-%m}' // Display the year and month
	        },
	        tickInterval: 28 * 24 * 3600 * 1000 // A month
	    }],

	    series: [{
	        data : chartData
	        }]
	    
	 });
	// 정렬 기능
	 $('.sort-btn').click(function() {
		    var column = $(this).data('column');
		    var order = $(this).data('order');
		    
			// 새로고침해도 정렬값이 유지
// 		    localStorage.setItem('column', column);
// 		    localStorage.setItem('order', order);
// 		    window.location.href = '/usr/project/gantt?column=' + encodeURIComponent(column) + '&order=' + encodeURIComponent(order);

		    $.ajax({
		        url: "../project/task",
		        type: 'GET',
		        data: {
		            projectId: projectId,
		            column: column,
		            order: order
		        },
		        success: function(data) {
		        	// 테이블 행의 순서를 가져옴
		            var newOrder = $("#task-table-1 tbody").find('tr').map(function() {
		                return this.id;
		            }).get();
					
		            // 간트 차트의 새 데이터 배열
		            var newData = [];

		            newOrder.forEach(function(id) {
		                // 간트 차트의 데이터 배열에서 ID에 해당하는 데이터를 찾음
		                var oldIndex = chart.series[0].data.findIndex(function(point) {
		                    return point.id === id;
		                });

		                if (oldIndex > -1) {
		                    // 찾은 데이터를 새 데이터 배열에 추가
		                    newData.push(chart.series[0].data[oldIndex]);
		                }
		            });

		            // 간트 차트의 데이터를 새 데이터 배열로 설정
		            chart.series[0].setData(newData, true);
		        } 
		    });
		 });
	
	
	
	
	
	
        },
        error: function(request, status, error) {
            console.error('Error:', error);
        }
    });


	
		
// 	$.ajax({
// 	    url: '../favorite/getFavorite',
// 	    method: 'GET',
// 	    data: {
// 	        "projectId": projectId
// 	    },
// 	    dataType: "json",
// 	    success: function(data) {
// 	   	 if (data) {
// 	            $('#favoriteIcon').addClass('fas');
// 	        } 
// 	   	 else {
// 	            $('#favoriteIcon').addClass('far');
// 	        }
// 	    }
// 	});
	
	
// 	$('#favoriteIcon').click(function() {
// 		 var isFavorite = $(this).hasClass('fas'); 
// 	   $.ajax({
// 	       url: '../favorite/updateFavorite',
// 	       method: 'POST',
// 	       data: {
// 	           "projectId": projectId, 
// 	           "isFavorite": !isFavorite 
// 	       },
// 	       success: function(response) {
// 	       	 $('#favoriteIcon').toggleClass('far fas');
// 	       }
// 	   });
// 	});

	$(document).on('click', '.status-btn-taskupdate', function(event) {
	    event.stopPropagation();
	    $(this).siblings(".status-menu").toggle();
	});

    $(document).click(function() {
        $(".status-menu").hide();
    });
    
	$(document).on('click', '.status-menu button', function() { //동적으로 생성된 요소에 이벤트 핸들러를 적용하려면, $(document).on(event, selector, function) 형태를 사용
	    var newStatus = $(this).data('status'); // 클릭한 버튼의 상태를 가져오기
	    var articleId = $(this).data('article-id');
	    $.ajax({
	        url: '../article/doUpdateStatus',
	        method: 'POST',
	        data: {
	            'articleId': articleId,
	            'newStatus': newStatus
	        },
	        success: function() {
	            // 요청이 성공하면 상태 버튼의 텍스트를 업데이트하고 상태 리스트를 숨김
	            $(".status[data-article-id=" + articleId + "] .status-btn-taskupdate").text(status);
	            $(".status-menu").hide();
	            location.reload();
	        },
	        error: function() {
	            alert('상태 업데이트에 실패했습니다.');
	        }
	    });
	});

	 // 그룹 추가 버튼을 눌렀을 때
    $(".addGroupButton").click(function(){
      // 그룹명 입력 창을 생성
      var $inputRow = $('<tr class="inputRow"><th colspan="7"><input placeholder="추가할 그룹명을 입력해 주세요." type="text" id="groupNameInput"></th></tr>');
      $(".task-table").prepend($inputRow);
      $("#groupNameInput").focus();
    });	
	
	 
	 // 그룹명 입력 창에 엔터를 눌렀을 때
    $(document).on('keypress', '#groupNameInput', function(event) {
        if(event.keyCode == 13) {
            saveGroup();
        }
    });

   /*  // 그룹명 입력 창 외의 영역을 클릭했을 때
    $(document).click(function(event){
	  if($('#groupNameInput').is(":visible") && !$(event.target).closest('#groupNameInput').length){
	    saveGroup();
	  }
	}); */
    
	 // 그룹 저장 함수
    function saveGroup() {
    
      var group_name = $("#groupNameInput").val().trim();
      var projectId = $('#favoriteIcon').data('project-id');
      
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
            	//그룹명 입력 창을 제거
//	            	$("#groupNameInput").parent().parent().remove();
            	location.reload();
            },
            error: function() {
                alert('그룹 저장에 실패했습니다.');
            }
        });
	
    } 
	
	 
 // 시작일과 마감일을 가져오기
    var startDate = $("#start-date").val();
    var endDate = $("#end-date").val();

	
// 	// 그룹 내의 업무를 보이기/숨기기하는 기능
// 		 $('.toggleTasks').click(function() {
// 			    $(this).closest('tr').nextAll().toggle();
// 			});		
	$(document).on('click', '.toggleTasks', function() { // 동적으로 생성된 요소에 이벤트 핸들러를 적용하려면, $(document).on(event, selector, function) 형태를 사용
	    $(this).closest('tr').nextAll().toggle();
	});		

	
	
	
	

	});
</script>
<body>
	<div class="overflow-x-auto">
		<div style="display: flex;">
		    <div id="task-table-container" style="flex: 1;">
			    <table id="task-table-1" class="table task-table">
			        <colgroup>
			            <col style="width: 20%;">
			            <col style="width: 10%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			            <col style="width: 14%;">
			        </colgroup>
			        <thead>
			            <tr>
			                <th>업무명
				                <button class="sort-btn" data-column="title" data-order="ASC">▲</button>
			 							<button class="sort-btn" data-column="title" data-order="DESC">▼</button>
										</th>
			                <th style="text-align: center;">상태</th>
			                <th style="text-align: center;">담당자</th>
			                <th style="text-align: center;">시작일
			                	<button class="sort-btn" data-column="startDate" data-order="ASC">▲</button>
			 							<button class="sort-btn" data-column="startDate" data-order="DESC">▼</button>
			                </th>
			                <th style="text-align: center;">마감일
			                <button class="sort-btn" data-column="endDate" data-order="ASC">▲</button>
			 						<button class="sort-btn" data-column="endDate" data-order="DESC">▼</button>
			                </th>
			            </tr>
			        </thead>
			        <c:forEach var="group" items="${groupedArticles}">
			            <tbody>
			                <tr><th class="font-bold" colspan="7"> <button class="toggleTasks">▶</button> <c:out value="${group.key}"/></th></tr>
			                <c:choose>
			                 			<c:when test="${not empty group.value}">
			                <c:forEach var="article" items="${group.value}">
			                    <tr>
			                        <td><c:out value="${article.title}"></c:out></td>						
			                              <td class="status relative" data-id="${article.id}">
			                                  <button class="status-btn-taskupdate btn btn-active btn-xs btn-block" data-status="${article.status}">
			                                      <c:out value="${article.status}"></c:out>
			                                  </button>
			                                  <div class="status-menu" style="display: none; position: absolute; z-index: 1000;">
			                                      <div class="bg-white border border-black border-solid p-3 rounded">
			                                          <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="요청" data-article-id="${article.id}">요청</button>
			                                          <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="진행" data-article-id="${article.id}">진행</button>
			                                          <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="피드백" data-article-id="${article.id}">피드백</button>
			                                          <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="완료" data-article-id="${article.id}">완료</button>
			                                          <button class="status-btn-taskupdate btn btn-active btn-xs btn-block my-1" data-status="보류" data-article-id="${article.id}">보류</button>
			                                      </div>
			                                  </div>
			                              </td>						
			                              <td style="text-align: center;">
			                                  <c:forEach var="name" items="${fn:split(article.taggedNames, ',')}">
			                                      <c:out value="${name}"></c:out>
			                                  </c:forEach>
			                              </td>
			                              <td style="text-align: center;"><c:out value="${article.startDate.substring(2, 10)}"></c:out></td>
			                              <td style="text-align: center;"><c:out value="${article.endDate.substring(2, 10)}"></c:out></td>
			                    </tr>
			                </c:forEach>
				                </c:when>
			                 		<c:otherwise>
			                 		<tr>
			                           <td colspan="7" style="text-align: center;">작업 내용이 없습니다.</td>
			                       </tr>
			                 	  </c:otherwise>
			              		 </c:choose>
			            </tbody>
			        </c:forEach>
			    </table>
		    </div>
		    <div id="gantt-container" style="height: 100%; flex: 1;"></div>
	    </div>
	</div>


</body>
</html>