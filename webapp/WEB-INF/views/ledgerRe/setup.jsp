<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function(){	
	$("#monthTab").on("click", function(){
		
	});	
	$("#yearTab").on("click", function(){
		
	});	
});
</script>

<div class="article">
	<ul class="nav nav-tabs" id="" role="tablist">
		<li class="nav-item">
			<a class="nav-link text-secondary active nsrb" id="purposeTab" data-toggle="tab" href="#purpose" role="tab" aria-controls="purpose" aria-selected="true">Purpose</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="bankTab" data-toggle="tab" href="#bank" role="tab" aria-controls="bank" aria-selected="false">Bank</a>
		</li>		
	</ul>
	<div class="tab-content" id="setupTap">
		<div class="tab-pane fade show active" id="purpose" role="tabpanel" aria-labelledby="purposeTab">			
		</div>
		<div class="tab-pane fade" id="bank" role="tabpanel" aria-labelledby="bankTab">		
		</div>		
	</div>
</div>
