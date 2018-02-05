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
		if(timeType === "millisecond" || timeType === "second"){
			$("#timerNm").text(timeType);
		}else{
			$("#timerNm").text("");
		}		
	});
});

var bool = true;
function startTime(){
	
	var inputDate = $("#date").val();
	var inputtime = $("#time").val();
	
	var gorlDate = new Date(inputDate+ " " + inputtime).getTime();
	var nowDate = new Date();	
		
	var viewSec = gorlDate - nowDate.getTime();
	
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
	case "dd_hh:mm:ss.mmm":	
		timeSpeed = 30;
	
		if(viewSec < 0){
			$("#timer").text(0);
			timeState = false;
		}else{
			
		  	var day = Math.floor(viewSec / 86400000);
		    var hour = Math.floor((viewSec/3600000) % 24);
		    var min = Math.floor((viewSec/60000) % 60);
		    var sec = Math.floor((viewSec/1000) % 60);
		    var mil = String(viewSec).substr(String(viewSec).length-3, 3);
		    
		   
		    
		    $("#timer").text(day+" Day "+z(hour,2)+":"+z(min,2)+":"+z(sec,2)+"."+mil);
		    /* if(bool === true){
		    	$("#timer").css("font-size", "1ypx");
		    	bool = false;
		    }else{
		    	$("#timer").css("font-size", "15px");
		    	bool = true;
		    } */
		    
		}
		break;
	}	
	
	if(timeState === true)
		window.setTimeout('startTime()', timeSpeed);	
}

//숫자 앞 0 추가 함수 n원본 , digits 추가할 0의 개수
function z(n, digits) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (var i = 0; i < digits - n.length; i++)
		zero += '0';
	}
	return zero + n;
}

</script>
<body>
	<a href="/white/testMain.do">테스트 메인</a><br>	
	
	<input id="date" type="date" value="">
	<input id="time" type="time" value="08:00:00">
	<button id="startTime">시작</button>
	<button id="stopTime">종료</button>
	
	<br>
	<div>
		<input type="radio" name="timeType" checked="checked" value="millisecond" />millisecond
	 	<input type="radio" name="timeType" value="second" />second	 	
	 	<input type="radio" name="timeType" value="dd_hh:mm:ss.mmm" />dd_hh:mm:ss.mmm 

 	</div>
	
	<h1>TimerView</h1>
	<span id="timer">0</span> <span id="timerNm">millisecond</span>
</body>