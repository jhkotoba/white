<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>

<script type="text/javascript">
//############## 가계부 조회 페이지 전역변수 ################
let ledgerGrid = null;
let vals = null;

$(document).ready(function(){
	$.post("${contextPath}/ledger/selectLedgerInitData.ajax", null, function(data){
		vals = data;
		fnInit();
	});
});

//############## 초기설정 ################
function fnInit(){
	
	//조회폼 셀렉트 박스 생성
	let $option = null;
	$("#purSelect").append($("<option>").text("선택").val(""));
	$("#purDtlSelect").append($("<option>").text("선택").val(""));
	$("#meansSelect").append($("<option>").text("선택").val(""));
	
	//목적 option 생성
	$.each(vals.purList, function(idx, item){
		$option = $("<option>").text(item.purpose).val(item.purSeq).data("purType", item.purType);
		$("#purSelect").append($option);		
	});
	
	//수단 option 생성
	$.each(vals.meansList, function(idx, item){		
		$option = $("<option>").text(item.meansNm + " " + wcm.isEmptyRtn(item.meansDtlNm) + " " + wcm.isEmptyRtn(item.meansInfo))
			.val(item.meansSeq).data("purType", item.purType);
		$("#meansSelect").append($option);		
	});
	
	//날짜 설정
	$("#startDate").val(wcm.getToMonthFirstDay());
	$("#endDate").val(wcm.getToMonthLastDay());
	
	//가계부 헤드셀렉트 값 가공
	vals.headList = new Array();			
	$.map(vals.meansList, function(item, idx){
		vals.headList.push({
			value : "no"+item.meansSeq,
			text : item.meansNm + " " + wcm.isEmptyRtn(item.meansDtlNm) + " " + wcm.isEmptyRtn(item.meansInfo)
		});				
	});
	vals.headCnt = 0;
	vals.headCntCheck = function(){
		if(vals.headCnt == vals.headList.length){
			vals.headCnt = 0;
		}
	};
	
	//가계부 그리드 생성
	ledgerGrid = new wGrid("ledgerGrid", {
		controller : {
			load : function(){					
				let promise = new Promise(function(resolve, reject){
					let srhParam = {
						startDate : $("#startDate").val(),
						endDate : $("#endDate").val(),
						purSeq : $("#purSelect").val(),
						purDtlSeq : $("#purDtlSelect").val(),
						meansSeq : $("#meansSelect").val(),
					};
					$.post("${contextPath}/ledger/selectLedgerCalcList.ajax", srhParam, resolve);
				});
				return promise;
			}			
		},		
		fields : [			
			{ title:"날짜", name:"recordDate", width: "8%", align:"center"},
			{ title:"위치", name:"position", width: "15%", align:"center"},
			{ title:"내용", name:"content", width: "18%", align:"center"},			
			{ title:"목적", name:"purpose", width: "8%", align:"center"},
			{ title:"상세목적", name:"purDetail", tag:"text", width: "10%", align:"center"},
			{ title:"사용수단", name:"meansNm", tag:"text", 	width: "15%", align:"center",
				itemTemplate : function(value, item, key){
					return $("<span>").attr("title", value + " " + wcm.isEmptyRtn(item.meansDtlNm) + " "+wcm.isEmptyRtn(item.meansInfo))
						.text(value + " " + wcm.isEmptyRtn(item.meansDtlNm));										
				}
			},
			{ title:"수입/지출/이동", name:"money", width: "9%", align:"center",
				itemTemplate : function(value, item, key){					
					let $span = $("<span>");
					switch(item.purType){
					case "LED001": $span.addClass("sync-red").text(wcm.setComma(value)); break;
					case "LED002": $span.addClass("sync-blue").text(wcm.setComma(value)); break;
					case "LED003": $span.addClass("sync-green").text("("+wcm.setComma(Math.abs(value))+")"); break;
					}
					return $span;
				}
			},		
			{ title:"소지금액", name:"amount", width: "9%", align:"center",
				itemTemplate : function(value, item, key){					
					let $span = $("<span>");
					switch(item.purType){
					case "LED001": $span.addClass("sync-red").text(wcm.setComma(value)); break;
					case "LED002": $span.addClass("sync-blue").text(wcm.setComma(value)); break;
					case "LED003": return wcm.setComma(value);				
					}
					return $span;
				}
			},
			{ isHeadSelect: true, headSelectList: vals.headList, width: "9%", align:"center",
				itemTemplate : function(value, item, key){					
					let $span = $("<span>");
					if(vals.headList[vals.headCnt++].value === "no"+item.meansSeq){
						switch(item.purType){
						case "LED001":
						case "LED003": $span.addClass("sync-red").text(wcm.setComma(value)); break;
						case "LED002": $span.addClass("sync-blue").text(wcm.setComma(value)); break;							
						}						
					}else if(vals.haedSelected === "no"+item.moveSeq){
						if(item.purType === "LED003"){
							$span.addClass("sync-red").text(wcm.setComma(value));
						}						
					}else{
						$span = null;
					}
					vals.headCntCheck();
					return $span == null ? wcm.setComma(value) : $span;
				}	
			},
		],
		option : {isAutoSearch : true, isClone : true, isPaging : false, isScrollY: true, bodyHeight:"500px"},			
		message : {
			nodata : "조회결과가 없습니다."
		}
	});
	
	fnEventInit();
}

