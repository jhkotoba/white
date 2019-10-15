<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>signUp</title>

<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/common.js"></script>	
<script type="text/javascript">
$(document).ready(function(){
	
	//userIdState
	$("#userId").keyup(function(e){
		
		//한글막기
		if (!(e.keyCode >=37 && e.keyCode<=40)) {
			var v = $(this).val();
			$(this).val(v.replace(/[^a-z0-9]/gi,''));		
		}
		
		$("#userIdCheck").val("N");
		$("#checkState").text("");
	});
	
	//passwdCheck
	$("#passwd").keyup(function(){
		$("#passwdCheck").val("N");
		$("#passwdState").text("");
		$("#rePasswd").val("");
	});
	$("#rePasswd").keyup(function(){
		var passwd = $("#passwd").val();
		var rePasswd = $("#rePasswd").val();
		if(passwd === rePasswd){
			$("#passwdCheck").val("Y");
			$("#passwdState").text("일치");
		}else{
			$("#passwdCheck").val("N");
			$("#passwdState").text("불일치");
		}
	});
	
	//submit
	$("#submitBtn").click(function(){
		if($("#userIdCheck").val()==="N"){
			alert("유저ID 체크필요 합니다.");
			return;
		}else if($("#passwdCheck").val()==="N"){
			alert("비밀번호가 동일하지 않습니다.");
			return;
		}else{
			//submit 로직			
			$("#signUpForm").attr("method", "post");
			$("#signUpForm").attr("action", "${contextPath}/login/insertSignUp.do").submit();
		}
	});	
});

//유저 중복체크
function userIdCheck(){
	
	var userId = $("#userId").val().replace(/\s/gi, "");
	if(userId === ""){
		alert("ID를 입력하세요.");
		return;
	}
	$("#userId").val(userId);
		
	$.ajax({		
		type: 'POST',
		url: common.path()+'/login/userIdCheck.ajax',
		data: {
			userId : userId
		},
		dataType: 'json',
	    success : function(data, stat, xhr) {	
	    	if(data > 0){
	    		$("#userIdCheck").val("N");
	    		$("#checkState").text("존재하는 아이디 입니다.");
	    	}else{
	    		$("#userIdCheck").val("Y");
	    		$("#checkState").text("사용가능한 아이디 입니다.");
	    	}
	    },
	    error : function(xhr, stat, err) {
	    	console.log(xhr);
	    	console.log(stat);
	    	console.log(err);
	    }
	});
}
</script>
</head>
<body>

<input id="userIdCheck" type="hidden" value="N">
<input id="passwdCheck" type="hidden" value="N"> 
<a href="${contextPath}/login/login.do">login</a>

<form id="signUpForm">
	<table>
		<thead>		
		</thead>
		<tbody>
			<tr>
				<td>Id</td>
				<td>
					<input id="userId" type="text" name="userId">
					<button onclick="userIdCheck(); return false;">check</button>
					<span id="checkState"></span>
				</td>
			</tr>
			<tr>
				<td>Name</td>
				<td>
					<input id="userNm" type="text" name="userNm">
				</td>
			</tr>
			<tr>
				<td>Passwd</td>
				<td>
					<input id="passwd" type="password" name="passwd">
					<span id="passwdState"></span>
				</td>
			</tr>
			<tr>
				<td>RePasswd</td>
				<td>
					<input id="rePasswd" type="password" name="rePasswd">
				</td>
			</tr>			
		</tbody>
		<tfoot>
			<tr>
				<td>
					<button id="submitBtn" onclick="return false;">submit</button>
				</td>
			</tr>
		</tfoot>	
	</table>	
</form>
</body>
</html>