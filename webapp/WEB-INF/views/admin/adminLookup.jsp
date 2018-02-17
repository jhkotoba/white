<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/admin/adminLookup.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#srcBtn").on("click", function(){
		let param = {};
		param.srhId = $("#srhId").val();
		param.srhNm = $("#srhNm").val();	
		param.pageNum = $("#pageNum").val();
		param.pageCnt = $("#pageCnt").val();
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/ajax/selectUserList.do',	
			data: param,
			dataType: 'json',
		    success : function(data) {		    
		    	ad.init(param.pageCnt, param.pageNum, data.count, data.userList).view().paging();
		    	//alert(Math.ceil(data.count/param.pageCnt));
			
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	});
	
});

</script>
</head>
<body>

<div>
	<input id="srhId" type="text" value="" placeholder="사용자 아이디">
	<input id="srhNm" type="text" value="" placeholder="사용자 이름">
	<!-- <input id="pageNum" type="hidden" value="1"> -->
	<input id="pageNum" type="text" value="1" placeholder="pageNum">
	
	<select id="pageCnt">
		<option value="5">5개</option>
		<option value="10" selected="selected">10개</option>
		<option value="20">20개</option>
		<option value="50">50개</option>
		<option value="100">100개</option>
	</select>
	
	<button id="srcBtn">검색</button>
</div>

<div id="userList">
	<table border="1">
		<thead>
			<tr>
				<th>userId</th>
				<th>userName</th>
				<!-- <th>login</th>
				<th>signUp</th> -->
				<th>edit</th>
			</tr>
		</thead>
	</table>
</div>

<div id="paging">
</div>
	
</body>
</html>
