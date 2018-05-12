<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC>
<script type="text/javascript">

let n = 0;
let m = 0;

$(document).ready(function(){
	
	setInterval(function(){ 		
		$("#count1").text(n++);
	}, 10);
		
	roof();
	
});

function roof(){
	$("#count2").text(m++);
	window.setTimeout('roof()', 10);
}
</script>
<body>

	setInterval	:<span id="count1">0</span><br>
	setTimeout	:<span id="count2">0</span>
	
	<pre>	
let n = 0;
let m = 0;

$(document).ready(function(){
	
	setInterval(function(){ 		
		$("#count1").text(n++);
	}, 10);
		
	roof();
	
});

function roof(){
	$("#count2").text(m++);
	window.setTimeout('roof()', 10);
}
	</pre>

	
</body>