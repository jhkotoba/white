<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function(){	
	//초기 탭 표시설정
	let tab = $("#moveForm #tab").val() === "" ? "purpose" : $("#moveForm #tab").val();	
	$("#setupTap #"+tab).addClass("show active");
	$("#"+tab+"Tab").addClass("active").attr("aria-selected", "true");
	$("#moveForm #tab").val("");
});
</script>

<div class="article">
	<ul class="nav nav-tabs" id="" role="tablist">
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="purposeTab" data-toggle="tab" href="#purpose" role="tab" aria-controls="purpose">Purpose</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="bankTab" data-toggle="tab" href="#bank" role="tab" aria-controls="bank">Bank</a>
		</li>		
	</ul>
	<div class="tab-content" id="setupTap">
		<div class="tab-pane fade" id="purpose" role="tabpanel" aria-labelledby="purposeTab">
			<jsp:include page="./setup/purpose.jsp" flush="false" />		
		</div>
		<div class="tab-pane fade" id="bank" role="tabpanel" aria-labelledby="bankTab">	
			<jsp:include page="./setup/bank.jsp" flush="false" />
		</div>		
	</div>
</div>
