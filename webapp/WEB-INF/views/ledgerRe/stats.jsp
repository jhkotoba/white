<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){
	
	
	
	
	$("#monthTab").on("click", function(){
		
	});
	$("#yearTab").on("click", function(){
		
	});
	$("#purposeTab").on("click", function(){
		
	});
});
</script>

<div class="article">
	<ul class="nav nav-tabs" id="" role="tablist">
		<li class="nav-item">
			<a class="nav-link text-secondary active nsrb" id="monthTab" data-toggle="tab" href="#month" role="tab" aria-controls="month" aria-selected="true">월별</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="yearTab" data-toggle="tab" href="#year" role="tab" aria-controls="profile" aria-selected="false">년별</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="purposeTab" data-toggle="tab" href="#purpose" role="tab" aria-controls="contact" aria-selected="false">목적별</a>
		</li>
	</ul>
	<div class="tab-content" id="myTabContent">
		<div class="tab-pane fade show active" id="month" role="tabpanel" aria-labelledby="monthTab">
			<input value="" type="text" class="form-control">
		</div>
		<div class="tab-pane fade" id="year" role="tabpanel" aria-labelledby="yearTab">
		
		
		
		</div>
		<div class="tab-pane fade" id="purpose" role="tabpanel" aria-labelledby="purposeTab">
		
		
		
		</div>
	</div>
</div>
