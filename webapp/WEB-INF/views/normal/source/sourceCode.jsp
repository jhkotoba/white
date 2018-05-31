<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<head>
<meta charset=UTF-8>
<title>whiteHome</title>
<script type="text/javascript" src="${contextPath}/resources/white/js/white.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	let white = new White("testList");
	
	let param = {};
	param.sourceType = "Java";
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/source/selectSourceCodeList.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	console.log(data);
	    	white.head = ["aaa","bbb","ccc", 1, 2, 3, true, false];
	    	white.list = data;
	    	
	    	console.log(white.head);
	    	console.log(white.list);
	    	console.log(white.clone);	    	
	    	console.log(white.id);	    	
	    	console.log(white.eId);	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});
	
	
	console.log("####");
	
	
	
	
	
	
	
	
	
	
	
});
</script>
	
	
</head>
<body>

<div id="testList">
</div>

</body>


