<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/record.js?ver=1.00"></script>
<script type="text/javascript" src="${contextPath}/resources/js/memo/memo.js?ver=1.03"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

let wdh = window.innerWidth;
let pfs = common.platformSize;

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
	    	rec.initPB(data.purList, data.purDtlList, data.bankList).initRec("index", data.recList).view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	let chart = {
		view : function(recList){
			
			google.charts.load('current', {'packages':['corechart']});
			
			//comboChart
			let recCombo = new Array();
			let recAve = 0;
			
			recCombo.push(['Date', '지출']);
			if(recList.length === 0){
				recAve = 5000;
				recCombo.push(["No Data", 0]);
			}else{
				for(let i=0; i<recList.length; i++){
					if(recList[i].purSeq !== 0){
						if(recList[i].money < 0){						
							if(recCombo[recCombo.length-1][0] === recList[i].recordDate.split(" ")[0]){
								recCombo[recCombo.length-1][1] += Math.abs(recList[i].money);
								recAve += recCombo[recCombo.length-1][1];
							}else{
								recCombo.push([recList[i].recordDate.split(" ")[0], Math.abs(recList[i].money)]);
								recAve += recCombo[recCombo.length-1][1];
							}						
						}
					}				
				}
				recAve = Math.floor(recAve/recCombo.length);
			}
			
			google.charts.setOnLoadCallback(drawVisualization);
			function drawVisualization() {
				let data = google.visualization.arrayToDataTable(recCombo);

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
			let recDonut = new Array();
			let purpose = new Object();
			
			recDonut.push(['Purpose', 'money']);
			if(recList.length === 0){				
				recDonut.push(["No Data", 1]);
			}else{
				for(let i=0; i<recList.length; i++){
					if(recList[i].purSeq !== 0){
						if(recList[i].money < 0){						
							if(emptyCheck.isEmpty(purpose[recList[i].purpose])){								
								purpose[recList[i].purpose] = Math.abs(recList[i].money);								
							}else{								
								purpose[recList[i].purpose] = purpose[recList[i].purpose]+Math.abs(recList[i].money);								
							}						
						}
					}				
				}
				let purKeys = Object.keys(purpose);				
				for(let i=0; i<purKeys.length; i++){
					recDonut.push([purKeys[i], purpose[purKeys[i]]]);
				}
			}
			
			google.charts.setOnLoadCallback(drawChart);
			function drawChart() {

			    let data = google.visualization.arrayToDataTable(recDonut);
			    
				let options = {
					axisTitlesPosition : 'none',
					chartArea: {
						width:'100%',
						height:'300px'
					},
					pieHole: 0.4
				};

				let chart = new google.visualization.PieChart(document.getElementById('donutChart'));
				chart.draw(data, options);
			}
		}
	}
});
</script>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
	<h1 class="h2 nsrb">가계부</h1>
</div>

<span class="article" name="date"></span>
<div class="article">
	<div class="left width-vmin">
		<div id="comboChart" class="form-control default-height">
		</div>
	</div>
	
	<div class="left width-vmin">
		<div id="donutChart" class="form-control default-height">
		</div>
	</div>		
</div>

<div class="space left"></div>

<div id="ledgerMemo" class="article">
	<div class="btn-group btn-group-sm width-full" role="group">
		<button id="memoAddBt" type="button" class="btn btn-secondary btn-fs nsrb">메모 추가</button>
		<button id="memoSaveBt" type="button" class="btn btn-secondary btn-fs nsrb">메모 저장</button>
		<button id="memoCancelBt" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
	</div>
	
	<div style="width: 100%; height: 10px;"></div>
	
	<div id='memoList'>
	</div>
</div>


<input id="startDate" type="hidden" value="">
<input id="endDate" type="hidden" value="">

<div class="space left"></div>

<span class="article" name="date"></span>
<div id="ledgerReList" class="article">		
</div>

