<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC>

<head>
<meta charset=UTF-8>
<title>Insert title here</title>
<script type="text/javascript" src="resources/js/ledger/ledgerSelect.js"></script>
<script type="text/javascript" src="resources/js/ledger/selectRecode.js"></script>	
<script type="text/javascript">		
	selectRecode.userSeq = ${sessionScope.userSeq};		
	ledgerSelect.purposeList = ${purposeList};
	ledgerSelect.purposeDtlList = ${purposeDtlList};
	ledgerSelect.bankList = ${userBankList};
	

	$(document).ready(function(){
		
		$("#startDate").val(isDate.firstDay());
		$("#endDate").val(isDate.lastDay());
		
		$("#editBtn").prop("disabled",true);
		$("#editBtn").attr("class", "btn_disabled03");
		$("#delBtn").prop("disabled",true);	
		$("#delBtn").attr("class", "btn_disabled03");	
		
		$("#purSelect").append("<option value='' selected='selected'>목적선택</option>");
		$("#purSelect").append("<option value='0'>현금이동</option>");
		for(let i=0; i<ledgerSelect.purposeList.length; i++){
			$("#purSelect").append("<option value='"+ ledgerSelect.purposeList[i]["purposeSeq"] +"'>"+ledgerSelect.purposeList[i]["purpose"]+"</option>");		
		}

	});
		
</script>
</head>
<body>
	ledgerSelect.jsp<br>
	
	<article id="ledgerSearch">
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn('today')">오늘</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(0)">1개월</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(-1)">2개월</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(-2)">3개월</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(-5)">6개월</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(-8)">9개월</button>
		<button class="btn_azure03" onclick="ledgerSelect.searchDateBtn(-11)">12개월</button>
		<br>
		
		
		
		<input id="startDate" type="date" value="">
		<input id="endDate" type="date" value="">	

		
		<button id="searchBtn" class="btn_azure03" onclick="ledgerSelect.recodeSearch();">조회</button>
		&nbsp;&nbsp;&nbsp;&nbsp;		
		
		<select id="purSelect">			
		</select>			
		
		<button id="editBtn" class="btn_disabled03" onclick="ledgerSelect.editDel('update')">수정</button>
		<button id="delBtn" class="btn_disabled03" onclick="ledgerSelect.editDel('delete')">삭제</button>		
	</article>
		
	<article id="ledgerInfo">		
	</article>	
	
</body>


