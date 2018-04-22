<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>


<style>
.calendar{position:absolute; height: 200px; width:200px; border: 1px solid #dee2e6; background: white;}


</style>


<script type="text/javascript">
$(document).ready(function(){
	let cal1 = whiteCalendar("searchDate1", "2011-11-22");
	let cal2 = whiteCalendar("searchDate2", "3333-11-22");
	let cal3 = whiteCalendar("searchDate3", "4444-11-22");
	let cal4 = whiteCalendar("searchDate4", "5555-11-22");	
});


</script>


<div class="article">
	<div id="searchDate1">	
	</div>
	<br><br>
	
	<div id="searchDate2">	
	</div>
	<br><br>
	
	<table border="1">
		<tr>
			<th>Test</th>
		</tr>
		<tr>
			<td>
				<div id="searchDate3">	
			</td>
		</tr>
	</table>
	<br><br>
	
	<div id="searchDate4">	
	<br><br>
</div>

<div name="calendar"></div>

