<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>
<link rel="stylesheet" href="${contextPath}/resources/css/white.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/css/btn.css" type="text/css" />
<link rel="stylesheet" href="${contextPath}/resources/css/icon.css" type="text/css" />

<script type="text/javascript" src="${contextPath}/resources/js/wcommon/jquery/jquery-3.2.0.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/wcommon/common.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	$("#sideMenu>ul>li").click(function(){		
		$("#moveForm #move").attr("value", this.id);	
		$("#moveForm").attr("method", "post");
		$("#moveForm").attr("action", common.path()+"${navUrl}").submit();
	});	
});

</script>
</head>
<body>
	<header class='header'>	
		<c:if test="${sessionScope.userId eq null}">			
			<a class="btn_azure02" href="${contextPath}/login/login.do">login</a> <br>
		</c:if>	
		<c:if test="${sessionScope.userId ne null}">		
			${sessionScope.userId}
			<a class="btn_azure02" href="${contextPath}/login/logoutProcess.do">logout</a> <br>
		</c:if>				
	</header>
	<nav>	
		<a href="${contextPath}/main">메인화면</a>	
		<c:forEach items="${sessionScope.navList}" var="item">			
			<c:if test="${item.auth eq 1 }">
				<a href="${contextPath}${item.navUrl}">${item.navNm}</a>
			</c:if>
		</c:forEach>
	</nav>
	
	<form id="moveForm" action="">
		<input id="move" name="move" type="hidden" value=""></input>
	</form>
		
	<c:if test="${requestScope.sideList ne null}">
		<section class="sideView">
			<div id="sideMenu">
				<ul>
					<li>메인</li>
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