//############## 이벤트 등록 ################
function fnEventInit(){
	//목적 변경이벤트
	$("#purSelect").on("change", function(event){
		fnParSeqChange(event.target.value);			
	});
	
	//조회
	$("#searchBtn").on("click", function(){
		ledgerGrid.search();
	});
	
	//엑셀
	$("#excelBtn").on("click", function(){
		alert("미구현..");
	});
}

//############## 목적변경  ################
function fnParSeqChange(purSeq){	
	$("#purDtlSelect").empty().append($("<option>").text("선택").val(""));
	
	//상세목적 option 생성
	$.each(vals.purDtlList, function(idx, item){
		if(purSeq == item.purSeq){
			$option = $("<option>").text(item.purDetail).val(item.purDtlSeq).data("purSeq", item.purSeq);
			$("#purDtlSelect").append($option);	
		}
	});	
}
</script>

<form id="srhForm" name="srhForm" onsubmit="return false;">
	<div>
		<div class="title-icon"></div>
		<label class="title">가계부 조회</label>
	</div>
	<div id="searchBar" class="search-bar">
		<table class="wth100p">
			<colgroup>
				<col width="5%" class="search-th"/>
				<col width="8%"/>
				<col width="5%" class="search-th"/>
				<col width="8%"/>
				<col width="5%" class="search-th"/>
				<col width="10%"/>
				<col width="5%" class="search-th"/>
				<col width="10%"/>
				<col width="5%" class="search-th"/>				
				<col width="*"/>
			</colgroup>
			<tr>
				<th>시작일자</th>
				<td>
					<input id="startDate" value="" type="text" class="input-gray input-center wth100p datepicker-here" data-language='ko'>
				</td>
				<th>종료일자</th>
				<td>
					<input id="endDate" value="" type="text" class="input-gray input-center wth100p datepicker-here" data-language='ko'>
				</td>
				<th>목적</th>
				<td>
					<select id="purSelect" class="select-gray wth100p"></select>
				</td>
				<th>상세목적</th>
				<td>
					<select id="purDtlSelect" class="select-gray wth100p"></select>
				</td>
				<th>사용수단</th>
				<td>
					<select id="meansSelect" class="select-gray wth100p"></select>
				</td>				
				<td>
					<div class="btn-right">
						<button id="searchBtn" class="btn-gray trs">조회</button>						
						<button id="excelBtn" class="btn-gray trs">엑셀</button>
					</div>					
				</td>				
			</tr>
		</table>
	</div>
</form>
<div id="ledgerGrid"></div>