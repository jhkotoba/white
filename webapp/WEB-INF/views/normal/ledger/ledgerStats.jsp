<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/jqplot/css/jquery.jqplot.css" type="text/css" />
<style>
.jqplot-target {color: rgba(246, 246, 246, .7); font-size: 1.2em;}
.monthIEBtns{position: absolute; right: 23px; top: 162px; width: 30px;}
table.jqplot-table-legend, table.jqplot-cursor-legend {background-color: rgba(255,255,255,0); border: 0px solid rgba(204,204,204,0);}
div.jqplot-table-legend-swatch-outline {border: 1px solid #585858;}
.selected-month{border: 2px solid rgba(94,94,94,0.5); border-radius: 3px; background-color: rgba(94,94,94,0.5);}
</style>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/jquery.jqplot.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.barRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.categoryAxisRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.pointLabels.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.highlighter.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.canvasTextRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.canvasAxisTickRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.pieRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.donutRenderer.js"></script>
<script type="text/javascript">
/* 전역변수 */
let mIE = {	
	firstDate : null,
	chartData : null,
	orgData : null,
	lineCnt : 12,
	minLineCnt : 8,
	stdDate : isDate.today()
}

$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectFirstRecordDate").done(function(data){
		mIE.firstDate = data.firstDate.substr(0,7);
		
		//월별 수입지출 그래프
		cfnCmmAjax("/ledger/selectLedgerStats", {type:"monthIE", monthCnt: mIE.lineCnt, stdate:isDate.today()}).done(function(data){
			mIE.orgData = data;
			fnMonthIEChart(data);
		});		
		
		/* //선택월 목적 그래프
		cfnCmmAjax("/ledger/selectLedgerStats", {type:"monthPur", stdate:isDate.today(), inEx:1}).done(function(data){
			console.log(data);
			fnMonthPurChart(data);
		}); */
	});
});

/*월별 수입지출 누적 통계*/
function fnMonthIEChart(data){

	//데이터 가공
	mIE.chartData = fnMonthIEChartProcess(data);
	let width = window.outerWidth-45 < 1400 ? 1370 : window.outerWidth-45;	
	
	//리사이즈 설정
	let timer = null;
	$(window).off().on("resize", function(){
	    clearTimeout(timer);
	    timer = setTimeout(function(){
	    	if(window.outerWidth > 1400){
	    		fnMonthIEChartDraw(mIE.chartData, window.outerWidth-45);
			}
	    }, 300);
	});
	
	//그래프 그리기
	fnMonthIEChartDraw(mIE.chartData, width);	
    
	//그래프바 클릭 이벤트
    $("#monthIEChart").off().on("jqplotClick", function(ev, gridpos, datapos, neighbor, plot){
    	if(neighbor !== null){
    		fnSelectMonthIE(neighbor.pointIndex);
    		
    		console.log(ev);
    		//pageX: 1221
    		//pageY: 350
    		//offsetHeight: 515
			//offsetLeft: 57
			//offsetParent: div#monthIEChart.jqplot-target
			//offsetTop: 10
			//offsetWidth: 1327
			console.log("ev.target.offsetTop:"+ev.target.offsetTop);
			console.log("ev.target.offsetLeft:"+ev.target.offsetLeft);
    		$("#monthPurChart").offset({top: ev.target.offsetTop+ev.pageY-300, left: ev.target.offsetLeft});
    		//$target.offset()
    		
    		let param = {type:"monthPur", stdate:mIE.chartData.categories[neighbor.pointIndex]+"-01", inEx:neighbor.seriesIndex};
    		cfnCmmAjax("/ledger/selectLedgerStats", param).done(function(data){    			
    			fnMonthPurChart(data);
    		});	
    	}
    });
}

//그래프 데이터 가공
function fnMonthIEChartProcess(data){
	let list = data.list;
	
	let chartData = {};
	chartData.firstDate  = data.firstDate;
	chartData.prevAmount = data.amount;	
	chartData.categories= new Array();
	chartData.income = new Array();
	chartData.expense = new Array();
	chartData.amount = new Array();
	chartData.maxAmount = 0;
	
	for(let i=0; i<list.length; i++){
		if(list[i].purTypeCd === "LP001"){
			chartData.income.push(list[i].money);
			chartData.categories.push(list[i].startDate.split(" ")[0].substr(0,7));
			chartData.prevAmount += list[i].money;
		}else if(list[i].purTypeCd === "LP002"){
			chartData.expense.push(Math.abs(list[i].money));
			chartData.prevAmount += list[i].money;
			chartData.amount.push(chartData.prevAmount);
		}
		chartData.maxAmount = chartData.maxAmount > Math.abs(list[i].money) ? chartData.maxAmount : Math.abs(list[i].money);
	}
	return chartData;
}

