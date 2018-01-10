<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<script type="text/javascript" src="resources/js/ledger/ledgerSetupBank.js"></script>
<script type="text/javascript">		
	let bankList = ${bankList};
	//console.log(bankList);
</script>
</head>
<body>
	ledgerSetupBank.jsp<br>
	
	<button id="bankAdd">추가</button>	
	<button id="bankCancel">취소</button>
	&nbsp;&nbsp;&nbsp;&nbsp;	
	<button id="bankSave">저장</button>
	
	<article id="bankInfo">		
	</article>	
	
</body>


