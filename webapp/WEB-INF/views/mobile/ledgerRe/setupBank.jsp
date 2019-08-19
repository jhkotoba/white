<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/setupMeans.js?ver=0.013"></script>
<script type="text/javascript">
$(document).ready(function(){	
	
	$.ajax({
		type: 'POST',
		url: common.path()+'/ledgerRe/selectMeansList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {
	    	means.init(data).view();
	    },
	    error : function(request, status, error){
	    	alert("means error");
	    }
	});
	
	//은행 추가
	$("#meansAddBtn").click(function(){
		means.add().view();
	});
	
	//은행 취소
	$("#meansCelBtn").click(function(){
		means.cancel().view();
	});
	
	$("#meansSaveBtn").click(function(){
		let rtn = means.check();
		if(rtn.check === true){
			means.save();
		}else{
			alert(rtn.msg);
		}
	});
});

</script>
<div class="space left"></div>

<div class="btn-group" role="group">	
	<button id="meansAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
	<button id="meansSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">저장</button>
	<button id="meansCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
</div>

<div id="meansList" class="width-vmin"></div>