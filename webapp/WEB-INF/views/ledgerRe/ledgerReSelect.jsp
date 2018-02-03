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
<script type="text/javascript">
$(document).ready(function(){
	
	//메인조회 리스트
	recListView();
	
	//수정 및 삭제
	$("#recEditBt").click(function(){
		rec.edit();
	});
	
	//취소
	$("#recCelBt").click(function(){
		rec.cancel();
	});
});

//메인조회 리스트
function recListView(){
	
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay())	

	$("#recShBt").click(function(){	
		
		let param = {};
		param.startDate =  $("#startDate").val() + " 00:00:00";
		param.endDate = $("#endDate").val() + " 23:59:59";
		param.mode = "select";
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/ajax/selectRecordList.do',	
			data: param,
			dataType: 'json',
		    success : function(data) {	    	
		    	rec.init("select", data.recList, '${purList}', '${purDtlList}', '${bankList}').view();	
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
}


</script>
</head>
<body>
	
	<h4>금전기록 기간조회</h4>
	<div>
		<input id="startDate" type="date" value="">
		<input id="endDate" type="date" value="">
		<button class="btn_azure03" id="recShBt">조회</button>
		<button class="btn_azure03" id="recEditBt">편집</button>
		<button class="btn_azure03" id="recCelBt">취소</button>
	</div>
	
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
