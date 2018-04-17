<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/admin/lookup.js?ver=0.003"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#srhBtn").on("click", function(){
		look.select();
	});
});
</script>

<input id="pageNum" type="hidden" value="1">

<div class="article">

	<h6>User Search</h6>
	<div class="left">	
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">조건</span>
			</div>
			<select id="srhSlt" class="custom-select">
				<option value="all">전체</option>
				<option value="id">아이디</option>
				<option value="nm">이름</option>
			</select>			
		</div>
	</div>
	
	<div class="left">
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">개수</span>
			</div>			
			<select id="pageCnt" class="custom-select">
				<option value="5">5개</option>
				<option value="10" selected="selected">10개</option>
				<option value="20">20개</option>
				<option value="50">50개</option>
				<option value="100">100개</option>
			</select>
		</div>
	</div>
		
	<div class="left">
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">내용</span>
			</div>
			<input id="srhMsg" class="form-control" type="text">
		</div>
	</div>
	
	<div class="left">
		<button id="srhBtn" class="btn btn-secondary">조회</button>
	</div>	

	<div id="userList">	
	</div>
	
	<div id="paging" style="margin-left: 45%;">
	</div>
</div>