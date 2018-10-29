<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/admin/selectMenuList").done(fnNavJsGrid);
	cfnCmmAjax("/admin/selectMenuList").done(fnSideJsGrid);
});

function fnNavJsGrid(data){
	
	console.log(data);
	
	$("#navMenuList").jsGrid({
		height: "auto",
		width: "49.8%",
		
		data: data.navList,
		
		paging: false,
		pageSize: 10,
		
		rowClick: function(args) {
			//$(args.event.target).append("<div style='width:100px; height:100px; background: red;' ></div>");
			
		},
		
		fields: [			
			{ title:"순서",	name:"navOrder",	type:"text", align:"center", width: "10%"},
			{ title:"이름",	name:"navNm",		type:"text", align:"center", width: "21%"},
			{ title:"URL",	name:"navUrl",		type:"text", align:"center", width: "35%"},
			{ title:"권한",	align:"center", width: "22%"},
			{ title:"표시",	name:"navShowYn",		type:"text", align:"center", width: "12%"}			
		]
	});
	
	
	
	
}
function fnSideJsGrid(data){
	
	console.log(data);
	
	$("#sideMenuList").jsGrid({
		height: "auto",
		width: "49.8%",
		
		data: data.sideList,
		
		paging: false,
		pageSize: 10,
		
		fields: [			
			{ title:"순서",	name:"sideOrder",	type:"text", align:"center", width: "10%"},
			{ title:"이름",	name:"sideNm",		type:"text", align:"center", width: "21%"},
			{ title:"URL",	name:"sideUrl",		type:"text", align:"center", width: "35%"},
			{ title:"권한",	align:"center", width: "22%"},
			{ title:"표시",	name:"sideShowYn",		type:"text", align:"center", width: "12%"}
		]
	});
	
	
	
	
}
</script>

<div id="searchBar" class="search-bar">
	<button id="navAdd" class="btn-gray">상위메뉴 추가</button>
	<button id="sideAdd" class="btn-gray">하위메뉴 추가</button>
	<div class="pull-right">	
		<button id="save" class="btn-gray">저장</button>
		<button id="cancel" class="btn-gray">취소</button>
	</div>
</div>

<div>
	<div id="navMenuList" class="pull-left"></div>
	<div id="sideMenuList"  class="pull-right"></div>
</div>



