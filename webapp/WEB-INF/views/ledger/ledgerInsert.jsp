<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>

<head>
	<meta charset=UTF-8>
	<title>Insert title here</title>
	<script type="text/javascript" src="resources/js/ledger/ledgerInsert.js"></script>	
	<script type="text/javascript">		
		ledgerInsert.purposeList = ${purposeList};
		ledgerInsert.purposeDtlList = ${purposeDtlList};
		ledgerInsert.userBankList = ${userBankList};
	</script>	
</head>
<body>
	ledgerInsert.jsp<br>
	<article id="ledgerInsertTeb">
	
		<button onclick="excelStyleDown()">엑셀양식</button>
		<form id="excelStyle" action=""></form>
	
		<button onclick="excelUpload()">엑셀 업로드</button>	
		<form id="excelUpload" method="post" enctype="multipart/form-data">			
			<input type="file" id="dataFile" name="dataFile"/>
		</form>	
	
		<button onclick="ledgerInsert.add()">추가</button>
		<button onclick="ledgerInsert.del()">삭제</button>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<button onclick="ledgerInsert.insert()">저장</button>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
		
		<form id="ledgerInsertForm" action="">
			
			<div>
				<span style="border: 1px solid black;">no</span>
				<span style="border: 1px solid black;">date</span>
				<span style="border: 1px solid black;">time</span>
				<span style="border: 1px solid black;">content</span>
				<span style="border: 1px solid black;">purpose</span>
				<span style="border: 1px solid black;">purposeDtl</span>
				<span style="border: 1px solid black;">bankNm, acc</span>
				<span style="border: 1px solid black;">inExpMoney</span>
			</div>
			<div id="ledgerInsert_0">
				<span style="border: 1px solid black;">1</span>
				<input id="date_0" name="date_0" type="date" value="">
				<input id="time_0" name="time_0" type="time" value="">
				<input id="content_0" name="content_0" type="text">
				<select id="purpose_0" name="purpose_0" onchange="purposeChanged(this, 0)"></select>
				<select id="purposeDtl_0" name="purposeDtl_0"></select>
				<select id="bankName_0" name="bankName_0"></select>
				<!-- <select id="moveFrom_0" name="moveFrom_0" style="display: none;"></select> -->
				<select id="moveTo_0" name="moveTo_0" style="display: none;"></select>
				<input id="inExpMoney_0" name="inExpMoney_0" type="text">
			</div>
			
		</form>		
	</article>
	
</body>


