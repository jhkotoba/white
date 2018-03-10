<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>whiteHome</title>
<script type="text/javascript">

$(document).ready(function(){			
	$("#sideMenu>ul>li").click(function(){
		white.sideSubmit("admin", this.id);
	});	
});

</script>
</head>
<body>
	<form id="moveForm" action="">
		<input id="move" name="move" type="hidden" value=""></input>
	</form>		
	
	<div id="sideMenu">		
		<ul>
			<li>메인</li>
			<li id="Lookup">사용자 조회</li>
			<li id="Menu">메뉴 설정</li>
			<li id="Authority">권한 설정</li>
						
		</ul>		
	</div>
	
</body>
 --%>