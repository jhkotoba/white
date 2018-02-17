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
		ad.select();
	});
	
});

</script>
</head>
<body>

<div id="detail" class="userDetail">
	<table>
		<thead>
			<tr>
				<th>userNo</th>
				<th>userId</th>
				<th>userName</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>userNo</td>
				<td>userId</td>
				<td>userName</td>
			</tr>			
		</tbody>
	
	</table>
</div>

<div>
	<input id="srhId" type="text" value="" placeholder="사용자 아이디">
	<input id="srhNm" type="text" value="" placeholder="사용자 이름">
	<input id="pageNum" type="hidden" value="1">
		
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
</div>

<div id="paging">
</div>


</body>
</html>
