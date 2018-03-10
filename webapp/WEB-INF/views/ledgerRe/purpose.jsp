<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/purpose.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/ajax/selectPurAndDtlList.do',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {	    	
	    	pur.init(data.purList).view();
	    	purDtl.init(data.purDtlList).view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//목적 추가
	$("#purAddBtn").click(function(){		
		pur.add().view();
	});
	
	//목적 취소
	$("#purCelBtn").click(function(){		
		pur.cancel().view();
	});
	
	
	
	//상세목적 추가
	$("#purDtlAddBtn").click(function(){		
		purDtl.add().view();
	});
	
	//상세목적 취소
	$("#purDtlCelBtn").click(function(){		
		purDtl.cancel().view();
	});
	
	$("#purSaveBtn").click(function(){
		let rtn = pur.check();
		if(rtn.check === true){
			pur.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	$("#purDtlSaveBtn").click(function(){
		let rtn = purDtl.check();
		if(rtn.check === true){
			purDtl.save();
		}else{
			alert(rtn.msg);
		}
	});
});

</script>
</head>
<body>
	
	<div>
		<span class='add'>■추가</span>
		<span class='edit'>■수정</span>
		<span class='redLine'>■삭제</span>
	</div>
	<br>
	
	<div class="left">
		<button id="purAddBtn" class="btn_azure03">추가</button>
		<button id="purSaveBtn" class="btn_azure03">목적 저장</button>
		<button id="purCelBtn" class="btn_azure03">취소</button>
		<div id="purList" class="scroll"></div>	
	</div>
	
	<div class="left">
		<button id="purDtlAddBtn" class="btn_azure03">추가</button>
		<button id="purDtlSaveBtn" class="btn_azure03">상세목적 저장</button>
		<button id="purDtlCelBtn" class="btn_azure03">취소</button>
		<div id="purDtlList" class="scroll"></div>
	</div>
</body>
