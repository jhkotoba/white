<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/tui.chart/css/tui-chart.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/jqplot/css/jquery.jqplot.css" type="text/css" />
<style>
.jqplot-target {color: rgba(246, 246, 246, .7); font-size: 1.2em;}
</style>
<script type="text/javascript" src="${contextPath}/resources/tui.chart/js/tui-chart-all.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/jquery.jqplot.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.barRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.categoryAxisRenderer.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.pointLabels.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jqplot/js/plugins/jqplot.highlighter.js"></script>
<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectLedgerStats", {type:"monthIE", monthCnt:12, stdate:isDate.today()}).done(function(data){		
		fnMonthStats(data, window.outerWidth-45 < 1400 ? 1370 : window.outerWidth-45);
	
	});
});

function fnMonthStats(data, width){
	$("#monthChart").empty();
	
	let list = data.list;
	let prevAmount = data.amount;
	
	let categories = new Array();
	let income = new Array();
	let expense = new Array();
	let amount = new Array();
	let maxAmount = 0;	
	
	for(let i=0; i<list.length; i++){
		
		if(list[i].purTypeCd === "LP001"){
			income.push(list[i].money);
			categories.push(list[i].startDate.split(" ")[0].substr(0,7));
			prevAmount += list[i].money;
		}else if(list[i].purTypeCd === "LP002"){
			expense.push(Math.abs(list[i].money));
			prevAmount += list[i].money;
			amount.push(prevAmount);
		}
		
		maxAmount = maxAmount > Math.abs(list[i].money) ? maxAmount : Math.abs(list[i].money);
	}
	
    let plot = $.jqplot('monthChart', [income, expense, amount], {
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
    	seriesColors:["#4374D9", "#CC3D3D", "#9FC93C"],       
        series:
        	[{
			    pointLabels: {
			        show: true
			    },
			    renderer: $.jqplot.BarRenderer,
			    showHighlight: false,
			    yaxis: 'yaxis',
			    rendererOptions: {                   
			        animation: {
			            speed: 1500
			        },
			        barWidth: 28,				        
			        highlightMouseOver: false
				}			    
        	},					
			{
                pointLabels: {
                    show: true
                },
                renderer: $.jqplot.BarRenderer,
                showHighlight: false,
                yaxis: 'y2axis',
                rendererOptions: {                   
                    animation: {
                        speed: 1500
                    },
                    barWidth: 28,
                    highlightMouseOver: false
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
                ticks: categories
            },                      
            yaxis:{
            	min:0,
            	tickOptions: {
                	formatString: "%'d"
                }
            },
            y2axis:{
            	min:0,
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
    
    
    $("#monthChart").off().on("jqplotClick", function(ev, gridpos, datapos, neighbor, plot){    	
    	let param = {};
    	param.type = "monthIE";
    	param.monthCnt = 12;
    	param.stdate = cfnDateCalc(categories[neighbor.pointIndex]+"-01", "month", 6);
    	
    	cfnCmmAjax("/ledger/selectLedgerStats", param).done(function(list){
    		stats = list;
    		fnMonthStats(list, window.outerWidth-45 < 1400 ? 1370 : window.outerWidth-45);		
    	});
    });
    
    let timer = null;
	$(window).off().on("resize", function(){
	    clearTimeout(timer);
	    timer = setTimeout(function(){
	    	if(window.outerWidth > 1400){
	    		fnMonthStats(data, window.outerWidth-45);
			}
	    }, 300);
	});
}
</script>
<div id="monthIEChart"></div>