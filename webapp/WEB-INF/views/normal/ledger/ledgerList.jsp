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
	$("#detailBtn").on("click", function(){
		if($(this).data("detail")){			
			$("[name=detail]").hide();
			$(this).data("detail", false).text("상세보기");
			$("#ledgerList").removeClass("overflow-x-scroll");
			//$(".detail-view").each(function(e){$(this).hide();});			
		}else{
			$("[name=detail]").show();
			$(this).data("detail", true).text("간편보기");
			$("#ledgerList").addClass("overflow-x-scroll");
			//$(".detail-view").each(function(e){$(this).show();});
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
		$("#searchBar #purDtlSeq").append($("<option>").text("전체").val(""));
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
	
	//조회버튼
	$("#searchBtn").on("click", function(){
		let param = {};			
		param.startDate = $("#searchBar #startDate").val();
		param.endDate = $("#searchBar #endDate").val();
		param.purSeq = $("#searchBar #purSeq").val();
		param.purDtlSeq = $("#searchBar #purDtlSeq").val();
		param.bankSeq = $("#searchBar #bankSeq").val();
		param.searchType = "select";
		
		if(!wcm.isDatePattern(param.startDate, "yyyy-MM-dd")){			
			wVali.alert({element : $("#searchBar #startDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		if(!wcm.isDatePattern(param.endDate, "yyyy-MM-dd")){			
			wVali.alert({element : $("#searchBar #endDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		
		param.startDate = param.startDate + " 00:00";
		param.endDate = param.endDate + " 23:59";
		
		cfnCmmAjax("/ledger/selectRecordList", param).done(function(data){
			console.log(data);
			$("#ledgerList").removeClass("overflow-x-scroll");
			fnCreateLedgerList(data);
			
			//excel 버튼
			$("#excelBtn").off().on("click", function(){
				alert("나중에~");
				/* $("#downloadForm #filename").val("가계부 검색 리스트.xlsx");
				$("#downloadForm #data").val(JSON.stringify(data));
				$("#downloadForm").attr("method", "post").attr("action", common.path()+"/white/excelPrint.print").submit();
				$("#downloadForm input").each(function(){this.value = ""}); */
			});

		});
	}).trigger("click");	
	
	//목적타입별 폰트 색상 적용
	function fnSetFontColor(purType, data, name, from, to){
		let $span = $("<span>");
		switch(purType){
		case "LED001":
			return $span.addClass("sync-blue").text(cfnSetComma(data));
		case "LED002":
			return $span.addClass("sync-red").text(cfnSetComma(data));
		case "LED003":
			if(name === "money"){
				return $span.addClass("sync-green").text(cfnSetComma(Math.abs(data)));
			}else if(from){
				return $span.addClass("sync-red").text(cfnSetComma(data));
			}else if(to){
				return $span.addClass("sync-blue").text(cfnSetComma(data));
			}else{
				return cfnSetComma(data);
			}
		default:
			return cfnSetComma(data);
		}
	}	
	
	//가계부 리스트 생성
	function fnCreateLedgerList(list){
		$("#ledgerList").empty();
		
		let fieldList = [
			{title: "날짜", 		name: "recordDate", minWidth: 200, detail: false, bankSeq:null,			
				itemTemplate: function(item){
					return item.recordDate;
				}
			},
			{title: "위치", 		name: "position", 	minWidth: 250, detail: true, bankSeq:null,				
				itemTemplate: function(item){
					return item.position;
				}
			},
			{title: "내용", 		name: "content", 	minWidth: 500, detail: false, bankSeq:null,				
				itemTemplate: function(item){
					return item.content;
				}
			},
			{title: "목적", 		name: "purSeq", 	minWidth: 200, detail: false, bankSeq:null,				
				itemTemplate: function(item){
					return purMap[Number(item.purSeq)];
				}
			},
			{title: "상세목적", 	name: "purDtlSeq", 	minWidth: 200, detail: true, bankSeq:null,				
				itemTemplate: function(item){
					return purDtlMap[Number(item.purDtlSeq)];
				}
			},
			{title: "사용수단", 	name: "bankSeq",	minWidth: 200, detail: true, bankSeq:null,				
				itemTemplate: function(item){										
					if(Number(item.bankSeq) === 0){
						return "현금";
					}else{
						return bankMap[Number(item.bankSeq)];						
					}
				}
			},
			{title: "수입/지출/이동", 	name: "money", 		minWidth: 150, detail: false, bankSeq:null,
				itemTemplate: function(item){
					return fnSetFontColor(item.purType, item.money, "money", false, false);
				}
			},
			{title: "소지금액", 	name: "amount",		minWidth: 200, detail: false, bankSeq:null,				
				itemTemplate: function(item){
					return fnSetFontColor(item.purType, item.amount, "amount", false, false);
				}
			},
			{title: "현금", 		name: "cash", 		minWidth: 200, detail: true, bankSeq:0,
				itemTemplate: function(item, bankSeq){					
					if(String(item.bankSeq) === String(bankSeq)){
						return fnSetFontColor(item.purType, item.cash, "cash", true, false);
					}else if(String(item.moveSeq) === String(bankSeq)){
						return fnSetFontColor(item.purType, item.cash, "cash", false, true);
					}else{
						return cfnSetComma(item.cash);
					}
				}
			}
		];		
		
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
				if(pos > 15){
					pos = 15;
				}else if(pos < -15){
					pos = -15;
				}			
				$("#ledgerList").scrollLeft($("#ledgerList").scrollLeft() + pos);
			}
		});
		$("[name=detail]").hide();
		
		//해더 생성
		function fnCreateHeader(){
			let $tb = $("<table>").addClass("table-header");
			let $tr = $("<tr>");
			let $th = null;
			let detail = $("#detailBtn").data("detail");
			
			for(let i=0; i<data.bankList.length; i++){			
				fieldList.push(
					{
						title:data.bankList[i].bankName+"<br>("+data.bankList[i].bankAccount+")", 
						name:data.bankList[i].bankAccount, 
						minWidth: 200, 
						detail:true,
						edit:false,
						bankSeq:data.bankList[i].bankSeq,
						itemTemplate: function(item, bankSeq){
							if(Number(item.bankSeq) === Number(bankSeq)){
								return fnSetFontColor(item.purType, item[data.bankList[i].bankAccount], data.bankList[i].bankAccount, true, false);
							}else if(Number(item.moveSeq) === Number(bankSeq)){
								return fnSetFontColor(item.purType, item[data.bankList[i].bankAccount], data.bankList[i].bankAccount, false, true);
							}else{
								return cfnSetComma(item[data.bankList[i].bankAccount]);
							}
						}
					}
				);
			}			
			
			for(let i=0; i<fieldList.length; i++){
				$th = $("<th>").html(fieldList[i].title).attr("style", "min-width:"+fieldList[i].minWidth);
				if(fieldList[i].detail){
					$th.attr("name", "detail");
					if(detail === false){
						$th.hide();
					}else{
						$("#ledgerList").addClass("overflow-x-scroll");
					}
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
			
			let detail = $("#detailBtn").data("detail");
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
					$td = $("<td>").attr("style", "min-width:"+fieldList[j].minWidth);
					if(fieldList[j].detail){
						$td.attr("name", "detail");
						if(detail === false){
							$td.hide();
						}else{
							$("#ledgerList").addClass("overflow-x-scroll");
						}
					}					
					$td.append(fieldList[j].itemTemplate(list[i], fieldList[j].bankSeq));
					$tr.append($td);
				}
				$tb.append($tr);
			}
			return $tb;
		}
	}
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
					<select id="purSeq" class="select-gray wth100p">
						<option value="">전체</option>
					</select>
				</td>
				<th>상세목적</th>
				<td>
					<select id="purDtlSeq" class="select-gray wth100p">
						<option value="">전체</option>
					</select>
				</td>
				<th>은행</th>
				<td>
					<select id="bankSeq" class="select-gray wth100p">
						<option value="">전체</option>
						<option value="0">현금</option>
					</select>
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
<div id="ledgerList"></div>

