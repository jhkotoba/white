<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerRePurpose.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/ajax/selectPurAndDtlList.do',
		dataType: 'json',
	    success : function(data) {	    	
	    	pur.init(data.purList, data.purDtlList).purView().purDtlView();	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});	
});

</script>
</head>
<body>
	
	<div class="left">
		<button id="purSaveBtn" class="btn_azure03" disabled="disabled">목적 저장</button>
		<button id="purCelBtn" class="btn_azure03" disabled="disabled">취소</button>
		<div id="purList" class="scroll"></div>	
	</div>
	
	<div class="left">
		<button id="purSaveBtn" class="btn_azure03" disabled="disabled">상세목적 저장</button>
		<button id="purCelBtn" class="btn_azure03" disabled="disabled">취소</button>
		<div id="purDtlList" class="scroll"></div>
	</div>
</body>


