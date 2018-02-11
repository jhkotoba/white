<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>
</head>
<body>
	adminSide.jsp<br>
	<form id="moveForm" action="">
		<input id="move" name="move" type="hidden" value=""></input>
	</form>		
	
	<div id="ledgerSideList">		
		<ul>
			<li><a href=#>li-1</a></li>					
		</ul>		
	</div>
	
</body>
