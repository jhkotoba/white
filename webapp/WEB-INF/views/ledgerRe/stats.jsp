<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	recordStats("month");
	$("#chartDate").val(isDate.firstDay());
		
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
	
	let combo = new Array();
	let line = new Array();
	
	let comboTag = window.innerWidth > common.platformSize 
		? {head:"<th>날짜</th>", plus:"<td>수입</td>", minus:"<td>지출</td>", sum:"<td>합계</td>"}
		: "<th>날짜</th><th>수입</th><th>지출</th><th>합계</th>";
										   
	let lineTag = window.innerWidth > common.platformSize 
		? {head:"<th>날짜</th>", amount:"<td>월별자금</td>"}
	 	: "<th>날짜</th><th>월별자금</th>";
	 									  
	combo.push(['date', '수입', '지출']);
	line.push(['date', '월별자금']);
	let amount = stats[0].stAmount;
	
	for(let i=0; i<stats.length; i++){
		//월별 통계 차트
		combo.push([stats[i].date, stats[i].plus, Math.abs(stats[i].minus)]);
		
		//월별 증감 차트
		amount += (stats[i].plus - Math.abs(stats[i].minus));
		line.push([stats[i].date, amount]);		
		
		//데스크탑
		if(window.innerWidth > common.platformSize){
			//월별통계 표
			comboTag.head += "<th>"+stats[i].date+"</th>";
			comboTag.plus += "<td>"+common.comma(stats[i].plus)+"</td>";
			comboTag.minus += "<td>"+common.comma(stats[i].minus)+"</td>";	
			comboTag.sum += "<td>"+common.comma(stats[i].plus - Math.abs(stats[i].minus))+"</td>";
			
			//월별증감 표
			lineTag.head += "<th>"+stats[i].date+"</th>";
			lineTag.amount += "<td>"+common.comma(amount)+"</td>";
		
		//모바일
		}else{
			//월별통계 표
			comboTag += "<tr><th>"+stats[i].date+"</th>";
			comboTag += "<td>"+common.comma(stats[i].plus)+"</td>";
			comboTag += "<td>"+common.comma(stats[i].minus)+"</td>";	
			comboTag += "<td>"+common.comma(stats[i].plus - Math.abs(stats[i].minus))+"</td></tr>";
			
			//월별증감 표
			lineTag += "<tr><th>"+stats[i].date+"</th>";
			lineTag += "<td>"+common.comma(amount)+"</td></tr>";
		}
		
	}
	//월별통계 표 그리기
	$("#monthStatsList").append("<table class='table table-striped table-bordered table-sm'><tr>" + (
			window.innerWidth > common.platformSize ? comboTag.head+"</tr><tr>"+comboTag.plus+"</tr><tr>"+comboTag.minus+"</tr>"
			+"<tr>"+comboTag.sum : comboTag  )+"</tr></table>");
	
	//월별증감 표 그리기
	$("#monthAmountSumList").append("<table class='table table-striped table-bordered table-sm'><tr>" + (
			window.innerWidth > common.platformSize ? lineTag.head+"</tr><tr>"+lineTag.amount : lineTag )+"</tr></table>");	
	
	
	//월별 통계 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization_combo);	
	function drawVisualization_combo() {
				
		let data = google.visualization.arrayToDataTable(combo);

		let options = {
			title : '월별 수익/지출',
			titleTextStyle:{
				color: 'black',
				fontSize: window.innerWidth > common.platformSize ? 20 : 15,
				bold: true,
				italic: false
			},
			chartArea:{
				width: window.innerWidth > common.platformSize ? '85%' : '60%'
			},
			colors:['#6799FF','#F15F5F'],			
			vAxis: {
				baseline : 0,
				viewWindowMode : window.innerWidth > common.platformSize ? '' : 'maximized'
			},
			seriesType: 'bars'
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
			title:'월별 자금현황',
			titleTextStyle:{
				color: 'black',
				fontSize: window.innerWidth > common.platformSize ? 20 : 15,
				bold: true,
				italic: false
			},
			chartArea:{
				width: window.innerWidth > common.platformSize ? '85%' : '60%'
			},
			colors:['#6799FF'],
			vAxis: {
				baseline : 0,
				minValue: 0,
				viewWindowMode : window.innerWidth > common.platformSize ? '' : 'maximized'
			},
		};
		
		let chart = new google.visualization.AreaChart(document.getElementById("monthAmountSumChart"));		
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
			<div class="input-group w-25 updown-spacing">
				<input id="chartDate" class="form-control" type="text" value="">
				<div class="input-group-append">
					<button class="btn btn-outline-secondary" type="button">Search</button>
				</div>
			</div>	
			<div class="chart-height" id="monthStatsChart"></div>
			<div id="monthStatsList"></div>
			
			<div class="chart-height" id="monthAmountSumChart"></div>
			<div id="monthAmountSumList"></div>
		</div>		
		<div class="tab-pane fade" id="year" role="tabpanel" aria-labelledby="yearTab">
			<div class="chart-height" id="yearStatsChart"></div>
			<div id="yearStatsList"></div>
		</div>
		<div class="tab-pane fade" id="purpose" role="tabpanel" aria-labelledby="purposeTab">
			<div class="chart-height" id="purposeStatsChart"></div>
			<div id="purposeStatsList"></div>
		</div>
	</div>
</div>
