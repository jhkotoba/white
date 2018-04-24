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
	    	statsDraw(data, tap);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});
}

function statsDraw(stats, tap){
	
	let combo = new Array();
	let tag = {head:"<th>날짜</th>", plus:"<td>수입</td>", minus:"<td>지출</td>", sum:"<td>합계</td>"};
	
	combo.push(['date', '수입', '지출']);
	for(let i=0; i<stats.length; i++){
		//통계 차트
		combo.push([stats[i].date, stats[i].plus, Math.abs(stats[i].minus)]);		
		
		//통계 표
		tag.head += "<th>"+stats[i].date+"</th>";
		tag.plus += "<td>"+stats[i].plus+"</td>";
		tag.minus += "<td>"+stats[i].minus+"</td>";	
		tag.sum += "<td>"+(stats[i].plus - Math.abs(stats[i].minus))+"</td>";	
	}
	//통계 표 그리기
	$("#"+tap+"StatsList").append("<table class='table table-striped table-bordered table-sm'><tr>"
			+tag.head+"</tr><tr>"+common.comma(tag.plus)+"</tr><tr>"+common.comma(tag.minus)+"</tr>"
			+"<tr>"+common.comma(tag.sum)+"</tr></table>");
	
	//통계 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization);	
	function drawVisualization() {
				
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
		
		let chart = new google.visualization.ComboChart(document.getElementById(tap+'StatsChart'));		
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
