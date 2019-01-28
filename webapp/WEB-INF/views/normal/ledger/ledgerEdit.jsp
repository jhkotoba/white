<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	$("#searchBar #startDate").val(isDate.firstDay());
	$("#searchBar #endDate").val(isDate.lastDay());	
	cfnCmmAjax("/ledger/selectPurBankList").done(ledgerList);
});

function ledgerList(data){
	let $option = null;
	let purMap = {};
	let purDtlMap = {};
	let bankMap = {};	
	
	let purLp = {};
	for(let i=0; i<data.purList.length; i++){
		purLp[data.purList[i].purSeq] = data.purList[i].purType;
	}
	
	//목적
	for(let i=0; i<data.purList.length; i++){
		$option = $("<option>").val(data.purList[i].purSeq)
			.text(data.purList[i].purpose)
			.data("purType", data.purList[i].purType);		
		$("#searchBar #purSeq").append($option);
		
		//seq값 목적명 맵 생성
		purMap[data.purList[i].purSeq] = data.purList[i].purpose;
	}
	
	//상세목적seq 맵 생성
	for(let i=0; i<data.purDtlList.length; i++){
		purDtlMap[data.purDtlList[i].purDtlSeq] = data.purDtlList[i].purDetail;
	}
	
	//목적-상세목적
	$("#searchBar #purSeq").on("change", function(e){
		$("#purDtlSeq").empty();
		for(let i=0; i<data.purDtlList.length; i++){
			if(Number(data.purDtlList[i].purSeq) === Number(this.value)){
				$option = $("<option>").val(data.purDtlList[i].purDtlSeq)
					.text(data.purDtlList[i].purDetail);		
				$("#searchBar #purDtlSeq").append($option);
			}
		}
	});
	
	//사용수단
	for(let i=0; i<data.bankList.length; i++){
		$option = $("<option>").val(data.bankList[i].bankSeq)
			.text(data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")");					
		$("#searchBar #bankSeq").append($option);
		
		//은행seq 맵 생성
		bankMap[data.bankList[i].bankSeq] = data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")";
	}
	data.bankList.unshift({bankAccount: "", bankName: "현금", bankOrder: 0, bankSeq: 0, bankUseYn: "N"});
	
	//조회버튼
	$("#search").on("click", function(){
		let param = {};			
		param.startDate = $("#searchBar #startDate").val();
		param.endDate = $("#searchBar #endDate").val();
		param.purSeq = $("#searchBar #purSeq").val();
		param.purDtlSeq = $("#searchBar #purDtlSeq").val();
		param.bankSeq = $("#searchBar #bankSeq").val();
		param.isEdit = 1;
		
		if(!isRecordDatePattern(param.startDate, "date")){			
			wVali.alert({element : $("#searchBar #startDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		if(!isRecordDatePattern(param.endDate, "date")){			
			wVali.alert({element : $("#searchBar #endDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		
		param.startDate = param.startDate + " 00:00";
		param.endDate = param.endDate + " 23:59";
		
		cfnCmmAjax("/ledger/selectRecordList", param).done(function(data){			
			//데이터 초기 세팅
			for(let i=0; i<data.length; i++){
				data[i].type = "select";
				data[i].money = cfnSetComma(Math.abs(data[i].money));
			}
			
			//편집리스트 생성
			cloneList = common.clone(data);
			fnCreateLedgerEditList(common.clone(data));
			
			//초기화 버튼
			$("#right #cancel").off().on("click", function(){
				fnCreateLedgerEditList(common.clone(data));
			});
		});
	}).trigger("click");
	
	//가계부 리스트 생성
	function fnCreateLedgerEditList(list){
		$("#ledgerList").empty();		
		
		$("#right #save").off().on("click", function(){
			console.log(list);
		});
		
		let fieldList = [
			{title : "",		name:"", width : "3%",
				itemTemplate: function(item, idx){
					return $("<button>")
					.addClass("btn-gray trs")
					.text("-")
					.on("click", function(){
						switch(item.type){
						case "select": 
						case "update": 
							item.type = "delete";
							$("[name='sync"+idx+"']").addClass("sync-red").prop("disabled", true);
							break;
						case "delete":
							fnCompareData(item, idx) ? item.type = "select" : item.type = "update";							
							$("[name='sync"+idx+"']").removeClass("sync-red").prop("disabled", false);
							break;
						}
					});
				}
			},
			{title: "날짜", 		name: "recordDate", width: "10%",
				itemTemplate: function(item, idx){
					return fnCreateCmmInput($("<input>"), "recordDate", item, idx);
				}
			},
			{title: "위치", 		name: "position", 	width: "17%",
				itemTemplate: function(item, idx){
					return fnCreateCmmInput($("<input>"), "position", item, idx);
				}
			},
			{title: "내용", 		name: "content", 	width: "21%",
				itemTemplate: function(item, idx){
					return fnCreateCmmInput($("<input>"), "content", item, idx);
				}
			},
			{title: "목적", 		name: "purSeq", 	width: "12%",
				itemTemplate: function(item, idx){					
					return fnCreateSelectBox($("<select>"), data.purList, item, "purSeq", "purpose", idx)
					.on("change", function(){
						console.log(this.value);
						//purLp[]
					});
				}
			},
			{title: "상세목적", 	name: "purDtlSeq", 	width: "12%",
				itemTemplate: function(item, idx){
					return fnCreateSelectBox($("<select>"), data.purDtlList, item, "purDtlSeq", "purDetail", idx);
				}
			},
			{title: "사용수단", 	name: "bankSeq",	width: "15%",
				itemTemplate: function(item, idx){
					return fnCreateSelectBox($("<select>"), data.bankList, item, "bankSeq", "bankName", idx);
					}
			},
			{title: "수입/지출", 	name: "money", 		width: "10%",
				itemTemplate: function(item, idx){
					//return $("<input>").val(item.money).addClass("input-gray only-currency");
					return fnCreateMoney($("<span>"), purLp[item.purSeq], item, idx);
				}
			}
		];
		
		let $header = $("<div>").append(fnCreateHeader());	
		let $tbody = $("<div>").append(fnCreateRow());
		
		$("#ledgerList").append($header).append($tbody);
		
		//해더 생성
		function fnCreateHeader(){
			let $tb = $("<table>").addClass("table-header");
			let $tr = $("<tr>");
			let $th = null;
			
			for(let i=0; i<fieldList.length; i++){
				$th = $("<th>").html(fieldList[i].title).attr("style", "width:"+fieldList[i].width);
				$tr.append($th);				
			}
			$tb.append($tr);
			return $tb;
		}
		
		//새로운 행 생성
		function fnCreateRow(){
			let $tb = $("<table>").addClass("table-body");
			let $tr = null;
			let $td = null;
			let $input = null;
			
			for(let i=list.length-1; i>=0; i--){								
				if(isNotEmpty($("#searchBar #purSeq").val()) && String($("#searchBar #purSeq").val()) !== String(list[i].purSeq)){
					continue;				
				}
				if(isNotEmpty($("#searchBar #purDtlSeq").val()) && String($("#searchBar #purDtlSeq").val()) !== String(list[i].purDtlSeq)){
					continue;				
				}
				if(isNotEmpty($("#searchBar #bankSeq").val()) && String($("#searchBar #bankSeq").val()) !== String(list[i].bankSeq)){
					continue;				
				}
				
				$tr = $("<tr>");
				for(let j=0; j<fieldList.length; j++){
					$td = $("<td>").attr("style", "width:"+fieldList[j].width);					
					$td.append(fieldList[j].itemTemplate(list[i], i));
					$tr.append($td);
				}
				$tb.append($tr);
			}
			return $tb;
		}
	}
	
	//데이터 비교
	function fnCompareData(item, idx){		
		if(item.recordDate !== cloneList[idx].recordDate){				
			return false;
		}else if(item.position !== cloneList[idx].position){
			return false;
		}else if(item.content !== cloneList[idx].content){
			return false;
		}else if(String(item.purSeq) !== String(cloneList[idx].purSeq)){
			return false;
		}else if(String(item.purDtlSeq) !== String(cloneList[idx].purDtlSeq)){
			return false;
		}else if(String(item.bankSeq) !== String(cloneList[idx].bankSeq)){
			return false;
		}else if(String(item.money).replace(/,/g,"") !== String(cloneList[idx].money).replace(/,/g,"")){
			return false;
		}else if(item.purType === "LP003"){
			if(String(item.moveSeq) !== String(cloneList[idx].moveSeq)){
				return false;
			}
		}else{
			return true;
		}			
	}
	
	//input 생성
	function fnCreateCmmInput($input, name, item, idx){		
		/* return $input.addClass("input-gray wth80p").attr("name", "sync").data("name", name).on("change", function(){
			item[name] = this.value;
		}).val(item[name]); */
		//return $input.addClass("input-gray input-center wth100p").val(item[name]);
		return $input.addClass("input-gray wth100p").attr("name","sync"+idx).off().on("keyup change", function(){
			item[name] = this.value;
			fnTypeSync(this, item, idx);
		}).val(item[name]);
	}
	
	//select box 생성
	function fnCreateSelectBox($select, opList, item, valNm, textNm, idx){
		let $option = null;
		for(let i=0; i<opList.length; i++){
			switch(valNm){			
			case "purDtlSeq":
				if(String(item.purSeq) === String(opList[i].purSeq)){
					$option = $("<option>").val(opList[i][valNm]).text(opList[i][textNm]);	
					if(String(item[valNm]) === String(opList[i][valNm])){				
						$option.prop("selected", true);
					}
					$select.append($option);
				}
				break;				
			case "purSeq":
			case "bankSeq":
				$option = $("<option>").val(opList[i][valNm]).text(opList[i][textNm]);	
				if(String(item[valNm]) === String(opList[i][valNm])){				
					$option.prop("selected", true);
				}
				$select.append($option);
				break;
			}
		}
		return $select.addClass("select-gray wth100p").attr("name","sync"+idx).off().on("change", function(){			
			item[valNm] = this.value;
			fnTypeSync(this, item, idx);
		});
	}
	
	//수입지출란 수입, 지출, 이동구분해서 생성
	function fnCreateMoney($moneySp, code, item, idx){
		
		//let $input = $("<input>").addClass("only-currency").attr("name", "sync").data("name", "money");
		//$input.addClass("input-gray").off().on("keyup keydown change", function(){
		//	item.money = this.value;
		//}).val(item.money); 
		let $input = $("<input>").addClass("only-currency");
		$input.addClass("input-gray").val(cfnSetComma(item.money)).attr("name","sync"+idx).on("keyup change", function(){
			item.money = this.value;
			fnTypeSync(this, item, idx);
		});
		
		let $strong = $("<strong>");	
		switch(code){
		case "LP001":	
			$input.addClass("wth80p");
			$strong.text("+").addClass("pm-mark");
			break;
		case "LP002":
			$input.addClass("wth80p");
			$strong.text("-").addClass("pm-mark");
			break;		
		case "LP003":
			$input.addClass("wth80p");
			$strong.text(">").addClass("pm-mark");
			break;
		default:
			$input.addClass("wth100p");
			break;		
		}	
		$moneySp.append($strong);
		$moneySp.append($input);
		return $moneySp;
	}
	
	//타입, sync 체크
	function fnTypeSync(obj, item, idx){
		let isbool = fnCompareData(item, idx);
		if(item.type !== "delete" && isbool){
			item.type = "select";
			$(obj).removeClass("sync-blue");
		}else if(item.type !== "delete" && isbool === false){
			item.type = "update";
			$(obj).addClass("sync-blue");
		}
	}
}

</script>

<div id="searchBar" class="search-bar">	
	<input id="startDate" value="" type="text" class="input-gray input-center wth1 datepicker-here" data-language='ko'>	
	<input id="endDate" value="" type="text" class="input-gray input-center wth1 datepicker-here" data-language='ko'>	
	
	<select id="purSeq" class="select-gray">
		<option value=''>목적 검색</option>		
	</select>
	<select id="purDtlSeq" class="select-gray">
		<option value=''>상세목적 검색</option>
	</select>
	<select id="bankSeq" class="select-gray">
		<option value=''>은행 검색</option>		
		<option value='0'>현금</option>	
	</select>
	<button id="search" class="btn-gray trs">조회</button>
	
	<div id="right" class="pull-right">
		<button id="save"  class="btn-gray trs">저장</button>
		<button id="cancel" class="btn-gray trs">초기화</button>
	</div>
</div>

<div id="ledgerList" class="text-drag-block">
</div>