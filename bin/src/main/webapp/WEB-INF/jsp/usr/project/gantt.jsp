<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/head2.jsp" %>




<!DOCTYPE html>
<html>
<head>
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


	// Create the chart
	const chart = Highcharts.ganttChart('gantt-container', {

	    chart: {
	        spacingLeft: 1
	    },

	    title: {
	        text: 'Interactive Gantt Chart'
	    },

	    subtitle: {
	        text: 'Drag and drop points to edit'
	    },

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
	                draggableY: true,
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
	                    select: updateRemoveButtonStatus,
	                    unselect: updateRemoveButtonStatus,
	                    remove: updateRemoveButtonStatus
	                }
	            }
	        }
	    },

	    yAxis: {
	        type: 'category',
	        categories: ['Group 1 Duration', 'Task 1', 'Task 2', 'Group 2 Duration', 'Task 3', 'Task 4'],
	        accessibility: {
	            description: 'Organization departments'
	        },
	        min: 0,
	        max: 6
	    },

	    xAxis: [{
	        currentDateIndicator: true,
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
	        name: 'Group 1',
	        data: [{
	            start: Date.UTC(2023, 0, 1),
	            end: Date.UTC(2023, 0, 12),
	            name: 'Group 1 Duration',
	            y: 0
	        }, {
	            start: Date.UTC(2023, 0, 1),
	            end: Date.UTC(2023, 0, 6),
	            name: 'Task 1',
	            id: 'task1',
	            y: 1
	        }, {
	            start: Date.UTC(2023, 0, 7),
	            end: Date.UTC(2023, 0, 12),
	            name: 'Task 2',
	            y: 2
	        }]
	    }, {
	        name: 'Group 2',
	        data: [{
	            start: Date.UTC(2023, 0, 13),
	            end: Date.UTC(2023, 0, 24),
	            name: 'Group 2 Duration',
	            y: 3
	        }, {
	            start: Date.UTC(2023, 0, 13),
	            end: Date.UTC(2023, 0, 18),
	            name: 'Task 3',
	            id: 'task3',
	            y: 4
	        }, {
	            start: Date.UTC(2023, 0, 19),
	            end: Date.UTC(2023, 0, 24),
	            name: 'Task 4',
	            y: 5
	        }]
	    }]
	});


	/* Add button handlers for add/remove tasks */

	btnRemoveTask.onclick = function () {
	    const points = chart.getSelectedPoints();
	    each(points, function (point) {
	        point.remove();
	    });
	};

	btnShowDialog.onclick = function () {
	    // Update dependency list
	    let depInnerHTML = '<option value=""></option>';
	    each(chart.series[0].points, function (point) {
	        depInnerHTML += '<option value="' + point.id + '">' + point.name +
	            ' </option>';
	    });
	    selectDependency.innerHTML = depInnerHTML;

	    // Show dialog by removing "hidden" class
	    addTaskDialog.className = 'overlay';
	    isAddingTask = true;

	    // Focus name field
	    inputName.value = '';
	    inputName.focus();
	};

	btnAddTask.onclick = function () {
	    // Get values from dialog
	    const series = chart.series[0],
	        name = inputName.value,
	        dependency = chart.get(
	            selectDependency.options[selectDependency.selectedIndex].value
	        ),
	        y = parseInt(
	            selectDepartment.options[selectDepartment.selectedIndex].value,
	            10
	        );
	    let undef,
	        maxEnd = reduce(series.points, function (acc, point) {
	            return point.y === y && point.end ? Math.max(acc, point.end) : acc;
	        }, 0);

	    const milestone = chkMilestone.checked || undef;

	    // Empty category
	    if (maxEnd === 0) {
	        maxEnd = today;
	    }

	    // Add the point
	    series.addPoint({
	        start: maxEnd + (milestone ? day : 0),
	        end: milestone ? undef : maxEnd + day,
	        y: y,
	        name: name,
	        dependency: dependency ? dependency.id : undef,
	        milestone: milestone
	    });

	    // Hide dialog
	    addTaskDialog.className += ' hidden';
	    isAddingTask = false;
	};

	btnCancelAddTask.onclick = function () {
	    // Hide dialog
	    addTaskDialog.className += ' hidden';
	    isAddingTask = false;
	};
 

	});
</script>
<body>


<div id="gantt-container" style="height: full;"></div>



</body>
</html>