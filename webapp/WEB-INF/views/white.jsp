<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
	<meta charset=UTF-8>
	<title>whiteHome</title>
	<script type="text/javascript" src="resources/js/wcommon/jquery/jquery-3.2.0.js"></script>
	<script type="text/javascript" src="resources/js/wcommon/common.js"></script>
	
</head>
<body>
	<header>
		${sessionScope.userId}
		<c:if test="${sessionScope.authority == 'developer'}">(${sessionScope.authority})</c:if>
		<a href="${contextPath}/logoutProcess.do">logout</a> <br>		
	</header>
	<nav>
		<a href="${contextPath}/mainInfo.do">메인화면</a>
		<a href="${contextPath}/ledgerPage.do">가계부</a>
		<a href="${contextPath}/source.do">소스코드</a>
		<a href="${contextPath}/bookmark.do">북마크</a>
		<a href=#>게시판</a>
		<c:if test="${sessionScope.authority == 'developer'}">
			<a href="${contextPath}/testingPage.do">테스트 페이지</a>
		</c:if>
	</nav>
	
	<c:if test="${requestScope.sidePage != 'NOPAGE'}"> 
		<section>
			<jsp:include page="${requestScope.sidePage}" flush="false" />
		</section>
	</c:if>
	<section>
		<jsp:include page="${requestScope.sectionPage}" flush="false" />
	</section>
	<footer>
	</footer>
</body>
</html>