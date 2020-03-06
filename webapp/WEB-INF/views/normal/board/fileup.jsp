<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<c:set var="board" value="free"></c:set>

<script type="text/javascript">
$(document).ready(function(){

	$("#upbtn").on("click", function(){
		var form = $("#upload")[0];
		var formData = new FormData(form);
		
		$.ajax({
			url: "${contextPath}/board/upFile.ajax",
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

TEMP FILE UPLOAD
<br/><br/><br/>

<%-- action="${contextPath}/board/upFile.ajax" --%>
<form  id="upload" method="post" enctype="multipart/form-data">
	<input type="file" name="upfile">
	<button id="upbtn">upbtn</button>
	<!-- <input type="submit" name="submit"/> -->
</form>
