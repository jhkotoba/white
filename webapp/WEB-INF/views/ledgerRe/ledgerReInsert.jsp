<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerReInsert.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	recIn.init('${purList}','${purDtlList}','${bankList}').add();	
	
	$("#recAddBtn").click(function(){		
		recIn.add();
	});
	
	$("#recDelBtn").click(function(){		
		recIn.del();
	});
	
	
	
});

</script>
</head>
<body>
	
	<h4>금전기록 등록</h4>
	<div id="recIn">
		<button id="recAddBtn">추가</button>
		<button id="recDelBtn">삭제</button>
	</div>
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
