<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/admin/selectMenuList").done(fnJsGrid);
});

function fnJsGrid(data){
	
	console.log(data);
	
	$("#menuList").jsGrid({
		height: "auto",
		width: "100%",
		
		data: data.navList,
		
		paging: false,
		pageSize: 10,
		
		rowClick: function(args) {
			//$(args.event.target).append("<div style='width:100px; height:100px; background: red;' ></div>");
			
		},
		
		fields: [
			{ align:"center", width: "5%",
				headerTemplate: function(){
					let thcss = " class='jsgrid-header-cell jsgrid-align-center' style='width: 5%;' ";
					
					//class="jsgrid-header-cell jsgrid-align-center"
					return "<th"+thcss+">1</th><th"+thcss+">2</th><th"+thcss+">3</th>";
					 
				},
				itemTemplate: function(value, item) {
					
				}				
			}
			/* { title:"순서",	name:"navOrder",	type:"text", align:"center", width: "5%"},
			{ title:"이름",	name:"navNm",		type:"text", align:"center", width: "5%"},
			{ title:"URL",	name:"navUrl",		type:"text", align:"center", width: "5%"}, */
			
		]
		
	});
	
	
	
	
}
</script>

<div id="menuList"></div>