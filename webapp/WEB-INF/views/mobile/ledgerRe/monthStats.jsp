<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">

let wdh = window.innerWidth;
let pfs = common.platformSize;

$(document).ready(function(){	
	monthStats();
	$("#chartDate").val(isDate.firstDay());
});

//월별 통계
function monthStats(date){
	
	$("#monthIEStatsChart").empty();
	$("#monthAmountSumChart").empty();
	$("#monthCashBankChart").empty();
	$("#monthPurposeP1Chart").empty();
	$("#monthPurposeP2Chart").empty();
	$("#monthPurposeP3Chart").empty();
	$("#monthPurposeP4Chart").empty();
	
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
	    	monthCBStatsDraw(data.CB);
	    	monthPStatsDraw(data.P);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});
}
//가계부 월별 통계 조회(수익, 지출, 누적)
function monthIEAStatsDraw(IEA){
	
	let combo = new Array();
	let area = new Array();
	
	let comboTag = wdh > pfs ? {head:"<th>날짜</th>", plus:"<td>수입</td>", minus:"<td>지출</td>", sum:"<td>합계</td>"}
		: "<th>날짜</th><th>수입</th><th>지출</th><th>합계</th>";
										   
	let areaTag = wdh > pfs ? {head:"<th>날짜</th>", amount:"<td>월별자금</td>"}
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
		if(wdh > pfs){
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
			wdh > pfs ? comboTag.head+"</tr><tr>"+comboTag.plus+"</tr><tr>"+comboTag.minus+"</tr>"
			+"<tr>"+comboTag.sum : comboTag  )+"</tr></table>");
	
	//월별누적 표 그리기
	$("#monthAmountSumList").append("<table class='table table-striped table-bordered table-sm'><tr>" + (
			wdh > pfs ? areaTag.head+"</tr><tr>"+areaTag.amount : areaTag )+"</tr></table>");	
	
	
	//월별 통계 차트 그리기
	google.charts.load('current', {'packages':['corechart']});	
	google.charts.setOnLoadCallback(drawVisualization_combo);	
	function drawVisualization_combo() {
				
		let data = google.visualization.arrayToDataTable(combo);

		let options = {
			title : '월별 수익/지출',
			titleTextStyle:{
				color: 'black',
				fontSize: wdh > pfs ? 20 : 15,
				bold: true,
				italic: false
			},
			legend :{
				position : wdh > pfs ? 'right' : 'top'
			},
			chartArea:{
				width: '80%'
			},
			colors:['#6799FF','#F15F5F'],			
			vAxis: {
				baseline : 0,
				viewWindowMode : wdh > pfs ? '' : 'maximized',
				format : wdh > pfs ? 'decimal' : 'short'
						
			},
			seriesType: 'bars'
		};
		
		let chart = new google.visualization.ComboChart(document.getElementById("monthIEStatsChart"));		
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
				fontSize: wdh > pfs ? 20 : 15,
				bold: true,
				italic: false
			},
			legend :{
				position : wdh > pfs ? 'right' : 'top'
			},
			chartArea:{
				width: '80%'
			},
			colors:['#6799FF'],
			vAxis: {
				baseline : 0,
				minValue: 0,
				viewWindowMode : wdh > pfs ? '' : 'maximized',
				format : wdh > pfs ? 'decimal' : 'short',
			},
		};
		
		let chart = new google.visualization.AreaChart(document.getElementById("monthAmountSumChart"));		
		chart.draw(data, options);		
	}	
}

