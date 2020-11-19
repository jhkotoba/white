<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 개발로직 테스트 --%>
<c:if test="${sessionScope.userId eq 'leedev'}">
<h2>TEST PAGE</h2><br>

FILE UPLOAD TEXT VIEW<br/>
<%-- action="${contextPath}/board/upFile.ajax" --%>
<form  id="upload" method="post" enctype="multipart/form-data">
	<input type="file" name="upfile">
	<button id="upbtn">upbtn</button>
	<!-- <input type="submit" name="submit"/> -->
</form>
<script type="text/javascript">
$(document).ready(function(){

	$("#upbtn").on("click", function(){
		var form = $("#upload")[0];
		var formData = new FormData(form);
		
		$.ajax({
			url: common.path() + "/main/upFile.ajax",
	        processData: false,
	        contentType: false,
	        data: formData,
	        type: "post",
	        success: function(result){
	            console.log("success:", result);
	        }
		});
	});
});
</script>


AJAX TEST<br/>
<script type="text/javascript">
$(document).ready(function(){
	
	let ajaxData = {};
	ajaxData.test1 = "TEST_DATA";
	ajaxData.test2 = {STRING:"TEST", NUMBER:100};
	ajaxData.test3 = ["TEST1", "TEST2"];
	$("#ajaxData").val(JSON.stringify(ajaxData));	
	
	//비동기 통신 테스트
	$("#ajaxTestBtn").on("click", function(){
		
		//@ResponseBody
		//@PostMapping(value="/main/whiteTest1.ajax")	
		//public String whiteTest1(@RequestBody RModel model){ ... }
		$.ajax({
			url: common.path()+'/main/whiteTest1.ajax',
			contentType: "application/json",
			type: "POST",
			data :  JSON.stringify(ajaxData),
			dataType: "json",
		    success : function(data) {
		    	console.log(data);
		    }
		});
		
		//@ResponseBody
		//@PostMapping(value="/main/whiteTest1.ajax")	
		//public String whiteTest1(@RequestBody Map<String, Object> map){ ... }
		$.ajax({
			url: common.path()+'/main/whiteTest2.ajax',
			contentType: "application/json",
			type: "POST",
			data :  JSON.stringify(ajaxData),
			dataType: "json",
		    success : function(data) {
		    	console.log(data);
		    }
		});
	});
});
</script>
<textarea id="ajaxData" style="width: 500px; height: 100px;"></textarea>
<button id="ajaxTestBtn">ajax</button>
</c:if>

