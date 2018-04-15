<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/admin/auth.js?ver=0.001"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/admin/selectAuthList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {	
	    	auth.init(data).view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//헤더메뉴 추가
	$("#authAddBtn").click(function(){		
		auth.add().view();
	});
	
	//취소
	$("#authCelBtn").click(function(){		
		auth.cancel().view();
	});
	
	//권한 저장, 수정, 삭제
	$("#authSaveBtn").click(function(){
		let rtn = auth.check();
		if(rtn.check === true){
			auth.save();
		}else{
			alert(rtn.msg);
		}
	});	
});

</script>
<div class="article">
	<h6 class="nsrb">Auth List</h6>
	<div class="width-vmin">
		<div class="btn-group" role="group">	
			<button id="authAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="authSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">권한 저장</button>
			<button id="authCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="authList"></div>
	</div>
<div class="article">