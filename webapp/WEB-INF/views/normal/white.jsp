<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<link rel="stylesheet" href="${contextPath}/resources/bootstrap-4.1.1/css/bootstrap.min.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/air-datepicker/css/datepicker.min.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/jsgrid-1.5.3/css/jsgrid.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/jsgrid-1.5.3/css/jsgrid-theme.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/common/css/common.css" type="text/css" />

<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/bootstrap-4.1.1/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/datepicker.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/i18n/datepicker.ko.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jsgrid-1.5.3/js/jsgrid.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jsgrid-1.5.3/js/db.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/cmmCode.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/common.js"></script>

</head>
<body>
	<nav class="nav">
		<a class="nav-brand" href="${contextPath}/main">white</a>
		<ul>
			<c:forEach items="${sessionScope.navList}" var="nav">
				<li class="dropdown">
					<a href="javascript:void(0);">${nav.navNm}</a>
					<div class="dropdown-content">								
						<c:forEach items="${sessionScope.sideList}" var="side">									
							<c:if test="${nav.navSeq eq side.navSeq }">
								<c:if test="${side.auth eq 1 }">
									<a class="sideHeight" href="javascript:mf.submit('${nav.navUrl}', '${side.sideUrl}')">${side.sideNm}</a>
								</c:if>
							</c:if>
						</c:forEach>
					</div>
				</li>
			</c:forEach>
		</ul>
		
		<div class="user">
			<c:if test="${sessionScope.userId eq null}">
				<a  href="${contextPath}/login/login.do"><img title="login" alt="login" src="${contextPath}/resources/common/img/login.png"></a>	
			</c:if>	
			<c:if test="${sessionScope.userId ne null}">
				<span>${sessionScope.userId}</span>			
				<a  href="${contextPath}/login/logoutProcess.do"><img title="logout" alt="logout" src="${contextPath}/resources/common/img/logout.png"></a>
			</c:if>
		</div>					
	</nav>	
	<section>		
        <main role="main" class="main">
        	<jsp:include page="${requestScope.sectionPage}" flush="false" />
        </main>
	</section>	
	<footer>		
	</footer>
	
	<form id="moveForm" action="">
		<input id="navUrl" name="navUrl" type="hidden" value="${navUrl}"></input>
		<input id="sideUrl" name="sideUrl" type="hidden" value="${sideUrl}"></input>
	</form>
	
	<div class="blind" style="display: none;">
	</div>
</body>
</html>