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

<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/earlyaccess/hanna.css">
<style>
.hanna-20{
  font-family: 'Hanna', serif;
  font-size: 20px;
}
.hanna-15{
  font-family: 'Hanna', serif;
  font-size: 15px;
}
</style>
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
	
	$("#sideMenu>div>a").click(function(){		
		//white.submit("${navUrl}", this.id);
		console.log(this.id);
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
	
	<nav id="navMenu" class="navbar navbar-expand-lg navbar-dark bg-dark hanna-20">
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

	<c:if test="${requestScope.sideList ne null}">
		<section class="d-flex hanna-15">
			<div id="sideMenu">
				<ul class="nav flex-column text-white bg-dark" style="height: 100%;">
					<li class="nav-item" id="/index">
						<a class="nav-link" style="cursor:pointer; width:150px;">메인</a>
					</li>
					<c:forEach items="${requestScope.sideList}" var="item">			
						<c:if test="${item.auth eq 1 }">
							<li id="${item.sideUrl}">
								<a class="nav-link" style="cursor:pointer; width:150px;">${item.sideNm}</a>
							</li>
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
	<form id="moveForm" action="">
		<input id="navUrl" name="navUrl" type="hidden" value="${navUrl}"></input>
		<input id="sideUrl" name="sideUrl" type="hidden" value="${sideUrl}"></input>
	</form>
</body>
</html>