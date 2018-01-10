<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<script type="text/javascript" src="resources/js/ledger/ledgerSetupPurpose.js"></script>
<script type="text/javascript">		
	let purposeList = ${purposeList};
	let purposeDtlList = ${purposeDtlList};
</script>	
</head>
<body>
	ledgerSetupPurpose.jsp<br>	
	
	<article style="float: left;">
		<button id="purAdd">추가</button>	
		<button id="purCancel">취소</button>
		&nbsp;&nbsp;&nbsp;&nbsp;	
		<button id="purSave">목적 저장</button>
		
		<!-- 목적  -->
		<div id="purposeInfo">		
		</div>
	</article>
	
	<br>
	
	
	
	<!-- 세부목적  -->
	<article style="float: left; margin-left: 100px;">	
		<button id="purDtlAdd" style="display: none">추가</button>
		<button id="purDtlCancel" style="display: none">취소</button>
		&nbsp;&nbsp;&nbsp;&nbsp;	
		<button id="purDtlSave" style="display: none">상세목적 저장</button>	
		<div id="purposeDtlInfo">
		</div>		
	</article>	
	
</body>


