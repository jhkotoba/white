<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<head>
<meta charset=UTF-8>
<title>whiteHome</title>
<script type="text/javascript" src="${contextPath}/resources/white/js/whiteGrid.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	let wg = new whiteGrid("test");
});
</script>
	
	
</head>
<body>
write.jsp<br>

<input id="test" type="text" value="" />

</body>


