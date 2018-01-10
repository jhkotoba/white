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
	ledgerSide.jsp<br>
	<form id="sideClickForm" action="">
		<input id="sideClick" name="sideClick" type="hidden" value=""></input>
		<input id="userSeq" name="userSeq" type="hidden" value="${userSeq}"></input>
	</form>	
	
	<div id="ledgerSideList">		
		<ul>
			<li onclick="ledgerSide.pageSubmit('Main')"><a href=#>메인</a></li>
			<li onclick="ledgerSide.pageSubmit('Select')"><a href=#>조회</a></li>
			<li onclick="ledgerSide.pageSubmit('Insert')"><a href=#>입력</a></li>
			<li onclick="ledgerSide.pageSubmit('Statistics')"><a href=#>통계</a></li>
			<li><a id="ledgerSetup" href=#>설정</a>
				<div id="setupList" style="display: none">
					<ol>			
						<li onclick="ledgerSide.pageSubmit('SetupPurpose')"><a href=#>목적설정</a></li>
						<li onclick="ledgerSide.pageSubmit('SetupBank')"><a href=#>은행설정</a></li>										
					</ol>
				</div>
			</li>
			<!-- <li onclick="ledgerSide.pageSubmit('Data')"><a href=#>데이터</a></li> 사용안함	 -->			
		</ul>		
	</div>
	
</body>
