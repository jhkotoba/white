<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<script type="text/javascript" src="resources/js/ledger/ledgerSide.js"></script>	
<title>Insert title here</title>
</head>
<body>
	adminSide.jsp<br>
	<form id="sideClickForm" action="">
		<input id="sideClick" name="sideClick" type="hidden" value=""></input>
		<input id="userSeq" name="userSeq" type="hidden" value="${userSeq}"></input>
	</form>	
	
	<div id="ledgerSideList">		
		<ul>
			<li><a href=#>메인 설정</a></li>			
		</ul>		
	</div>
	
</body>
