<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>LoginPage</title>
</head>
<body>

<form method="post" action="/white/loginProcess.do">
	<table>
		<thead>		
		</thead>
		<tbody>
			<tr>
				<td>Id</td>
				<td>
					<input type="text" name="userId">
				</td>
			</tr>
			<tr>
				<td>Passwd</td>
				<td>
					<input type="password" name="passwd">
				</td>
			</tr>			
		</tbody>
		<tfoot>
			<tr>
				<td>
					<input type="submit" value="submit">
				</td>
			</tr>
		</tfoot>	
	</table>
</form>

<form method="post" action="/white/signUpPage.do">
	<button id="signUp">SignUp</button>
</form>

</body>
</html>