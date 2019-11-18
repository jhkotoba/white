<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="module"  src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
let demo = null;
$(document).ready(function(){	
	//초기설정
	fnInit();
});

function fnInit(){	
	demo = new wGrid("demo", {
		option : {
			isPaging : true,
			pageCount : 5,
			pageSize : 10
		}
		
		
	});
	
	
	
	
	
}
</script>

<div id="demo"></div>