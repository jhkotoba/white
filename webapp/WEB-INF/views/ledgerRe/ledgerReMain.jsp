<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerReRecord.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/memo/memo.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	memo.init('${memoList}', "ledger").view();
	
	//메인조회 리스트
	recListView();
	
	//새로운 메모 추가
	$("#memoAddBt").click(function(){		
		memo.add();
	});	
	//취소
	$("#memoCancelBt").click(function(){
		memo.cancel();
	});	
	//메모 저장
	$("#memoSaveBt").click(function(){	
		memo.insert();
	});
});

//메인조회 리스트
function recListView(){
	$("#startDate").val(isDate.addMonToday(-1));
	$("#endDate").val(isDate.today())	
		
	let param = {};	
	param.startDate = $("#startDate").val() + " 00:00:00";
	param.endDate = $("#endDate").val() + " 23:59:59";
	param.mode = "main";
	$("#mainTitle").text($("#startDate").val() +" ~ "+ $("#endDate").val());
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/ajax/selectRecordList.do',	
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	rec.init("main", data.recList, '${purList}', '${purDtlList}', '${bankList}').view();	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});	
}

</script>
</head>
<body>	

	<div id="ledgerMemo">
		
		<button class="btn_azure03" id="memoAddBt">메모 추가</button>
		<button class="btn_azure03" id="memoSaveBt">메모 저장</button>
		<button class="btn_azure03" id="memoCancelBt">취소</button>
	
		<table id='memoTb'>
		</table>
	</div>	

	<input id="startDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">
	
	<h4 id="mainTitle"></h4>
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
