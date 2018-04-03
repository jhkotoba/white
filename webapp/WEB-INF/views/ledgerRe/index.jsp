<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/record.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/memo/memo.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	//ledger 메모 리스트 조회
	memo.select("ledger");
	
	//새로운 메모 추가
	$("#memoAddBt").click(function(){
		memo.add();
	});	
	//취소
	$("#memoCancelBt").click(function(){
		memo.cancel();
	});	
	//메모 저장
	$("#memoSaveBt").click(function(){	
		memo.insert();
	});	
	
	//메인조회 리스트
	$("#startDate").val(isDate.addMonToday(-1));
	$("#endDate").val(isDate.today());
	$("span[name=date]").text($("#startDate").val() +" ~ "+$("#endDate").val());
		
	let param = {};	
	param.startDate = $("#startDate").val() + " 00:00:00";
	param.endDate = $("#endDate").val() + " 23:59:59";
	param.mode = "index";
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectRecordList.ajax',	
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	chart.view(data.recList);
	    	rec.init("index", data.recList, data.purList, data.purDtlList, data.bankList).view();	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	let chart = {
		view : function(recList){
			
			let record = new Array();
			let recAve = 0;
			
			record.push(['Date', '지출']);
			for(let i=0; i<recList.length; i++){
				if(recList[i].purSeq !== 0){
					if(recList[i].money < 0){						
						if(record[record.length-1][0] === recList[i].recordDate){
							record[record.length-1][1] += Math.abs(recList[i].money);
							recAve += record[record.length-1][1];
						}else{
							record.push([recList[i].recordDate, Math.abs(recList[i].money)]);
							recAve += record[record.length-1][1];
						}						
					}
				}				
			}
			recAve = Math.floor(recAve/record.length);
			
			google.charts.load('current', {'packages':['corechart']});
			
			//comboChart
			google.charts.setOnLoadCallback(drawVisualization);
			function drawVisualization() {
				let data = google.visualization.arrayToDataTable(record);

				let options = {
					axisTitlesPosition : 'none',
					chartArea: {
						width:'60%',
						height:'300px'
					},
					colors:['#F15F5F'],
					vAxis: {
						baseline : 0,
						viewWindow : {
							max : recAve*2,
							min : 0
						},
						viewWindowMode : 'maximized'
					},
					seriesType: 'bars',
					series: {5: {type: 'line'}}
				};

				let chart = new google.visualization.ComboChart(document.getElementById('comboChart'));
				chart.draw(data, options);
			}

			//donutChart
			google.charts.setOnLoadCallback(drawChart);
			function drawChart() {
				let data = google.visualization.arrayToDataTable([
					['Task', 'Hours per Day'],
					['Work',     11],
					['Eat',      2],
					['Commute',  2],
					['Watch TV', 2],
					['Sleep',    7]
			    ]);

				let options = {
					title: '',
					chartArea: {
						width:'80%',
						height:'300px'
					},
					pieHole: 0.4,
				};

				let chart = new google.visualization.PieChart(document.getElementById('donutChart'));
				chart.draw(data, options);
			}
		}
	}
});
</script>

</head>
<body>
	<span class="article" name="date"></span>
	<div class="article">
		<div class="left width-vmin">
			<div id="comboChart" class="form-control height-default">
			</div>
		</div>
		
		<div class="left width-vmin">
			<div id="donutChart" class="form-control height-default">
			</div>
		</div>		
	</div>
	
	<div class="space left"></div>
	
	<div id="ledgerMemo" class="article">
		<div class="btn-group btn-group-sm width-full" role="group">
			<button id="memoAddBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">메모 추가</button>
			<button id="memoSaveBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">메모 저장</button>
			<button id="memoCancelBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">취소</button>
		</div>
	
		<div id='memoTb'>
		</div>
	</div>
	

	<input id="startDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">
	
	<div class="space left"></div>
	
	<span class="article" name="date"></span>
	<div id="ledgerReList" class="article">		
	</div>
		
	
</body>
</html>
