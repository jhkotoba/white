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
<link rel="stylesheet" href="${contextPath}/resources/jsgrid-1.5.3/css/jsgrid.min.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/jsgrid-1.5.3/css/jsgrid-theme.min.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/common/css/common.css" type="text/css" />

<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/bootstrap-4.1.1/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/datepicker.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/i18n/datepicker.ko.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jsgrid-1.5.3/js/jsgrid.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jsgrid-1.5.3/js/db.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/cmmCode.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/common.js"></script>

<script type="text/javascript">
/* $(document).ready(function(){
	$(".nav-drop").mouseover(function(e) {
		console.log(e);
		e.target.outerText
		//$(".nav-dropdown").show(300);
		$("#d"+e.target.id).show(300);
	});
	$(".nav-drop").mouseleave(function(e) {
		$("#d"+e.target.id).hide(300);     
	});
}); */
</script>

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
				<a  href="${contextPath}/login/login.do"><img alt="login" src="${contextPath}/resources/common/img/login.png"></a>	
			</c:if>	
			<c:if test="${sessionScope.userId ne null}">
				<span>${sessionScope.userId}</span>			
				<a  href="${contextPath}/login/logoutProcess.do"><img alt="logout" src="${contextPath}/resources/common/img/logout.png"></a>
			</c:if>
		</div>
					
	</nav>
		
			
	<%-- <nav class="navbar navbar-expand-lg navbar-dark bg-dark nsrb" style='font-size: 20px;'>
		<a class="navbar-brand col-sm-3 col-md-2 mr-0" href="${contextPath}/main">white</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNavDropdown">
			<ul class="navbar-nav">
				<c:forEach items="${sessionScope.navList}" var="nav">
					<c:if test="${nav.auth eq 1 }">
						<li id="${nav.navUrl}" class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="cursor:pointer;">${nav.navNm}</a>
							<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">								
								<c:forEach items="${sessionScope.sideList}" var="side">									
									<c:if test="${nav.navSeq eq side.navSeq }">
										<c:if test="${side.auth eq 1 }">
											<a class="dropdown-item nsrb" href="javascript:mf.submit('${nav.navUrl}', '${side.sideUrl}')">${side.sideNm}</a>
										</c:if>
									</c:if>
								</c:forEach>
							</div>
						</li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
	</nav> --%>
	
	<section>		
        <main role="main">
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