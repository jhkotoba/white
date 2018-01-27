<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerReCommon.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay())	
		
	let param = {};
	//param.startDate =  $("#startDate").val() + " 00:00:00";
	//param.endDate = $("#endDate").val() + " 23:59:59";
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
});


</script>
</head>
<body>
	
	record_money_re 메인<br>
	<input id="startDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
