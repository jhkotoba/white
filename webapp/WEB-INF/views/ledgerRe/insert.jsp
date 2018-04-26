<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/insert.js?ver=0.002"></script>
<script type="text/javascript">
$(document).ready(function(){6	

	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectPurBankList.ajax',
		dataType: 'json',
	    success : function(data) {
	    	recIn.init(data.purList, data.purDtlList, data.bankList).add().view();    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	$("#recAddBtn").click(function(){		
		recIn.add().view();
	});
	
	$("#recDelBtn").click(function(){		
		recIn.del().view();
	});
	
	$("#recInsertBtn").click(function(){
		let rtn = recIn.check();
		if(rtn.check === true){
			recIn.insert();
		}else{
			alert(rtn.msg);
		}
	});
});


</script>
<div class="article">
	<h6 class="nsrb">Money registration</h6>
	<div id="recIn" class="btn-group" role="group">	
		<button id="recAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
		<button id="recDelBtn" type="button" class="btn btn-secondary btn-fs nsrb">삭제</button>
		<button id="recInsertBtn" type="button" class="btn btn-secondary btn-fs nsrb">저장</button>
	</div>
	
	<div class="space left"></div>
	
	<div id="ledgerReList">		
	</div>
</div>