<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
//############## 가계부 기입 페이지 전역변수 ################
let ledgerGrid = null;
let historyGrid = null;
let vals = null;

$(document).ready(function(){
	$.post("${contextPath}/ledger/selectLedgerInitData.ajax", null, function(data){
		//참조데이터 등록
		vals = data;		
		//초기설정
		fnInit();
		//이벤트 등록
		fnEventInit();
	});
});

//############## 초기설정 ################
function fnInit(){
	//가계부 그리드 생성
	ledgerGrid = new wGrid("ledgerGrid", {
		mode : ["insert"],
		//그리드 생성시 필요한 아이템
		items : {
			select : [				
				{name: "purSeq", opList: vals.purList, value: "purSeq", text: "purpose", dataValue: "purType", childColumnName:"purDtlSeq", childValueName: "purDtlSeq"},				
				{name: "purDtlSeq", opList: vals.purDtlList, value: "purDtlSeq", text: "purDetail", parentColumnName:"purSeq", parentValueName:"purSeq", filterValueName : "purSeq"},				
				{name: "meansSeq", opList : vals.meansList, value : "meansSeq", text:["meansNm", "meansDtlNm", "meansInfo"], textJoin:" "},
				{name: "moveSeq", opList : vals.meansList, value : "meansSeq", text:["meansNm", "meansDtlNm", "meansInfo"], textJoin:" "},
			]
		},
		//그리드 필드 정보
		fields : [
			{ isRemoveButton: true, isHeadAddButton: true, width: "3%", align:"center"},
			{ title:"날짜", name:"recordDate", tag:"input", width: "7%", align:"center"},
			{ title:"위치", name:"position", tag:"input", width: "10%", align:"center"},
			{ title:"내용", name:"content", tag:"input", width: "16%", align:"center"},			
			{ title:"목적", name:"purSeq", tag:"select", width: "12%", align:"center"},
			{ title:"상세목적", name:"purDtlSeq", tag:"select", width: "11%", align:"center"},
			{ title:"사용수단", name:"meansSeq", tag:"select", width: "14%", align:"center"},
			{ title:"이동처", name:"moveSeq", tag:"select", width: "14%", align:"center"},
			{ title:"수입/지출/이동", name:"money", tag:"input", type:"currency", width: "8%", align:"right"},
			{ title:"통계여부", isUseYnButton: true, name:"statsYn", width: "5%", align:"center"},	
		],
		//그리드 옵션
		option : {isAutoSearch : false, isSync : false, isPaging : false, isScrollY: true, bodyHeight:"500px"},
		//그리드 메시지
		message : {
			nodata : "데이터를 입력하세요."
		}
	});
}

//############## 이벤트 등록 ################
function fnEventInit(){
	//행추카
	$("#addBtn").on("click", function(){		
		ledgerGrid.node.headAddButtonElement.click();
	});
}

</script>

<!-- 기입란 -->
<div class="mgbottom30">
	<div class="button-bar">
		<div class="btn-right">
			<table>
				<colgroup>
					<col width="*"/>
				</colgroup>
				<tr>
					<td>
						<button id="addBtn" type="button" class="btn-gray trs">추가</button>
						<button id="saveBtn" type="button" class="btn-gray trs">저장</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div>
		<div class="title-icon"></div>
		<label class="title">기입란</label>
	</div>
	<div id="ledgerGrid"></div>
</div>

<!-- 최근기입목록 -->
<%-- <div class="mgbottom30">
	<div class="button-bar">		
		<div class="btn-right">
			<table>
				<colgroup>
					<col width="90px" class="search-th"/>
					<col width="*"/>								
				</colgroup>
				<tr>
					<th>시간설정</th>
					<td>
						<select id="schdTime" class="select-gray">
							<option value="1" selected="selected">1H</option>
							<option value="3">3H</option>
							<option value="6">6H</option>
							<option value="12">12H</option>
							<option value="24">24H</option>
						</select>
					</td>					
				</tr>
			</table>			
		</div>
	</div>
	<div>
		<div class="title-icon"></div>
		<label class="title">최근기입목록</label>
	</div>
	<div id="recordList"></div>
	<div id="pager" class="pager"></div>
</div> --%>
