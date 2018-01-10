<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC>

<!-- 사용안함  -->
<head>
	<meta charset=UTF-8>
	<title>Insert title here</title>
	<script type="text/javascript" src="resources/js/ledger/ledgerData.js"></script>
</head>
<body>
	ledgerData.jsp<br>
	
	<form id="fileDownload" method="post">
		<input type="hidden" id="fileType" name="fileType" value=""/>
	</form>
	<button onclick="file.backup()">데이터 백업 다운로드</button><br>
	
 	<form id="fileUpload" method="post" enctype="multipart/form-data">
		<input type="file" id="dataFile" name="dataFile"/>
		<input type="hidden" id="fileType" name="fileType" value=""/>
	</form>
	다운로드 백업파일을 업로드하여 기존데이터 삭제후 백업 데이터로 초기화 <br>
	<button onclick="file.init()">데이터 초기화</button><br>
</body>


