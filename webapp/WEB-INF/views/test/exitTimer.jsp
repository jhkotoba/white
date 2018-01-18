<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC>
<script type="text/javascript" src="resources/js/wcommon/jquery/jquery-3.2.0.js"></script>
<script type="text/javascript" src="resources/js/wcommon/common.js"></script>
<script type="text/javascript">

var timeState = false;
var timeSpeed = 30;
var timeType = "millisecond";

$(document).ready(function(){
	$("#date").val(isDate.today());
	
	$("#startTime").click(function(){
		if(timeState === true) return;
		
		timeState = true;		
		startTime();				
	});
	
	$("#stopTime").click(function(){
		timeState = false;
	});
	
	$("input[name=timeType]").change(function() {		
		timeType = $(":input:radio[name=timeType]:checked").val();
		$("#timerNm").text(timeType);
	});
});


function startTime(){
	
	var inputDate = $("#date").val();
	var inputtime = $("#time").val();
	
	var nowDate = new Date();
	
	var gorlDate = new Date(inputDate+ " " + inputtime).getTime();	
	var viewSec = gorlDate - nowDate.getTime();
	
	if(viewSec < 0){
		$("#timer").text(0);
		timeState = false;
	}else{
		$("#timer").text(viewSec);
	}		
	
	switch(timeType){
	
	case "millisecond":
		timeSpeed = 30;		
		
		if(viewSec < 0){
			$("#timer").text(0);
			timeState = false;
		}else{
			$("#timer").text(viewSec);
		}
			
		break;
	case "second":
		timeSpeed = 1000;
		
		if(viewSec < 0){
			$("#timer").text(0);
			timeState = false;
		}else{
			$("#timer").text(Math.floor(viewSec/1000));
		}
			
		break;
	}	
	
	if(timeState === true)
		window.setTimeout('startTime()', timeSpeed);	
}


</script>
<body>
	<a href="/white/testingPage.do">테스트 메인</a><br>	
	
	<input id="date" type="date" value="">
	<input id="time" type="time" value="18:30:00">
	<button id="startTime">시작</button>
	<button id="stopTime">종료</button>
	
	<br>
	<div>
		<input type="radio" name="timeType" checked="checked" value="millisecond" />millisecond
	 	<input type="radio" name="timeType" value="second" />second	 	
 	</div>
	
	<h1 id="view">View</h1>
	<span id="timer">0</span> <span id="timerNm">millisecond</span>
</body>