<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/bank.js"></script>
<script type="text/javascript">
$(document).ready(function(){	
	
	$.ajax({
		type: 'POST',
		url: common.path()+'/ledgerRe/selectBankList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {
	    	bank.init(data.bankList).view();
	    },
	    error : function(request, status, error){
	    	alert("bank error");
	    }
	});
	
	//은행 추가
	$("#bankAddBtn").click(function(){
		bank.add().view();
	});
	
	//은행 취소
	$("#bankCelBtn").click(function(){
		bank.cancel().view();
	});
	
	$("#bankSaveBtn").click(function(){
		let rtn = bank.check();
		if(rtn.check === true){
			bank.save();
		}else{
			alert(rtn.msg);
		}
	});
});

</script>	
<div>
	<span class='add'>■추가</span>
	<span class='edit'>■수정</span>
	<span class='redLine'>■삭제</span>
</div>
<br>

<div class="left">
	<button id="bankAddBtn" class="btn_azure03">추가</button>
	<button id="bankSaveBtn" class="btn_azure03">저장</button>
	<button id="bankCelBtn" class="btn_azure03">취소</button>
	<div id="bankList" class="scroll"></div>
</div>