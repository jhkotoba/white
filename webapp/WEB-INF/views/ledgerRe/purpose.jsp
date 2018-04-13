<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/purpose.js?ver=0.008"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	if(window.innerWidth > 500){
		$("#purWidth").addClass("left");
		$("#purDtlWidth").addClass("left");
	}	
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectPurAndDtlList.ajax',
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

<div class="article">	
	<div id="purWidth" class="width-vmin">
		<h6 class="nsrb">Purpose</h6>
		<div class="btn-group" role="group">	
			<button id="purAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="purSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">목적 저장</button>
			<button id="purCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="purList"></div>	
	</div>	
	
	<div id="purDtlWidth" class="width-vmin">
		<h6 class="nsrb">Detail Purpose</h6>
		<div class="btn-group" role="group">	
			<button id="purDtlAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="purDtlSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">상세목적 저장</button>
			<button id="purDtlCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="purDtlList"></div>
	</div>
</div>