<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/tui.chart/css/tui-chart.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/tui.chart/js/tui-chart-all.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	fnMonthStats();
	

	
	
});

function fnMonthStats(data){
	let container = document.getElementById('chart-area');
	let statsData = {
	    categories: ['June, 2015', 'July, 2015', 'August, 2015', 'September, 2015', 'October, 2015', 'November, 2015', 'December, 2015'],
	    series: [
	        {
	            name: '수입',
	            data: [5000, 3000, 5000, 7000, 6000, 4000, 1000]
	        },
	        {
	            name: '지출',
	            data: [8000, 1000, 7000, 2000, 6000, 3000, 5000]
	        }
	    ]
	};
	let options = {
	    chart: {
	        width: 1350,
	        height: 550,
	        title: '월단위 수입지출..(개발중)',
	        format: '1,000'
	    },
	    yAxis: {
	        title: 'Amount',
	        min: 0,
	        max: 9000
	    },
	    xAxis: {
	        title: 'Month'
	    },
	    legend: {
	        align: 'top'
	    }
	};
	
	let color = "rgba(246, 246, 246, .8)";
	let theme = {
		title:{
			fontSize: 18,
			fontFamily: 'Verdana',
			fontWeight: 'bold',
	        color: color			
		},
		xAxis: {
	        title: {	            
	            color: color
	        },
	        label: {	           
	            color: color
	        },
	        tickColor: color
	    },
	    yAxis: {
	    	 title: {	            
	            color: color
	        },
	        label: {	           
	            color: color
	        },
	    	tickColor: color
	    },
		chart:{
			background:{
				color: '#4C4C4C',
	            opacity: 0.9
			}
		},
		plot: {
	        lineColor: color,
	        background: '#efefef'
	    },	    
	    series: {
	        colors: ['#4374D9', '#CC3D3D']
	    },
	    legend : { 
	        label : { 
	            fontSize :  13,	            
	            color: color 
	        } 
	    }	    
	};
	
	tui.chart.registerTheme('theme', theme);
	options.theme = 'theme';
	let chart = tui.chart.columnChart(container, statsData, options);
}
</script>



<div id="chart-area"></div> 
