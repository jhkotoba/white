<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!-- test css -->
<style>
.input-sm{
    background: #4C4C4C;
	color:#C6C6C6;	
	border: 1px solid transparent;
	border-radius: 2px;
	box-shadow:0 3px 15px rgba(0,0,0,.35);
}
.input-md{
    background: #4C4C4C;
	color:#C6C6C6;
	height: 30px;
	border: 1px solid transparent;
	border-radius: 2px;
	box-shadow:0 3px 15px rgba(0,0,0,.35);
	font-size: 1.4em;
	
}
.input-lg{
    background: #4C4C4C;
	color:#C6C6C6;
	height: 40px;
	border: 1px solid transparent;
	border-radius: 2px;
	box-shadow:0 3px 15px rgba(0,0,0,.35);
	font-size: 2em;
}
</style>

<h4>input</h4>

<div style="display: inline-block;">
	<h6>input-sm</h6>
	<input class="input-sm" type="text" placeholder="input-sm">
	
	<h6>input-md</h6>
	<input class="input-md" type="text" placeholder="input-md">
	
	<h6>input-lg</h6>
	<input class="input-lg" type="text" placeholder="input-lg">
</div>