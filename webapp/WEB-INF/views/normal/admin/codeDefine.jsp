<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	wcm.createCode("srhTp","LP");
});
</script>

<!-- 버튼 -->
<div class="button-bar">
	<div id="btns" class="btn-right">
		<button class="btn-gray trs" id="addBtn">추가</button>
	</div>
</div>

<form id="srhForm" name="srhForm" onsubmit="return false;">
	<div>
		<div class="title-icon"></div>
		<label class="title">코드 정의</label>
	</div>
	<div class="search-bar">
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
					<select id="srhTp" name="schTp" class="select-gray wth100p">
					</select>
				</td>
				<th>검색명</th>
				<td>
					<input id="srhTxt" name="schTxt" type="text" class="input-gray wth3 wth100p">
				</td>
			</tr>
		</table>
	</div>
</form>

<div id="codeList">
</div>
