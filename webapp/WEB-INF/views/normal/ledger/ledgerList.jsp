<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	$("#searchBar #startDate").val(isDate.firstDay());
	$("#searchBar #endDate").val(isDate.lastDay());
	$("#detail").data("detail", false);
	cfnCmmAjax("/ledger/selectPurBankList").done(ledgerList);
	
	//상세보기 버튼
	$("#searchBar #button #detail").on("click", function(){
		if($(this).data("detail")){			
			$("[name=detail]").hide();
			$(this).data("detail", false).text("상세보기");
			$("#ledgerList").removeClass("overflow-x-scroll");	
		}else{
			$("[name=detail]").show();
			$(this).data("detail", true).text("간편보기");
			$("#ledgerList").addClass("overflow-x-scroll");
		}
	});
	
});

function ledgerList(data){
	let $option = null;
	let purMap = {};
	let purDtlMap = {};
	let bankMap = {};
	
	//목적
	for(let i=0; i<data.purList.length; i++){
		$option = $("<option>").val(data.purList[i].purSeq)
			.text(data.purList[i].purpose)
			.data("purType", data.purList[i].purType);		
		$("#searchBar #purpose").append($option);
		
		//seq값 목적명 맵 생성
		purMap[data.purList[i].purSeq] = data.purList[i].purpose;
	}
	
	//상세목적seq 맵 생성
	for(let i=0; i<data.purDtlList.length; i++){
		purDtlMap[data.purDtlList[i].purDtlSeq] = data.purDtlList[i].purDetail;
	}
	
	//목적-상세목적
	$("#searchBar #purpose").on("change", function(e){
		$("#purDtl").empty();
		for(let i=0; i<data.purDtlList.length; i++){
			if(Number(data.purDtlList[i].purSeq) === Number(this.value)){
				$option = $("<option>").val(data.purDtlList[i].purDtlSeq)
					.text(data.purDtlList[i].purDetail);		
				$("#purDtl").append($option);
			}
		}
	});
	
	//사용수단
	for(let i=0; i<data.bankList.length; i++){
		$option = $("<option>").val(data.bankList[i].bankSeq)
			.text(data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")");					
		$("#bank").append($option);
		
		//은행seq 맵 생성
		bankMap[data.bankList[i].bankSeq] = data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")";
	}
	
	//조회버튼
	$("#button #search").on("click", function(){
		let param = {};			
		param.startDate = $("#searchBar #startDate").val();
		param.endDate = $("#searchBar #endDate").val();
		param.purpose = $("#searchBar #purpose").val();
		param.purDtl = $("#searchBar #purDtl").val();
		param.bank = $("#searchBar #bank").val();
		
		if(!isRecordDatePattern(param.startDate, "date")){			
			wVali.alert({element : $("#searchBar #startDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		if(!isRecordDatePattern(param.endDate, "date")){			
			wVali.alert({element : $("#searchBar #endDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		
		cfnCmmAjax("/ledger/selectRecordList", param).done(function(data){
			$("#ledgerList").removeClass("overflow-x-scroll");
			fnCreateLedgerList(data);
		});
	}).trigger("click");
	
	let fieldList = [
		{title: "날짜", 		name: "recordDate", minWidth: 200, detail: false, edit: true,				
			itemTemplate: function(item){
				return item.recordDate;
			}
		},
		{title: "위치", 		name: "position", 	minWidth: 250, detail: true,  edit: true,				
			itemTemplate: function(item){
				return item.position;
			}
		},
		{title: "내용", 		name: "content", 	minWidth: 500, detail: false, edit: true,				
			itemTemplate: function(item){
				return item.content;
			}
		},
		{title: "목적", 		name: "purSeq", 	minWidth: 200, detail: false, edit: true,				
			itemTemplate: function(item){
				return purMap[Number(item.purSeq)];
			}
		},
		{title: "상세목적", 	name: "purDtlSeq", 	minWidth: 200, detail: true,  edit: true,				
			itemTemplate: function(item){
				return purDtlMap[Number(item.purDtlSeq)];
			}
		},
		{title: "사용수단", 	name: "bankSeq",	minWidth: 200, detail: true,  edit: true,				
			itemTemplate: function(item){
				if(Number(item.bankSeq) === 0){
					return "현급";
				}else{
					return bankMap[Number(item.bankSeq)];
				}
			}
		},
		{title: "수입/지출", 	name: "money", 		minWidth: 150, detail: false, edit: true,				
			itemTemplate: function(item){
				return cfnSetComma(item.money);
			}
		},
		{title: "소지금액", 	name: "amount",		minWidth: 200, detail: false, edit: false,				
			itemTemplate: function(item){
				return cfnSetComma(item.amount);
			}
		},
		{title: "현금", 		name: "cash", 		minWidth: 200, detail: true,  edit: false,				
			itemTemplate: function(item){
				return cfnSetComma(item.cash);
			}
		}
	];
	
	
	//가계부 리스트 생성
	function fnCreateLedgerList(list){
		$("#ledgerList").empty();	
		
		let $header = $("<div>").append(fnCreateHeader());	
		let $tbody = $("<div>").append(fnCreateRow());
		
		let curDown = false;
		let curXPos = 0;
		let pos = 0;
		
		$("#ledgerList").append($header)
		.append($tbody)
		.mousedown(function(m){		
			curDown = true;		
			curXPos = m.pageX;
		}).mouseup(function(){
			curDown = false;
		}).mousemove(function(m){		    
			if(curDown === true){		
				pos = curXPos - m.pageX;
				if(pos > 25){
					pos = 25;
				}else if(pos < -25){
					pos = -25;
				}			
				$("#ledgerList").scrollLeft($("#ledgerList").scrollLeft() + pos);
			}
		});
		
		//해더 생성
		function fnCreateHeader(){
			let $tb = $("<table>").addClass("table-header");
			let $tr = $("<tr>");
			let $th = null;
			
			for(let i=0; i<data.bankList.length; i++){			
				fieldList.push(
					{
						title:data.bankList[i].bankName+"<br>("+data.bankList[i].bankAccount+")", 
						name:data.bankList[i].bankAccount, 
						minWidth: 200, 
						detail:true,
						edit:false,
						itemTemplate: function(item){
							return cfnSetComma(item["bank"+i]);
						}
					}
				);
			}
			
			for(let i=0; i<fieldList.length; i++){
				$th = $("<th>").html(fieldList[i].title).attr("style", "min-width:"+fieldList[i].minWidth);
				if(fieldList[i].detail){
					$th.attr("name", "detail").hide();
				}
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
			let obj = null;
			
			for(let i=list.length-1; i>=0; i--){
				$tr = $("<tr>");
				for(let j=0; j<fieldList.length; j++){
					$td = $("<td>").attr("style", "min-width:"+fieldList[j].minWidth);
					if(fieldList[j].detail){
						$td.attr("name", "detail").hide();
					}
					
					$td.append(fieldList[j].itemTemplate(list[i]));
					$tr.append($td);
				}
				$tb.append($tr);
			}
			return $tb;
		}
	}
	
	//가계부 리스트 편집 생성
	function fnCreateLedgerEditList(){
		
	}
	
	
	
}

</script>

<form id="searchForm" name="searchForm" onsubmit="return false;">
	<input id="stateDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<div id="searchBar" class="search-bar">	
	<input id="startDate" value="" type="text" class="input-gray input-center wth1 datepicker-here" data-language='ko'>	
	<input id="endDate" value="" type="text" class="input-gray input-center wth1 datepicker-here" data-language='ko'>	
	
	<select id="purpose" class="select-gray">
		<option value=''>목적 검색</option>		
	</select>
	<select id="purDtl" class="select-gray">
		<option value=''>상세목적 검색</option>
	</select>
	<select id="bank" class="select-gray">
		<option value=''>은행 검색</option>		
		<option value='0'>현금</option>	
	</select>
	
	<div id="button" class="pull-right">	
		<button id="search" class="btn-gray trs">조회</button>
		<button id="edit"  class="btn-gray trs">편집</button>
		<button id="save"  class="btn-gray trs">저장</button>
		<button id="cancel" class="btn-gray trs">초기화</button>
		<button id="detail" class="btn-gray trs">상세보기</button>
	</div>
</div>

<div id="ledgerList" class="text-drag-block">		
<!-- <div id="ledgerList" style="overflow: scroll; width: 100px;"> -->		
</div>