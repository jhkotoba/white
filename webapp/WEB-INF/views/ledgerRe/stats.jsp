<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function(){
	
	let statsList;
	recordStats("month");
	
	$("#monthTab").on("click", function(){
		recordStats("month");
	});	
	$("#yearTab").on("click", function(){
		recordStats("year");
	});
	$("#purposeTab").on("click", function(){
		recordStats("purpose");
	});
});

function recordStats(tap){
	
	let param = {};
	param.mode = tap;
	param.date = isDate.firstDay();
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectStatsList.ajax',	
		data: param,
		dataType: 'json',
	    success : function(data) {	    	
	    	console.log(data);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
}
</script>

<div class="article">
	<ul class="nav nav-tabs" id="" role="tablist">
		<li class="nav-item">
			<a class="nav-link text-secondary active nsrb" id="monthTab" data-toggle="tab" href="#month" role="tab" aria-controls="month" aria-selected="true">Month</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="yearTab" data-toggle="tab" href="#year" role="tab" aria-controls="year" aria-selected="false">Year</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary nsrb" id="purposeTab" data-toggle="tab" href="#purpose" role="tab" aria-controls="purpose" aria-selected="false">Purpose</a>
		</li>
	</ul>
	<div class="tab-content" id="statsTap">
		<div class="tab-pane fade show active" id="month" role="tabpanel" aria-labelledby="monthTab">
			<div></div>
		</div>		
		<div class="tab-pane fade" id="year" role="tabpanel" aria-labelledby="yearTab">
			<div></div>
		</div>
		<div class="tab-pane fade" id="purpose" role="tabpanel" aria-labelledby="purposeTab">
			<div></div>
		</div>
	</div>
</div>
