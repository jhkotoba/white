<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/setupBank.js?ver=0.013"></script>
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
<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">은행설정</h1>
	</div>
	
	<div class="btn-group" role="group">	
		<button id="bankAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
		<button id="bankSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">저장</button>
		<button id="bankCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
	</div>
	
	<div id="bankList" class="width-vmin"></div>

</div>

