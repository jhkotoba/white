<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>
	
<style type="text/css">
	
.box1 {
   margin-top: 40px;
   width: 20px;
   height: 20px;
   background-color: blue;
   position: relative;
}

	
	
	
</style>
<script type="text/javascript" src="resources/js/wcommon/jquery/jquery-3.2.0.js"></script>

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
	
	
	var left = 50;
	
	/* setInterval(function() {
	    $('.box1')
	        .animate({
	            left: left,
	            bottom: 300
	        }, 1000);
	        
	    	left-=5;
	    $('.box1').animate({
	            left: 0,
	            bottom: 0
	            
	        }, 1000);
	    
	}, 3000) */
	
	  

		

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


		
});	
</script>
</head>
<body>
	testing.jsp<br>
	<a href="/white/mainInfo.do">메인화면</a><br>
	
	<div id="testList">		
		<ul>
			<li>test1</li>					
		</ul>		
	</div>
	
	<br><br>	
	<!-- <form id="reqeustTest" action="/white/requestTest.do" method="post" enctype="application/x-www-form-urlencoded">
		<input type="hidden" name="test1" value="1111">
		<input type="hidden" name="test2" value="2222">
		<input type="hidden" name="test3" value="3333">		
	</form> -->
	<br><br><br><br><br><br><br><br><br><br><br><br><br>
	
	<div class="box1"></div>	
	
	
	
		
</body>
</html>
