<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>

<script type="text/javascript">
//############## 가계부 편집 페이지 전역변수 ################
let ledgerGrid = null;


//############## 초기설정 ################
function fnInit(vals){
	
	//초기자료 조회
	if(wcm.isEmpty(vals)){		
		$.post("${contextPath}/ledger/selectLedgerInitData.ajax", null, fnInit);
		return;
	}
	
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
					$.post("${contextPath}/ledger/selectLedgerList.ajax", srhParam, resolve);
				});
				return promise;
			},
			//데이터 가공
			dataConverter : fnGridDataConverter,
			//그리드 생성전 초기설정
			beforeCreate : fnCreatedGridBeforeInit,
			//그리드 생성후 초기설정
			afterCreate : fnCreatedGridAfterInit
		},
		//그리드 생성시 필요한 아이템
		items : {
			select : [
				{name: "purSeq", opList: vals.purList, value: "purSeq", text: "purpose", dataValue: "purType"},				
				{name: "purDtlSeq", opList: vals.purDtlList, value: "purDtlSeq", text: "purDetail", filterName:"purpose", filter : "purSeq"},				
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
			{ title:"사용수단", name:"meansSeq", tag:"select", 	width: "14%", align:"center"},
			{ title:"이동처", name:"moveSeq", tag:"select", width: "14%", align:"center"},
			{ title:"수입/지출/이동", name:"money", tag:"input", type:"currency", width: "8%", align:"right"},
			{ title:"사용여부", isUseYnButton: true, name:"statsYn", width: "5%", align:"center"},	
		],
		//그리드 옵션
		option : {isAutoSearch : true, isClone : true, isPaging : false, isScrollY: true, bodyHeight:"500px"},			
		//그리드 메시지
		message : {
			nodata : "조회결과가 없습니다."
		}
	});
	
	//이벤트 등록
	fnEventInit();
}

//############## 이벤트 등록 ################
function fnEventInit(){
	//목적 변경이벤트
	$("#purSelect").on("change", function(event){
		fnParSeqChange(vals, event.target.value);			
	});
	
	//조회
	$("#searchBtn").on("click", function(){
		ledgerGrid.search();
	});
	
	//저장
	$("#saveBtn").on("click", function(){
		
	});
	
	//초기화
	$("#cancelBtn").on("click", function(){
		ledgerGrid.originalToReset(false, true);
	});	
}

//############## 그리드 데이터 가공  ################
function fnGridDataConverter(data){
	return data.map(function(item){		
		item.money = wcm.setComma(Math.abs(item.money));
		return item;
	});
}

//############## 그리드 생성 전 그리드 초기설정 ################
function fnCreatedGridBeforeInit(){
	//이벤트 중복방지를 위한 삭제
	$("[data-column-name='purSeq'] .wgrid-select").off();
}
//############## 그리드 생성 후 그리드 초기설정 ################
function fnCreatedGridAfterInit(){
	
	//금액 필드 통화속성 적용
	$("[data-column-name='money'] .wgrid-input").addClass("only-currency wth80p");
	
	//이동처 컬럼 LED001 or LED002 disabled
	$("[data-column-name='purSeq'] .wgrid-select").each(function(idx, el){					
		let purType = el.options[el.selectedIndex].dataset.purType;
		let moveSelect = $(el).closest("td").next().next().next().find(".wgrid-select")[0];
		
		let $strong = $("<strong>").addClass("pm-mark");
		                                    
		switch(purType){                    
		case "LED001":
			moveSelect.disabled = true;
			$strong.text("+");
			$(el).closest("td").next().next().next().next().prepend($strong);
			break;
		case "LED002":
			moveSelect.disabled = true;
			$strong.text("-");
			$(el).closest("td").next().next().next().next().prepend($strong);
			break;
		case "LED003":
			moveSelect.disabled = false;
			$strong.text(">");
			$(el).closest("td").next().next().next().next().prepend($strong);
			break;			
		}
	});
	
	//그리드 생성 후 이벤트 설정
	fnCreatedGridAfterEventInit();
}

//############## 그리드 생성 후 그리드 이벤트 설정 ################
function fnCreatedGridAfterEventInit(){
	
	
	//그리드 목적 change 이벤트
	$("[data-column-name='purSeq'] .wgrid-select").on("change", function(ev){
		
		let purType = ev.target.options[ev.target.selectedIndex].dataset.purType;
		
		if(purType !== "LED003"){
			let key = $(ev.target).closest("tr").data("key");
			let meansSeq = $(ev.target).closest("td").next().next().find(".wgrid-select").val();
			let $moveSeq = $(ev.target).closest("td").next().next().next().find(".wgrid-select");
			
			$moveSeq.val(Number(meansSeq));
			ledgerGrid.setCellData(key, "moveSeq", Number(meansSeq));
			ledgerGrid.applySync(key);			
			
			$moveSeq[0].disabled = true;
		}else{
			$(ev.target).closest("td").next().next().next().find(".wgrid-select")[0].disabled = false;
		}
	});
}

//############## 목적변경  ################
function fnParSeqChange(vals, purSeq){	
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
		<label class="title">가계부 편집</label>
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