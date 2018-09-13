<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	//권한리스트 조회
	fnSelectAuth().done(function(data){
		fnJsGrid(data);
	});
});

//권한 grid
function fnJsGrid(data, pageSize){
	$("#authList").jsGrid({
		height: "auto",
		width: "100%",
		
		inserting: true,
		editing: true,
		paging: true,
		pageSize: isEmpty(pageSize) === true ? 10 : pageSize,       
		autoload: true,        
		data: data,
		fields: [			
			{ title:"권한명",		name:"authNm",	type:"text", align:"center"},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center"}			
		]
	});
}
</script>

<div class="search-bar pull-right">
	<button class="btn-gray">추가</button>
	<button class="btn-gray">취소</button>
	<button class="btn-gray">저장</button>
</div>

<div id="authList"></div>