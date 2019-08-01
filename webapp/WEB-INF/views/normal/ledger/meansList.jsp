<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
</script>
<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="saveBtn" class="btn-gray trs">저장</button>
		<button id="cancelBtn" class="btn-gray trs">취소</button>
	</div>
</div>

<div>
	<div>
		<div class="title-icon"></div>
		<label class="title">사용수단 목록</label>
	</div>
	<div id="meansGrid"></div>
</div>