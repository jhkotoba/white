<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid_0.0.2.js"></script>

<script type="text/javascript">
//############## 가계부 편집 페이지 전역변수 ################
let ledgerGrid = null;
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
	
	//조회폼 셀렉트 박스 생성
	let $option = null;
	$("#purSelect").append($("<option>").text("선택").val(""));
	$("#purDtlSelect").append($("<option>").text("선택").val(""));
	$("#meansSelect").append($("<option>").text("선택").val(""));
	
	//목적 option 생성
	$.each(vals.purList, function(idx, item){
		$option = $("<option>").text(item.purposeNm).val(item.purposeSeq).data("purposeTpCd", item.purposeTpCd);
		$("#purSelect").append($option);		
	});
	
	//수단 option 생성
	$.each(vals.meansList, function(idx, item){		
		$option = $("<option>").text(item.meansNm + " " + wcm.isEmptyRtn(item.meansDtlNm) + " " + wcm.isEmptyRtn(item.meansInfo))
			.val(item.meansSeq).data("purposeTpCd", item.purposeTpCd);
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
						purposeSeq : $("#purSelect").val(),
						purposeDtlSeq : $("#purDtlSelect").val(),
						meansSeq : $("#meansSelect").val(),
						sort : "DESC"
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
				{name: "purposeSeq", opList: vals.purList, value: "purposeSeq", text: "purposeNm", dataValue: "purposeTpCd", childColumnName:"purposeDtlSeq", childValueName: "purposeDtlSeq"},				
				{name: "purposeDtlSeq", opList: vals.purDtlList, value: "purposeDtlSeq", text: "purposeDtlNm", parentColumnName:"purposeSeq", parentValueName:"purposeSeq", filterValueName : "purposeSeq"},				
				{name: "meansSeq", opList : vals.meansList, value : "meansSeq", text:["meansNm", "meansDtlNm", "meansInfo"], textJoin:" "},
				{name: "moveSeq", opList : vals.meansList, value : "meansSeq", text:["meansNm", "meansDtlNm", "meansInfo"], textJoin:" "},
			]
		},
		//그리드 필드 정보
		fields : [
			{ isRemoveButton: true, isHeadAddButton: false, width: "3%", align:"center"},
			{ title:"날짜", name:"recordDate", tag:"input", width: "7%", align:"center"},
			{ title:"위치", name:"position", tag:"input", width: "10%", align:"center"},
			{ title:"내용", name:"content", tag:"input", width: "16%", align:"center"},			
			{ title:"목적", name:"purposeSeq", tag:"select", width: "12%", align:"center"},
			{ title:"상세목적", name:"purposeDtlSeq", tag:"select", width: "11%", align:"center"},
			{ title:"사용수단", name:"meansSeq", tag:"select", width: "14%", align:"center"},
			{ title:"이동처", name:"moveSeq", tag:"select", width: "14%", align:"center"},
			{ title:"수입/지출/이동", name:"money", tag:"input", type:"currency", width: "8%", align:"right"},
			{ title:"통계여부", isUseYnButton: true, name:"statsYn", width: "5%", align:"center"},	
		],
		//그리드 옵션
		option : {isAutoSearch : true, isPaging : false, isScrollY: true, bodyHeight:"500px"},			
		//그리드 메시지
		message : {
			nodata : "조회결과가 없습니다."
		}		
	});
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
	
	//저장
	$("#saveBtn").on("click", function(){
		fnApplyLedger();
	});
	
	//초기화
	$("#cancelBtn").on("click", function(){
		ledgerGrid.originalToReset(false, true);
	});	
}

//############## 그리드 데이터 가공  ################
function fnGridDataConverter(data){	
	return data.map(function(item){
		item.money = Math.abs(item.money);
		return item;
	});
}

