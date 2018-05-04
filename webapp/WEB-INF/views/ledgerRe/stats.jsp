<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	monthStats();
	$("#chartDate").val(isDate.firstDay());
		
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		switch(e.target.id){
		case "monthTab":
			monthStats();
			break;
		case "yearTab":
			//recordYearStats("year");
			break;
		}
	});
});

//월별 통계
function monthStats(date){
	
	$("#monthStatsChart").empty();
	$("#monthStatsList").empty();
	
	let param = {};
	if(emptyCheck.isEmpty(date)){
		param.date = isDate.firstDay();
	}else{
		param.date = date;
	}
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/ledgerRe/selectMonthStats.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	monthIEAStatsDraw(data.IEA);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});
}
//월별 통계
function monthIEAStatsDraw(IEA){
	
	let combo = new Array();
	let area = new Array();
	
	let comboTag = window.innerWidth > common.platformSize 
		? {head:"<th>날짜</th>", plus:"<td>수입</td>", minus:"<td>지출</td>", sum:"<td>합계</td>"}
		: "<th>날짜</th><th>수입</th><th>지출</th><th>합계</th>";
										   
	let areaTag = window.innerWidth > common.platformSize 
		? {head:"<th>날짜</th>", amount:"<td>월별자금</td>"}
	 	: "<th>날짜</th><th>월별자금</th>";
	 									  
	combo.push(['date', '수입', '지출']);
	area.push(['date', '월별자금']);
	let amount = IEA[0].stAmount;
	
	for(let i=0; i<IEA.length; i++){
		//월별통계 차트
		combo.push([IEA[i].date, IEA[i].plus, Math.abs(IEA[i].minus)]);
		
		//월별누적 차트
		amount += (IEA[i].plus - Math.abs(IEA[i].minus));
		area.push([IEA[i].date, amount]);		
		
		//데스크탑
		if(window.innerWidth > common.platformSize){
			//월별통계 표
			comboTag.head += "<th>"+IEA[i].date+"</th>";
			comboTag.plus += "<td>"+common.comma(IEA[i].plus)+"</td>";
			comboTag.minus += "<td>"+common.comma(IEA[i].minus)+"</td>";	
			comboTag.sum += "<td>"+common.comma(IEA[i].plus - Math.abs(IEA[i].minus))+"</td>";
			
			//월별누적 표
			areaTag.head += "<th>"+IEA[i].date+"</th>";
			areaTag.amount += "<td>"+common.comma(amount)+"</td>";
		
		//모바일
		}else{
			//월별통계 표
			comboTag += "<tr><th>"+IEA[i].date+"</th>";
			comboTag += "<td>"+common.comma(IEA[i].plus)+"</td>";
			comboTag += "<td>"+common.comma(IEA[i].minus)+"</td>";	
			comboTag += "<td>"+common.comma(IEA[i].plus - Math.abs(IEA[i].minus))+"</td></tr>";
			
			//월별누적 표
			areaTag += "<tr><th>"+IEA[i].date+"</th>";
			areaTag += "<td>"+common.comma(amount)+"</td></tr>";
		}
		
	}
	//월별통계 표 그리기
	$("#monthStatsList").append("<table class='table table-striped table-bordered table-sm'><tr>" + (
			window.innerWidth > common.platformSize ? comboTag.head+"</tr><tr>"+comboTag.plus+"</tr><tr>"+comboTag.minus+"</tr>"
			+"<tr>"+comboTag.sum : comboTag  )+"</tr></table>");
	
	//월별누적 표 그리기
	$("#monthAmountSumList").append("<table class='table table-striped table-bordered table-sm'><tr>" + (
			window.innerWidth > common.platformSize ? areaTag.head+"</tr><tr>"+areaTag.amount : areaTag )+"</tr></table>");	
	
	
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
	
	//월별 누적 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization_area);	
	function drawVisualization_area() {
		
		let data = google.visualization.arrayToDataTable(area);

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
	</ul>
	<div class="tab-content" id="statsTap">
		<div class="tab-pane fade show active" id="month" role="tabpanel" aria-labelledby="monthTab">
			<div class="input-group w-25 updown-spacing">
				<input id="chartDate" class="form-control" type="text" value="">
				<div class="input-group-append">
					<button class="btn btn-outline-secondary" type="button">Search</button>
				</div>
			</div>
			<!-- 월별 통계 -->
			<div class="chart-height" id="monthStatsChart"></div>
			<div id="monthStatsList"></div>
			
			<!-- 월별 누적통계 -->
			<div class="chart-height" id="monthAmountSumChart"></div>
			<div id="monthAmountSumList"></div>
			
			<!-- 월별 현금, 은행별 통계 -->
			<div class="chart-height" id="monthCashBankChart"></div>
			<div id="monthCashBankList"></div>
			
			<!-- 월별 목적별 통계 -->
			<div class="chart-height" id="monthPurposeChart"></div>
			<div id="monthPurposeList"></div>
			
		</div>		
		<div class="tab-pane fade" id="year" role="tabpanel" aria-labelledby="yearTab">
			<div class="chart-height" id="yearStatsChart"></div>
			<div id="yearStatsList"></div>
		</div>
	</div>
</div>
