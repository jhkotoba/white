<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	
});
</script>

<!-- 버튼 -->
<div class="button-bar">
	<div id="btns" class="btn-right">
		<button class="btn-gray trs" id="srhBtn">조회</button>
		<button class="btn-gray trs" id="witBtn">글쓰기</button>
	</div>
</div>

<form id="srhForm" name="srhForm" onsubmit="return false;">
	<div>
		<div class="title-icon"></div>
		<label class="title">용어 정의</label>
	</div>
	<div id="srhBar" class="search-bar">
		<table>
			<colgroup>
				<col width="130px" class="search-th"/>
				<col width="100px">
				<col width="130px" class="search-th"/>
				<col width="250px"/>
			</colgroup>
			<tr>
				<th>검색구분</th>
				<td>
					<select id="schTp" class="select-gray wth100p" >						
						<option value="A">단어</option>
						<option value="B">약어</option>
					</select>
				</td>
				<th>검색명</th>
				<td>
					<input class="input-gray wth3 wth100p" id="schTxt" type="text">
				</td>
			</tr>
		</table>
	</div>
</form>
