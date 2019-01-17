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
	</div>
</div>

<div id="ledgerList">		
</div>