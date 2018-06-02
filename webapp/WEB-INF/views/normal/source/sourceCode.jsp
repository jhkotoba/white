<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<head>
<meta charset=UTF-8>
<title>whiteHome</title>
<script type="text/javascript" src="${contextPath}/resources/white/js/grey.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	let grey = new Grey("testList");
	grey.head = ["Date","Content"];
	grey.column = ["regDate","content"];
	grey.isClone = false;
	
	sourceAjax(grey, "all");
});

function sourceAjax(grey, sourceType){	
	
	let param = {};
	param.sourceType = sourceType;
	param.pageNum = grey.pageNum,
	param.pageCnt = grey.pageCnt;
	param.totalCnt = grey.totalCnt;
	
	$.ajax({	
		type: 'POST',
		url: common.path()+'/source/selectSourceCodeList.ajax',
		data: param,
		dataType: 'json',
	    success : function(data) {
	    	grey.totalCnt = data.totalCnt;
	    	grey.list = data.list;	    	
	    	grey.view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    } 
	});	
}
</script>
	
	
</head>
<body>

<div id="testList">
</div>

</body>


