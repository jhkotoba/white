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
});

function ledgerList(data){
	
	console.log(data);
	
	let $option = null;
	//목적
	for(let i=0; i<data.purList.length; i++){
		$option = $("<option>").val(data.purList[i].purSeq)
			.text(data.purList[i].purpose)
			.data("purType", data.purList[i].purType);		
		$("#searchBar #purpose").append($option);
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
		
		console.log(param);
		cfnCmmAjax("/ledger/selectRecordList", param).done(function(data){
			
			console.log(data);
			
			fnCreateLedgerList(data);
			
		});
		
		
		
		
		/* cfnCmmAjax("/ledger/insertRecordList", param).done(function(data){
			if(Number(data) > 0){
				alert(data + "행이 저장되었습니다.");

				insertList = new Array();
				insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"", content:"",
					purSeq: "", purDtlSeq: "", bankSeq: "", moveSeq: "", money: ""}
				);						
				$tbody.empty().append($("<div>").append(fnCreateRow()));					
			}else{
				alert("저장에 실패하였습니다. error:"+data);
				console.log("error:"+data);					
				for(let i=0; i<insertList.length; i++){						
					insertList[i].money = cfnSetComma(String(Math.abs(Number(insertList[i].money))));
				}					
			}
		}); */
	});
	

		
	//data.purList
	//data.bankList
	
	//가계부 리스트 생성
	function fnCreateLedgerList(list){
		$("#ledgerList").empty();
		
		let $tb = $("<table>");
		let $tr = $("<tr>");
		let $th = null;
		
		//간편보기 상세보기              *             *      *                         *       *
		//let titleList = ["날짜", "위치", "내용", "목적", 상세목적 "사용수단", "수입/지출", "소지금액", "현금"];
		let titleList = [
			{name: "날짜", 		detail: false},
			{name: "위치", 		detail: true},
			{name: "내용", 		detail: false},
			{name: "목적", 		detail: false},
			{name: "상세목적", 	detail: true},
			{name: "사용수단", 	detail: true},
			{name: "수입/지출", 	detail: false},
			{name: "소지금액", 	detail: false},
			{name: "현금", 		detail: true}
		];
		
		for(let i=0; i<data.bankList.length; i++){			
			titleList.push({name:data.bankList[i].bankName+"<br>("+data.bankList[i].bankAccount+")", detail:true});			
		}
		
		
		console.log(titleList);
		
		//titleList.push({title:"날짜", detail:true});
		
		
		/* for(let i=0; i<titleArr.length; i++){			
			$th = $("<th>").text(fieldList[i].title);
			$tr.append($th);						
		}
		$tb.append($tr); */
		
		/* for(let i=0; i<fieldList.length; i++){			
			$th = $("<th>").attr("style", "width:"+fieldList[i].width);			
			if(isNotEmpty(fieldList[i].headerTemplate)){
				$th.append(fieldList[i].headerTemplate());
			}else{
				$th.text(fieldList[i].title);
			}
			$tb.append($tr.append($th));			
		} */
		
		
		/* tag += "<table class='table table-striped table-bordered table-sm'>";
		tag	+= "<tr>";			
		tag	+= "<th>날짜</th>";
		tag	+= "<th>위치</th>";
		tag	+= "<th>내용</th>";
		tag	+= "<th>목적</th>";
		tag	+= "<th>상세목적</th>";
		tag	+= "<th>사용수단</th>";
		tag	+= "<th>수입/지출</th>";			
		tag	+= "<th>소지금액</th>";
		
		//index화면일 경우 간략화(금액은 +-금액과 총액만 출력)
		if(this.mode === "select"){
			tag	+= "<th>현금</th>";
			for(let i=0; i<this.bankList.length; i++){
				tag += "<th>"+this.bankList[i].bankName+"<br>("+(this.bankList[i].bankAccount==="cash" ? "":this.bankList[i].bankAccount) +")</th>";
			}
		}	
		tag += "</tr>";	 */
		
	
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

<div id="ledgerList">		
</div>