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
	let param = {};
	param.sourceType = "Java";
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/source/selectSourceCodeList.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	sourceCode(data);
	    		    	   	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});	
});

function sourceCode(data){
	let white = new White("testList");
	white.list = data;
	white.head = ["Date","Content"];
	white.column = ["regDate","content"];
	
	console.log("####");
	console.log(white.head);
	console.log(white.list);
	console.log(white.clone);	    	
	console.log(white.id);	    	
	console.log(white.eId);
	white.view();
}
</script>
	
	
</head>
<body>

<div id="testList">
</div>

</body>