//그래프 그리기
function fnMonthIEChartDraw(data, width){
	$("#monthIEChart").empty();
	
	let icM = common.clone(data.income);
	let exM = common.clone(data.expense);
	for(let i=0; i<icM.length; i++){
		if(icM[i]>10000){
			icM[i] = Math.floor(icM[i]/10000);
		}else icM[i] = 0;
		if(exM[i]>10000){
			exM[i] = Math.floor(exM[i]/10000)
		}else exM[i] = 0;
	}
	
	//그래프바 굻기 설정
	let barWidth = 0
	if(data.income.length <= 20){
		barWidth = 28;
	}else{
		barWidth = 28-(data.income.length/2+1);
	}
	
	//기울기 설정
	let xAngle = 0;
	if(barWidth > 11){
		xAngle = 0;
	}
	else if(barWidth > 1){
		xAngle = 30;
	}else if(barWidth > -3){
		xAngle = 70;
	}else{
		xAngle = 90;
	}
	if(barWidth <= 3) barWidth = 5;
	
	let plot = $.jqplot('monthIEChart', [data.income, data.expense, data.amount], {
    	width: width,
    	height: 550,
    	
    	animate: true,
    	animateReplot: true,
    	legend: {
    		show: true,
    		placement: "outsideGrid",
    		location: "ne",
    		labels: ["수입", "지출", "자금"]    
    	},    	
    	seriesColors:["rgba(67, 116, 217, .73)", "rgba(204, 61, 61, .73)", "#8DB72A"],
        series:
        	[{
			    pointLabels: {
			        show: true,
			        labels: xAngle < 30 ? data.income : icM,
			        hideZeros : true,
			        fillToZero : false
			    },
			    renderer: $.jqplot.BarRenderer,
			    showHighlight: false,
			    yaxis: 'yaxis',
			    rendererOptions: {                   
			        animation: {
			            speed: 1500
			        },
			        barWidth: barWidth,				        
			        highlightMouseOver: true
				}
        	},					
			{
                pointLabels: {
                    show: true,
                    labels: xAngle < 30 ? data.expense : exM,
                	hideZeros : true,
    			    fillToZero : false
                },
                renderer: $.jqplot.BarRenderer,
                showHighlight: false,
                yaxis: 'y2axis',
                rendererOptions: {                   
                    animation: {
                        speed: 1500
                    },
                    barWidth: barWidth,
                    highlightMouseOver: true
                }
			},
			{
                pointLabels: {
                    show: false
                },	                
                showHighlight: true,
                yaxis: 'y3axis',
                rendererOptions: {                   
                    animation: {
                        speed: 1500,	                        
                    },	                   
                    highlightMouseOver: false
				}
			}
	   	],
        grid: {
            drawBorder: true,           
            background: "rgba(76, 76, 76, .3)",
            shadow: false,
            borderWidth: 1,
            drawGridlines:true,
            gridLineColor:"rgba(76, 76, 76, .5)"
        },       
        axes: {
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                ticks: data.categories,
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                	formatString: "%'d",
                	textColor: "rgba(246, 246, 246, .7)",
                    angle: xAngle
                }
            },                      
            yaxis:{
            	min:0,
            	max:cfnNumRaise(data.maxAmount),
            	tickOptions: {
                	formatString: "%'d"
                }
            },
            y2axis:{
            	min:0,
            	max:cfnNumRaise(data.maxAmount),
            	tickOptions: {            		
            		show:false,
                	formatString: "%'d"
                }
            },
            y3axis:{
            	min:0,
            	tickOptions: {
                	formatString: "%'d"
                }
            }
            
        },        
        highlighter: {
            show: true, 
            showLabel: true, 
            tooltipAxes: 'y',
            sizeAdjust: 7.5 , tooltipLocation : 'ne'
        },
        markerOptions:{
        	show: true
        }
    });
	
	//초기화 버튼
	let $refreshBtn = $("<button>").addClass("btn-gray-icon-rfh trs mgbottom3").off().on("click", function(){		
		mIE.lineCnt = 12;
		mIE.stdDate = isDate.today();
		mIE.chartData = fnMonthIEChartProcess(mIE.orgData);
    	fnMonthIEChartDraw(mIE.chartData, width);    	
    }).attr("title", "그래프 새로고침");
    
	//이전으로가기 버튼
    let $prevBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text("<").off().on("click", function(){
    	fnChangeChartDraw(width, 0, data.categories[0]+"-01");
    }).attr("title", data.categories[0] + "월 이전 통계");
	
	//이후으로가기 버튼
    let $nextBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text(">").off().on("click", function(){
    	fnChangeChartDraw(width, 0, cfnDateCalc(data.categories[data.categories.length-1]+"-01", "month", mIE.lineCnt-1));
    }).attr("title", data.categories[data.categories.length-1] + "월 이후 통계");  	
	
	//그래프 범위 증가
    let $minusBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text("-").off().on("click", function(){
    	if(mIE.firstDate < data.categories[0]) fnChangeChartDraw(width, 12);
    }).attr("title", "그래프 범위 증가");
	
  	//그래프 범위 증가
    let $minusMaxBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text("--").off().on("click", function(){
    	if(mIE.firstDate < data.categories[0]) fnChangeChartDraw(width, 12);
    }).attr("title", "그래프 범위 증가");
  	
	//그래프 범위 감소
    let $plusBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text("+").off().on("click", function(){
    	if(mIE.lineCnt > mIE.minLineCnt) fnChangeChartDraw(width, -4);    	
    }).attr("title", "그래프 범위 감소");	
	
  	//그래프 범위 감소
    let $plusMaxBtn = $("<button>").addClass("btn-gray-icon trs mgbottom3").text("++").off().on("click", function(){
    	if(mIE.lineCnt > mIE.minLineCnt) fnChangeChartDraw(width, -12);    	
    }).attr("title", "그래프 범위 감소");  	
    
    let $btns = $("<div>").addClass("monthIEBtns");
    $btns.append($refreshBtn).append($prevBtn).append($nextBtn).append($plusBtn).append($plusMaxBtn).append($minusBtn).append($minusMaxBtn);    
    $("#monthIEChart").append($btns);
    
    //포인터라이블 기울기 설정(그래프 생생후 조정)
    if(xAngle === 70) $(".jqplot-point-label").css("transform", "rotate(35deg)");
    else if(xAngle === 90) $(".jqplot-point-label").css("transform", "rotate(80deg)");
    
    fnSelectMonthIE(mIE.lineCnt-1);
}

