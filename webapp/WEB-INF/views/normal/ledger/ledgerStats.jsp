<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/jqplot/css/jquery.jqplot.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/tui.chart/css/tui-chart.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/tui.chart/js/tui-chart-all.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/jquery.jqplot.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/ledger/selectLedgerStats", {type:"monthIE"}).done(function(data){
		fnMonthStats(data);
	});	
});

function fnMonthStats(data){	
	
	let categories = new Array();
	let income = new Array();
	let expense = new Array();
	let maxAmount = 0;
	
	for(let i=0; i<data.length; i++){
		if(i!==0 && i%2===0) categories.push(data[i].startDate.split(" ")[0].substr(0,7));
		
		if(data[i].purTypeCd === "LP001") income.push(data[i].amount);
		else if(data[i].purTypeCd === "LP002") expense.push(Math.abs(data[i].amount));	
		
		maxAmount = maxAmount > Math.abs(data[i].amount) ? maxAmount : Math.abs(data[i].amount);
	}
	
	
	
	let container = document.getElementById("chart");
	let statsData = {
	    categories: categories,
	    series: [
	        {name: '수입', data: income},
	        {name: '지출', data: expense}
	    ]
	};
	let options = {
	    chart: {
	        width: 1350,
	        height: 550,
	        title: '월단위 수입지출..(개발중)',
	        format: '1,000,000'
	    },
	    yAxis: {
	        title: 'Amount',
	        min: 0,
	        max: maxAmount
	    },
	    xAxis: {
	        title: 'Month'
	    },
	    legend: {
	        align: 'right'
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
<div id="chart"></div> 
