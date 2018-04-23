<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>


<link href="dist/css/datepicker.min.css" rel="stylesheet" type="text/css">
<script src="dist/js/datepicker.min.js"></script>

<!-- Include English language -->
<script src="dist/js/i18n/datepicker.en.js"></script>

<link rel="stylesheet" href="${contextPath}/resources/css/air-datepicker/datepicker.min.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/js/air-datepicker/datepicker.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/air-datepicker/i18n/datepicker.ko.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
});


</script>

<input type='text' class='datepicker-here' data-language='ko' />


