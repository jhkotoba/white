<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerRecord.js"></script>
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
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay())	
		
	let param = {};	
	param.limit = 100;
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/ajax/selectRecordList.do',	
		data: param,
		dataType: 'json',
	    success : function(data) {	    	
	    	rec.recList = data.recList;
	    	rec.bankList = data.bankList;
	    	rec.view();		    	
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
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
