<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>

<style type="text/css">
.cancleLine{
	text-decoration-line: line-through;
}
</style>

<script type="text/javascript" src="resources/js/ledger/ledgerMain.js"></script>	
<script type="text/javascript" src="resources/js/ledger/selectRecode.js"></script>	
<script type="text/javascript">

selectRecode.userSeq = '${sessionScope.userSeq}';
var memoList = ${memoList};
var memoType = "ledger";


$(document).ready(function(){
	selectRecode.latestSelect();
	
	ledgerMemo.list = common.clone(memoList);
	ledgerMemo.view();
	
	//새로운 메모 추가
	$("#memoAddBt").click(function(){	
		ledgerMemo.list.push({memoType: memoType, memoContent: "", state: "insert"});
		ledgerMemo.view();
	});
	
	//취소
	$("#memoCancelBt").click(function(){
		ledgerMemo.list = common.clone(memoList);	
		ledgerMemo.view();
	});
	
	//메모 저장
	$("#memoSaveBt").click(function(){	
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ajax/memoSave.do',
			data: {
				jsonStr : JSON.stringify(ledgerMemo.list),
				memoType : memoType
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {  
		    	console.log(data);
		    },
		    error : function(xhr, stat, err) {			    	
		    	alert("setup error");
		    }
		});
	});
	
});

//메모 삭제
function memoDel(idx){	
	
	//새로운 메모 삭제
	switch(ledgerMemo.list[idx].state){
	
	case "insert" :
		ledgerMemo.list.splice(idx,1);		
		break;
	case "update" :		
	case "select" :
		ledgerMemo.list[idx].state = "delete";
		break;
	}	
	ledgerMemo.view();
}

//메모수정
function memoEdit(idx){	
	ledgerMemo.list[idx].memoContent = $("#memoContent_"+idx).val();
	if(ledgerMemo.list[idx].state === "select"){
		ledgerMemo.list[idx].state = "update";	
	}
	
}
	
	
</script>


	
	
</head>
<body>
	ledgerMain.jsp<br>
	<button id="memoAddBt">메모 추가</button>
	<button id="memoSaveBt">메모 저장</button>
	<button id="memoCancelBt">취소</button>
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


