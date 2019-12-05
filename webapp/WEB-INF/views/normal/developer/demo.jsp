<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="module"  src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function(){
	//그리드 생성
	let demo = new wGrid("demo", {
		option : {
			isPaging : true,
			pageCount : 5,
			pageSize : 10
		},
		callback : {
			initDataConvert : function(data){
				console.log("callback - initDataConvert");
				console.log(data);
			},
			initedDataConvert : function(data){
				console.log("callback - initedDataConvert");
				console.log(data);
			}
		},
		controller : {
			load : function(){
				
			}			
		}
	});
	
	console.log(demo);
	
	//테스트 데이터
	let data = [
		{seq : 1, name : "이순신"},
		{seq : 2, name : "강감찬"},
		{seq : 3, name : "김유신"},
		{seq : 4, name : "이성계"},
	];
	
	//데이터 주입
	demo.setData(data);
	
	console.log("demo.getData()");
	console.log(demo.getData());
});
</script>

<div id="demo"></div>