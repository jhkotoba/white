<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/record.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/memo/memo.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	//ledger 메모 리스트 조회
	memo.select("ledger");
	
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
	
	//메인조회 리스트
	$("#startDate").val(isDate.addMonToday(-1));
	$("#endDate").val(isDate.today())	
		
	let param = {};	
	param.startDate = $("#startDate").val() + " 00:00:00";
	param.endDate = $("#endDate").val() + " 23:59:59";
	param.mode = "index";
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectRecordList.ajax',	
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	rec.init("index", data.recList, data.purList, data.purDtlList, data.bankList).view();	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
});

</script>
</head>
<body>
	<div class="article">
		<div class="left width-vmin">
			<div class="form-control height-half">
				stats form1
			</div>
		</div>
		
		<div class="left width-vmin">
			<div class="form-control height-half">
				stats form2
			</div>
		</div>		
	</div>
	
	<div class="space left"></div>
	
	<div id="ledgerMemo" class="article">
		<div class="btn-group btn-group-sm width-full" role="group">
			<button id="memoAddBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">메모 추가</button>
			<button id="memoSaveBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">메모 저장</button>
			<button id="memoCancelBt" type="button" class="btn btn-secondary NanumSquareRoundB-15">취소</button>
		</div>
	
		<div id='memoTb'>
		</div>
	</div>
	

	<input id="startDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">
	
	<div class="space left"></div>
	
	<span class="article">This month Record</span>
	<div id="ledgerReList" class="article">		
	</div>
		
	
</body>
</html>
