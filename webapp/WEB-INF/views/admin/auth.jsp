<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/admin/auth.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/admin/selectAuthList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {	
	    	console.log(data);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//헤더메뉴 추가
	$("#authAddBtn").click(function(){		
		auth.add().view();
	});
	
	//취소
	$("#authCelBtn").click(function(){		
		auth.cancel().view();
	});
	
	//권한 저장, 수정, 삭제
	$("#authSaveBtn").click(function(){
		let rtn = auth.check();
		if(rtn.check === true){
			auth.save();
		}else{
			alert(rtn.msg);
		}
	});	
});

</script>
</head>
<body>
	
	<div>
		<span class='add'>■추가</span>
		<span class='edit'>■수정</span>
		<span class='redLine'>■삭제</span>
	</div>
	<br>
	
	<div>
		<button id="authAddBtn" class="btn_azure03">추가</button>
		<button id="authSaveBtn" class="btn_azure03">권한 저장</button>
		<button id="authCelBtn" class="btn_azure03">취소</button>
		<div id="authList" class="scroll"></div>	
	</div>	
</body>