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
	
	//초기 데이터 조회
	new Promise(function(resolve, reject){
		$.post("${contextPath}/ledger/selectLedgerInitData.ajax", null, function(data){
			vals.purList = data.purList;
			vals.purDtlList = data.purDtlList;
			vals.bankList = data.bankList;
			resolve();
		});		
	})
	//초기설정
	.then(fnInit)
	//이벤트 등록
	.then(fnEventInit)
	//초기 조회
	.then(fnSearch);
});
//초기설정
function fnInit(){
	
	//조회폼 셀렉트 박스 생성
	let $option = null;
	$("#purSelect").append($("<option>").text("선택").val(""));
	$("#purDtlSelect").append($("<option>").text("선택").val(""));
	$("#bankSelect").append($("<option>").text("선택").val(""));
	
	//목적 option 생성
	$.each(vals.purList, function(idx, item){
		$option = $("<option>").text(item.purpose).val(item.purSeq).data("purType", item.purType);
		$("#purSelect").append($option);		
	});
	
	//은행 option 생성
	$.each(vals.bankList, function(idx, item){		
		$option = $("<option>").text(item.bankName+"("+item.bankAccount+")").val(item.bankSeq).data("purType", item.purType);
		$("#bankSelect").append($option);		
	});
	
	//날짜 설정
	$("#startDate").val(wcm.getToMonthFirstDay());
	$("#endDate").val(wcm.getToMonthLastDay());
	
	//가계부 그리드 생성
	vals.ledgerGrid = new wGrid("ledgerGrid", {
		controller : {
			load : function(){					
				let promise = new Promise(function(resolve, reject){
					let srhParam = {startDate: $("#startDate").val(), endDate: $("#endDate").val()};
					$.post("${contextPath}/ledger/selectLedgerList.ajax", srhParam, resolve);
				});
				return promise;
			}				
		},		
		fields : [			
			{ title:"번호",		name:"recordDate",	type:"date", 	width: "3%",	align:"center"},
			{ title:"부모코드",	name:"position",		type:"input", 	width: "10%",	align:"center"},
			{ title:"코드",		name:"content",		type:"input", 	width: "10%",	align:"center"},			
			{ title:"수정자",		name:"purSeq",		type:"text", 	width: "5%",	align:"center"},
			{ title:"수정날짜",	name:"purDtlSeq",		type:"text", 	width: "10%",	align:"center"},
			{ title:"등록자",		name:"bankSeq",		type:"text", 	width: "5%",	align:"center"},
			{ title:"등록날짜",	name:"money",		type:"text", 	width: "10%",	align:"center"}			
		],
		option : {isAuto : false, isClone : true, isPaging : false},			
		message : {
			nodata : "조회결과가 없습니다."
		},
		event : {
			
		}
	});
}

//이벤트 등록
function fnEventInit(){
	
	//목적 변경이벤트
	$("#purSelect").on("change", function(element){
		fnParSeqChange(element.target.value);			
	});
	
	//조회
	$("#searchBtn").on("click", function(){
		fnSearch();
	});
	
	//상세보기
	$("#detailBtn").on("click", function(){
		
	});
	
	//엑셀
	$("#excelBtn").on("click", function(){
		
	})
}

//조회
function fnSearch(){
	vals.ledgerGrid.search();
}

//목적변경
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
		<label class="title">가계부 목록</label>
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
				<col width="15%"/>
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
				<th>은행</th>
				<td>
					<select id="bankSelect" class="select-gray wth100p"></select>
				</td>
				<td>
					<div class="btn-right">
						<button id="searchBtn" class="btn-gray trs">조회</button>
						<button id="detailBtn" class="btn-gray trs">상세보기</button>
						<button id="excelBtn" class="btn-gray trs">엑셀</button>
					</div>					
				</td>				
			</tr>
		</table>
	</div>
</form>
<div id="ledgerGrid"></div>

