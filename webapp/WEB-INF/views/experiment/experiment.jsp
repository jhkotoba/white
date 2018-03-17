<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
	
<style type="text/css">		
</style>

<script type="text/javascript">
$(document).ready(function(){
	
	
	/* set Test */
	/* 고유하지 않은 값을 Set에 추가하려고 하면 새 값이 컬렉션에 추가되지 않습니다. */
	
	/* 참고 */
	/* https://msdn.microsoft.com/ko-kr/library/dn251547(v=vs.94).aspx */
	/* https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Set */
	
	//Set TEST
	/* let set = new Set();
	set.add("test1");
	set.add("test2");
	set.add("test3");
	set.add("test1"); //<-- 중복
	
	console.log("set.forEach(function(item){...})");				
	set.forEach(function(item){
		console.log("item.toString():" + item.toString());				
	});
	console.log("set.size: "+set.size);
	
	console.log("");
	console.log("set.has('test1') : "+set.has("test1"));
	console.log("set.has('test100') : "+set.has("test100")); */
	
	
		
});	
</script>
</head>
<body>
	<h2>Test List</h2><br>
	<a href="${contextPath}/experiment/cssDemo.do">cssDemo</a><br>
	<a href="${contextPath}/experiment/exitTimer.do">exitTime</a><br>
	<a href="${contextPath}/experiment/roofTest.do">roofTest</a><br>
	
</body>
</html>