//가계부 월별 통계 조회(현금, 은행별)
function monthCBStatsDraw(BC){
		
	let area = new Array();	
	let areaData = new Array();
	let areaTag = {head: "", data: ""};
	
	//제목 입력
	let bankList = BC[0].bankList;
	areaData.push("date");
	areaData.push("현금");	
	
	for(let i=0; i<bankList.length; i++){
		areaData.push(bankList[i].bankName);		
	}
	area.push(areaData);
	
	//데이터 입력	
	for(let i=1; i<BC.length; i++){
		if(i==1){
			areaData = new Array();
			areaData.push(BC[i].date);
			areaData.push(BC[0].cash + BC[i].cash);
			for(let j=0; j<bankList.length; j++){
				areaData.push(BC[0]["bank"+bankList[j].bankSeq] + BC[i]["bank"+bankList[j].bankSeq]);
			}
			area.push(areaData);
		}else{
			areaData = new Array();
			areaData.push(BC[i].date);
			areaData.push(area[i-1][1] + BC[i].cash);
			
			for(let j=0; j<bankList.length; j++){				
				areaData.push(area[i-1][j+2] + BC[i]["bank"+bankList[j].bankSeq]);
			}
			area.push(areaData);
		}
		
	}	

	//월별 현금,은행별 누적 차트 그리기
	google.charts.load('current', {'packages':['corechart']});
	google.charts.setOnLoadCallback(drawVisualization_area);	
	function drawVisualization_area() {
		
		let data = google.visualization.arrayToDataTable(area);

		let options = {
			title:'월별 종류별 자금현황',
			
			titleTextStyle:{
				color: 'black',
				fontSize: wdh > pfs ? 20 : 15,
				bold: true,
				italic: false
			},
			lineWidth : wdh > pfs ? 3 : 2,
			legend :{
				position : wdh > pfs ? 'right' : 'top',
				textStyle : {
					fontSize: wdh > pfs ? 10 : 7,
				}
			},
			chartArea:{
				width: '80%'
			},
			vAxis: {
				format : wdh > pfs ? 'decimal' : 'short',
				baseline : 0,
				minValue : 0,
				viewWindowMode : wdh > pfs ? '' : 'maximized'
			}
		};
		
		let chart = new google.visualization.AreaChart(document.getElementById("monthCashBankChart"));		
		chart.draw(data, options);
	}	
	
}

//가계부 월별 통계 조회(목적별)
function monthPStatsDraw(P){
	
	let purMap = P[0];
	
	let pie = null;
	let pieList = new Array();
	let pieTitle = new Array();
	
	let pieData = null;
	let keys = null;
	let monSum = 0;
	
	for(let i=1; i<P.length; i++){
		
		pie = new Array();
		monSum = 0;		
		
		//구분입력
		pieData = new Array();
		pieData.push("Purpose");
		pieData.push("money");
		pie.push(pieData);
		
		keys = Object.keys(P[i]);		
		
		//데이터 입력
		if(keys.length > 1){
			for(let j=1; j<keys.length; j++){			
				pieData = new Array();
				pieData.push(purMap[keys[j].replace("pur", "")]);
				pieData.push(P[i][keys[j]]);
				pie.push(pieData);
				monSum += P[i][keys[j]];
			}
		}else{
			pieData = new Array();
			pieData.push("No Data");
			pieData.push(1);
			pie.push(pieData);			
			monSum = 0;
		}
		
		pieTitle.push([P[i].date, monSum]);
		pieList.push(pie);
		
	}
	
	google.charts.load('current', {'packages':['corechart']});
	google.charts.setOnLoadCallback(drawVisualization_pie);	
	function drawVisualization_pie() {
		
		for(let i=0; i<pieList.length; i++){
		
		    let data = google.visualization.arrayToDataTable(pieList[i]);
			let options = {
				title: pieTitle[i][0]+" ("+common.comma(pieTitle[i][1])+")",
				chartArea: {
					width:'100%'
				},
				pieHole: 0.4
			};
			
			let chart = new google.visualization.PieChart(document.getElementById('monthPurposeP'+(i+1)+'Chart'));
			chart.draw(data, options);
		}
	}
}
</script>

<div class="article">
	<div class="input-group w-25 blank">
		<input id="chartDate" class="form-control" type="text" value="">
		<div class="input-group-append">
			<button class="btn btn-outline-secondary" type="button">Search</button>
		</div>
	</div>
	<!-- 월별 수입지출 통계 -->
	<div class="chart-height" id="monthIEStatsChart"></div>
	<div id="monthStatsList"></div>
	
	<!-- 월별 누적통계 -->
	<div class="chart-height" id="monthAmountSumChart"></div>
	<div id="monthAmountSumList"></div>
	
	<!-- 월별 현금, 은행별 통계 -->
	<div class="chart-height" id="monthCashBankChart"></div>
	<%-- <div id="monthCashBankList"></div> 추후 업데이트--%>
	
	<!-- 월별 목적별 통계 -->
	<div>
		<h6 style="margin-left:10%;  font-family:Arial; font-size:20px; font-weight:bold";><strong>월별 목적별 지출통계</strong></h6>
		<div class="chart-height purChart" id="monthPurposeP1Chart"></div>
		<div class="chart-height purChart" id="monthPurposeP2Chart"></div>
		<div class="chart-height purChart" id="monthPurposeP3Chart"></div>
		<div class="chart-height purChart" id="monthPurposeP4Chart"></div>
	</div>			
	<%-- <div id="monthPurposeList"></div> 추후 업데이트--%>
</div>
