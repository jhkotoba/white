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
	
	let param = {};
	param.sourceType = "Java";
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/source/selectSourceCodeList.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	console.log(data);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});	
});
</script>
	
	
</head>
<body>

<!-- <input id="wgTest" type="text" value="" /> -->

<div class="article">

	<select id="writeList">
	</select>
	<pre>
		<textarea rows="100%" cols="100%"></textarea>
	</pre>
</div>

</body>


