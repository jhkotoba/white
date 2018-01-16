<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<script type="text/javascript" src="resources/js/ledger/ledgerMain.js"></script>	
<script type="text/javascript" src="resources/js/ledger/selectRecode.js"></script>	
<script type="text/javascript">

selectRecode.userSeq = '${sessionScope.userSeq}';
	
$(document).ready(function(){
	selectRecode.latestSelect();
	
	
$("#memoAddBt").click(function(){	
	ledgerMemo.list.push({bankAccount: "", userBankSeq: 0, bankNowUseYN: "Y",bankName: "", });
	ledgerMemo.view();
});	
	
	
	
	
	
	
	
});	
	
	
	
	
	
	
	
</script>

 
	
	
</head>
<body>
	ledgerMain.jsp<br>
	<button id="memoAddBt">메모 추가</button>
	<div id="ledgerMemo">
		<table id='ledgerMemoTb' border=1>
		</table>
	</div>
	<!-- 핸드폰요금 매월 23일<br>
	우체국보험 매월 25일<br>
	교보보험 매월 31일<br>
	
	2017년10월, 2017년11월만 데이터 정상등록됨  <br>
	
	2014년 데이터부터 넣어야함
	<br>	

	3.2014 데이터 입력할 엑셀 업로드 완성시키기 <br>
	5.코드 정리(최적화)<br>
	6.javascript -> java 소스로직 옮기기 <br> -->
	
	
	
	<article id="ledgerSearch">
		<h3>최근 사용내역</h3>
		<h6 id="latestCnt"></h6>
		<h6 id="DetailDate"></h6>		
	</article>
		
	<article id="ledgerInfo">
	</article>
</body>