//선택 월  표시
function fnSelectMonthIE(idx){
	$(".jqplot-xaxis-tick").removeClass("selected-month");
	$($(".jqplot-xaxis-tick")[idx]).addClass("selected-month");
}

//그래프 재 생성
function fnChangeChartDraw(width, count, stdDate){	
	if(stdDate !== null || stdDate !== undefined) mIE.stdDate = stdDate;	
	
	mIE.lineCnt += count;
	cfnCmmAjax("/ledger/selectLedgerStats", {type:"monthIE", monthCnt: mIE.lineCnt, stdate:mIE.stdDate}).done(function(data){    			
		mIE.chartData = fnMonthIEChartProcess(data);
		fnMonthIEChartDraw(mIE.chartData, width);    			
	});
}


/*월별 목적별 통계*/
function fnMonthPurChart(data){
	
	//$("#monthIEChart").hide();
	$("#monthPurChart").empty();	
	
	//데이터 가공
	let list = fnMonthPurChartProcess(data);
	let width = window.outerWidth-45 < 1400 ? 1370 : window.outerWidth-45;
	
	//리사이즈 설정	
	
	//그래프 그리기	 
    fnMonthPurChartDraw(list, width);
	
	//그래프바 클릭 이벤트   	 
}

//목적 그래프 데이터 가공
function fnMonthPurChartProcess(data){	
	let list = new Array();
	for(let i=0; i<data.list.length; i++){		
		list.push([data.list[i].purpose, data.list[i].money]);
	}
	return list;
}

//목적 그래프 그리기
function fnMonthPurChartDraw(list, width){
	let plotPur = jQuery.jqplot("monthPurChart", [list],{
		width: width,
    	height: 550,
		seriesDefaults: {
			shadow: true,
			renderer: $.jqplot.DonutRenderer,
			rendererOptions:{
	            sliceMargin: 3,	            
	            startAngle: -30,
	            showDataLabels: true,	            
	            dataLabels: 'value',	            
	            totalLabel: true          
	          }
		}, 
		grid: {
            drawBorder: true,           
            background: "rgba(76, 76, 76, .6)",
            shadow: false,
            borderWidth: 1,
            drawGridlines:true,
            gridLineColor:"rgba(76, 76, 76, .7)"
        },       
        legend: {
    		show: true,
    		placement: "insideGrid",
    		location: "ne"    		   
    	}
        
    });
}
</script>

<div id="monthIEChart"></div>
<div id="monthPurChart" class="dialog-sm"></div>