//############## 그리드 생성 전 그리드 초기설정 ################
function fnCreatedGridBeforeInit(){
	//이벤트 중복방지를 위한 삭제
	$("[data-column-name='purposeSeq'] .wgrid-select").off();
}
//############## 그리드 생성 후 그리드 초기설정 ################
function fnCreatedGridAfterInit(){
	
	//금액 필드 넓이 적용
	$("[data-column-name='money'] .wgrid-input").addClass("wth80p");
	
	//이동처 컬럼 LED001 or LED002 disabled
	$("[data-column-name='purposeSeq'] .wgrid-select").each(function(idx, el){					
		let purposeTpCd = el.options[el.selectedIndex].dataset.purposeTpCd;
		let moveSelect = $(el).closest("td").next().next().next().find(".wgrid-select")[0];
		
		let $strong = $("<strong>").addClass("pm-mark");
		                                    
		switch(purposeTpCd){                    
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
	
	fnCreatedGridAfterEventInit();
}

//############## 그리드 생성 후 그리드 이벤트 설정 ################
function fnCreatedGridAfterEventInit(){

	//그리드 목적 change 이벤트
	$("[data-column-name='purposeSeq'] .wgrid-select").on("change", function(ev){		
		let purposeTpCd = ev.target.options[ev.target.selectedIndex].dataset.purposeTpCd;		
		
		//목적타입에 따른 설정
		let $tr = $(ev.target).closest("tr");
		let key = $tr.data("key");
		let meansSeq = $tr.find("[data-column-name='meansSeq'] .wgrid-select").val();
		let $moveSeq = $tr.find("[data-column-name='moveSeq'] .wgrid-select");	
		let $moneyMark = $tr.find("[data-column-name='money'] .pm-mark");		
		switch(purposeTpCd){
		//수입
		case "LED001" :
		//지출
		case "LED002" :	
			$moveSeq.val(Number(meansSeq));
			ledgerGrid.setCellData(key, "moveSeq", Number(meansSeq));
			ledgerGrid.applySync(key);
			$moveSeq[0].disabled = true;			
			$moneyMark.text(purposeTpCd == "LED001" ? "+" : "-");			
			break;			
		//이동	
		case "LED003" :
			$(ev.target).closest("td").next().next().next().find(".wgrid-select")[0].disabled = false;
			$moneyMark.text(">");
			break;
		}
		
		//목적타입 적용
		ledgerGrid.setCellData(key, "purposeTpCd", purposeTpCd);
	});
}

//############## 목적변경  ################
function fnParSeqChange(purposeSeq){	
	$("#purDtlSelect").empty().append($("<option>").text("선택").val(""));
	
	//상세목적 option 생성
	$.each(vals.purDtlList, function(idx, item){
		if(purposeSeq == item.purposeSeq){
			$option = $("<option>").text(item.purposeDtlNm).val(item.purposeDtlSeq).data("purposeSeq", item.purposeSeq);
			$("#purDtlSelect").append($option);	
		}
	});	
}

//############## 가계부 변경사항 저장  ################
function fnApplyLedger(){
	let updateList = ledgerGrid.getModifyData();	
	let deleteList = ledgerGrid.getRemoveData();
	let isSave = false;
	
	updateList.map(function(item){
		if(item.purposeTpCd == "LED002" || item.purposeTpCd == "LED003"){
			item.money = "-" + item.money;
			return item;
		}else{
			return item;
		}
	});
		
	//유효성 검사
	if(updateList.length + deleteList.length === 0){
		alert("적용할 데이터가 없습니다.");
		return;
	}else{
		isSave = !updateList.some(function(item){			
			switch(item._state){			
			case "update":
				if(wcm.isEmpty(item.recordDate)){
					ledgerGrid.inputMessage(item._key, "recordDate", "값이 없습니다.");
					return true;
				}else if(!wcm.isDatePattern(item.recordDate, "YYYY-MM-DD HH:MM")){
					ledgerGrid.inputMessage(item._key, "recordDate", "날짜 형식이 바르지 않습니다. 날짜형식:YYYY-MM-DD HH:MM");
					return true;
				}else if(item.position.length > 20){
					ledgerGrid.inputMessage(item._key, "position", "최대길이 20자 입니다.");
					return true;
				}else if(item.content.length > 20){
					ledgerGrid.inputMessage(item._key, "content", "최대길이 50자 입니다.");
					return true;
				}else if(isNaN(item.money)){					
					ledgerGrid.inputMessage(item._key, "money", "형식이 잘못되었습니다.");
					return true;
				}else{
					return false;
				}
			}
		});		
	}	
	
	if(isSave && confirm("적용하시겠습니까?")){			
		$.post("${contextPath}/ledger/applyRecordList.ajax", 
				{updateList : JSON.stringify(updateList), deleteList : JSON.stringify(deleteList)}, function(res){			
			alert(res.message);
			if(res.code == "0")	ledgerGrid.search();
		});
	}	
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