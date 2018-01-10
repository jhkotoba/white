<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset=UTF-8>
	<title>signUp</title>
	<script type="text/javascript" src="resources/js/wcommon/jquery/jquery-3.2.0.js"></script>
	<script type="text/javascript" src="resources/js/wcommon/common.js"></script>
	<script type="text/javascript" src="resources/js/login/signUpPage.js"></script>
</head>
<body>
signUpPage.jsp

<input id="userIdCheck" type="hidden" value="N">
<input id="passwdCheck" type="hidden" value="N"> 
<a href="/white/loginPage.do">loginPage</a>

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
					<input id="userName" type="text" name="userName">
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