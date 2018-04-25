<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	recordStats("month");
		
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		switch(e.target.id){
		case "monthTab":
			recordStats("month");
			break;
		case "yearTab":
			recordStats("year");
			break;
		case "purposeTab":
			recordStats("purpose");
			break;
		}
	});
});

function recordStats(tap, date){
	
	$("#"+tap+"StatsChart").empty();
	$("#"+tap+"StatsList").empty();
	
	let param = {};
	param.mode = tap;
	if(emptyCheck.isEmpty(date)){
		param.date = isDate.firstDay();
	}else{
		param.date = date;
	}
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/ledgerRe/selectStatsList.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	switch(tap){
	    	case "month" :
	    		statsMonthDraw(data);
	    		break;
	    	case "year" :
	    		break;
	    	case "purpose" :
	    		break;
	    	}
	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});
}

//월별 통계
function statsMonthDraw(stats){
	console.log(stats);
	
	let combo = new Array();
	let line = new Array();
	let comboTag = {head:"<th>날짜</th>", plus:"<td>수입</td>", minus:"<td>지출</td>", sum:"<td>합계</td>"};
	let lineTag = {head:"<th>날짜</th>", amount:"<td>월별합계</td>"};
	
	combo.push(['date', '수입', '지출']);
	line.push(['date', '월별합계']);
	let amount = stats[0].stAmount;
	
	for(let i=0; i<stats.length; i++){
		//월별 통계 차트
		combo.push([stats[i].date, stats[i].plus, Math.abs(stats[i].minus)]);
		
		//월별 증감 차트
		amount += (stats[i].plus - Math.abs(stats[i].minus));
		line.push([stats[i].date, amount]);		
		
		//월별통계 표
		comboTag.head += "<th>"+stats[i].date+"</th>";
		comboTag.plus += "<td>"+stats[i].plus+"</td>";
		comboTag.minus += "<td>"+stats[i].minus+"</td>";	
		comboTag.sum += "<td>"+(stats[i].plus - Math.abs(stats[i].minus))+"</td>";
		
		//월별증감 표
		lineTag.head += "<th>"+stats[i].date+"</th>";
		lineTag.amount += "<td>"+amount+"</td>";
	}
	//월별통계 표 그리기
	$("#monthStatsList").append("<table class='table table-striped table-bordered table-sm'><tr>"
			+comboTag.head+"</tr><tr>"+common.comma(comboTag.plus)+"</tr><tr>"+common.comma(comboTag.minus)+"</tr>"
			+"<tr>"+common.comma(comboTag.sum)+"</tr></table>");
	
	//월별증감 표 그리기
	$("#monthAmountSumList").append("<table class='table table-striped table-bordered table-sm'><tr>"
		+lineTag.head+"</tr><tr>"+common.comma(lineTag.amount)+"</tr></table>");	
	
	
	//월별 통계 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization_combo);	
	function drawVisualization_combo() {
				
		let data = google.visualization.arrayToDataTable(combo);

		let options = {
			colors:['#6799FF','#F15F5F'],
			vAxis: {
				baseline : 0,
				viewWindowMode : 'maximized'
			},
			seriesType: 'bars',
			series: {5: {type: 'line'}}
		};
		
		let chart = new google.visualization.ComboChart(document.getElementById("monthStatsChart"));		
		chart.draw(data, options);
		
	}
	
	//월별 증감 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization_line);	
	function drawVisualization_line() {
				
		let data = google.visualization.arrayToDataTable(line);

		let options = {
			colors:['#6799FF'],
			vAxis: {
				baseline : 0,
				viewWindowMode : 'maximized'
			},
			seriesType: 'bars',
			series: {5: {type: 'line'}}
		};
		
		let chart = new google.visualization.ComboChart(document.getElementById("monthAmountSumChart"));		
		chart.draw(data, options);
		
	}
	
	
	
}
</script>

<div class="article">
	<ul class="nav nav-tabs" id="" role="tablist">
		<li class="nav-item">
			<a class="nav-link text-secondary active nsrb" id="monthTab" data-toggle="tab" href="#month" role="tab" aria-controls="month" aria-selected="true">Month</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="yearTab" data-toggle="tab" href="#year" role="tab" aria-controls="year" aria-selected="false">Year</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="purposeTab" data-toggle="tab" href="#purpose" role="tab" aria-controls="purpose" aria-selected="false">Purpose</a>
		</li>
	</ul>
	<div class="tab-content" id="statsTap">
		<div class="tab-pane fade show active" id="month" role="tabpanel" aria-labelledby="monthTab">
			<div id="monthStatsChart"></div>
			<div id="monthStatsList"></div>
			<div id="monthAmountSumChart"></div>
			<div id="monthAmountSumList"></div>
		</div>		
		<div class="tab-pane fade" id="year" role="tabpanel" aria-labelledby="yearTab">
			<div id="yearStatsChart"></div>
			<div id="yearStatsList"></div>
		</div>
		<div class="tab-pane fade" id="purpose" role="tabpanel" aria-labelledby="purposeTab">
			<div id="purposeStatsChart"></div>
			<div id="purposeStatsList"></div>
		</div>
	</div>
</div>
