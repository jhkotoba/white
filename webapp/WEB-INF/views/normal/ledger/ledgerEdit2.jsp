<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
//전역변수
const vals = {};
$(document).ready(function(){
	//############## 초기 데이터 조회 ################
	new Promise(function(resolve, reject){
		$.post("${contextPath}/ledger/selectLedgerInitData.ajax", null, function(data){
			vals.purList = data.purList;
			vals.purDtlList = data.purDtlList;
			vals.meansList = data.meansList;		
			resolve();
		});		
	})
	//초기설정
	.then(fnInit)
	//이벤트 등록
	.then(fnEventInit);
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
	
	//가계부 그리드 생성
	vals.ledgerGrid = new wGrid("ledgerGrid", {
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
					$.post("${contextPath}/ledger/selectLedgerEditList.ajax", srhParam, resolve);
				});
				return promise;
			}			
		},		
		fields : [			
			{ title:"날짜", name:"recordDate", tag:"input", width: "8%", align:"center"},
			{ title:"위치", name:"position", tag:"input", width: "15%", align:"center"},
			{ title:"내용", name:"content", tag:"input", width: "18%", align:"center"},			
			{ title:"목적", name:"purpose", tag:"select", width: "8%", align:"center"},
			{ title:"상세목적", name:"purDetail", tag:"select", width: "10%", align:"center"},
			{ title:"사용수단", name:"meansNm", tag:"input", 	width: "15%", align:"center"},
			{ title:"수입/지출/이동", name:"money", tag:"input", width: "9%", align:"center"}			
		],
		option : {isAuto : true, isClone : true, isPaging : false, isScrollY: true, bodyHeight:"500px"},			
		message : {
			nodata : "조회결과가 없습니다."
		}
	});
}

//############## 이벤트 등록 ################
function fnEventInit(){
	
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
						<button id="saveBtn" class="btn-gray trs">저장</button>
						<button id="cancelBtn" class="btn-gray trs">초기화</button>
					</div>					
				</td>				
			</tr>
		</table>
	</div>
</form>
<div id="ledgerGrid"></div>