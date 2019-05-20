<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function(){
	
});
</script>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>
<div id="sourcePager" class="pager"></div>