<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>
</head>
<body>

<form method="post" action="${contextPath}/login/loginProcess.do">
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

<form method="post" action="${contextPath}/login/signUp.do">
	<button id="signUp">SignUp</button>
</form>

</body>
</html>