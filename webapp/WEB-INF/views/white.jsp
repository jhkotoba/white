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
	<script type="text/javascript">
	//test start
	console.log("${sessionScope.authority.developer}");
	console.log("${sessionScope.authority.administrator}");	
	console.log("${sessionScope.authority.ledger}");
	console.log("${sessionScope.authority.user}");
	//test end
	
	</script>
</head>
<body>
	<header>	
		<c:if test="${sessionScope.userId eq null}">			
			<a href="${contextPath}/loginPage.do">login</a> <br>
		</c:if>	
		<c:if test="${sessionScope.userId ne null}">		
			${sessionScope.userId}
			<a href="${contextPath}/logoutProcess.do">logout</a> <br>
		</c:if>				
	</header>
	<nav>
		<c:choose>
			<c:when test="${sessionScope.authority.developer eq 1}">
				<a href="${contextPath}/mainInfo.do">메인화면</a>
				<a href="${contextPath}/ledgerPage.do">가계부</a>
				<a href="${contextPath}/source.do">소스코드</a>
				<a href="${contextPath}/bookmark.do">북마크</a>
				<a href="${contextPath}/adminPage.do">관리자</a>
				<a href="${contextPath}/testingPage.do">테스트 페이지</a>
			</c:when>
			
			<c:when test="${sessionScope.authority.administrator eq 1}">
				<a href="${contextPath}/mainInfo.do">메인화면</a>
				<a href="${contextPath}/ledgerPage.do">가계부</a>
				<a href="${contextPath}/source.do">소스코드</a>
				<a href="${contextPath}/bookmark.do">북마크</a>
				<a href="${contextPath}/adminPage.do">관리자</a>		
			</c:when>
			
			<c:otherwise>
				<a href="${contextPath}/mainInfo.do">메인화면</a>
				<c:if test="${sessionScope.authority.ledger eq 1}">			
					<a href="${contextPath}/ledgerPage.do">가계부</a>
				</c:if>
				<a href="${contextPath}/source.do">소스코드</a>
				<c:if test="${sessionScope.userId ne null}">					
					<a href="${contextPath}/bookmark.do">북마크</a>
				</c:if>
				<a href=#>게시판</a>
			</c:otherwise>
		
		</c:choose>
				
		
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