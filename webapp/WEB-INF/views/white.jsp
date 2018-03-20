<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>whiteHome</title>
<link rel="stylesheet" href="${contextPath}/resources/css/white.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/css/btn.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/css/icon.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/bootstrap/css/bootstrap.css" type="text/css" />
<%-- <link rel="stylesheet" href="${contextPath}/resources/bootstrap/css/bootstrap-reboot.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/bootstrap/css/bootstrap-grid.css" type="text/css" /> --%>


<script type="text/javascript" src="${contextPath}/resources/js/wcommon/jquery/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/bootstrap/js/bootstrap.js"></script>
<%-- <script type="text/javascript" src="${contextPath}/resources/bootstrap/js/bootstrap.bundle.js"></script> --%>


<script type="text/javascript" src="${contextPath}/resources/js/wcommon/common.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	
	$("#navbarNav>ul>li").click(function(){
		white.submit(this.id, "/index");
	});
	
	$("#sideMenu>ul>li").click(function(){		
		white.submit("${navUrl}", this.id);
	});	
});

</script>
</head>
<body>
	<header class='header'>	
		<c:if test="${sessionScope.userId eq null}">
			<a href="${contextPath}/login/login.do" class="badge badge-light">login</a>	
		</c:if>	
		<c:if test="${sessionScope.userId ne null}">
			<span class="badge badge-primary">${sessionScope.userId}</span>			
			<a href="${contextPath}/login/logoutProcess.do" class="badge badge-light">logout</a>
		</c:if>				
	</header>
	
	<nav id="navMenu" class="navbar navbar-expand-lg navbar-dark bg-dark">
		<a class="navbar-brand" href="${contextPath}/main">white</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
		    <span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">			
			<ul class="navbar-nav">	
				<c:forEach items="${sessionScope.navList}" var="item">			
					<c:if test="${item.auth eq 1 }">
						<li id="${item.navUrl}" class="nav-item">
							<a class="nav-link" style="cursor:pointer;">${item.navNm}</a>
						</li>
					</c:if>
				</c:forEach>
			</ul>			
		</div>
	</nav>
	
	<%-- 안정되면 삭제 --%>
	<%-- <nav id="navMenu">
		<ul>
			<li id="/main">메인화면</li>	
			<c:forEach items="${sessionScope.navList}" var="item">			
				<c:if test="${item.auth eq 1 }">
					<li id="${item.navUrl}">${item.navNm}</li>
				</c:if>
			</c:forEach>
		</ul>
	</nav> --%>
	
	<form id="moveForm" action="">
		<input id="navUrl" name="navUrl" type="hidden" value="${navUrl}"></input>
		<input id="sideUrl" name="sideUrl" type="hidden" value="${sideUrl}"></input>
	</form>
	
	<c:if test="${requestScope.sideList ne null}">
		<section class="sideView">
			<div id="sideMenu">
				<ul>
					<li id="/index">메인</li>
					<c:forEach items="${requestScope.sideList}" var="item">			
						<c:if test="${item.auth eq 1 }">
							<li id="${item.sideUrl}">${item.sideNm}</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</section>
	</c:if>
	
	<section class="mainView">
		<jsp:include page="${requestScope.sectionPage}" flush="false" />
	</section>
	<footer>
	</footer>
</body>
</html>