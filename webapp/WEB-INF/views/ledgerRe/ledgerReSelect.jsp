<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/ledgerReRecord.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	//메인조회 리스트
	recListView();
	
	//수정 및 삭제
	$("#recEditBtn").click(function(){
		rec.edit();
	});
	
	//취소
	$("#recCelBtn").click(function(){
		rec.cancel();
		$("#recEditBtns > button")
			.prop("disabled",true)
			.attr("class", "btn_disabled03");
    	
	});
	
	$("#recSaveBtn").click(function(){
		let rtn = rec.check();
		if(rtn.check === true){
			rec.update();
		}else{
			alert(rtn.msg);
		}
	});	
});

//메인조회 리스트
function recListView(){
	
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay())	

	$("#recShBtn").click(function(){	
		
		let param = {};
		param.startDate =  $("#startDate").val() + " 00:00:00";
		param.endDate = $("#endDate").val() + " 23:59:59";
		param.mode = "select";
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/ajax/selectRecordList.do',	
			data: param,
			dataType: 'json',
		    success : function(data) {	    	
		    	rec.init("select", data.recList, '${purList}', '${purDtlList}', '${bankList}').view();
		    	$("#recEditBtns > button")
		    		.prop("disabled",false)
		    		.attr("class", "btn_azure03");		    	
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
}


</script>
</head>
<body>
	
	<h4>금전기록 기간조회</h4>
	<div>
		<input id="startDate" type="date" value="">
		<input id="endDate" type="date" value="">
		<button id="recShBtn" class="btn_azure03">조회</button>
		<span id="recEditBtns">
			<button id="recEditBtn" class="btn_disabled03" disabled="disabled">편집</button>
			<button id="recSaveBtn" class="btn_disabled03" disabled="disabled">저장</button>
			<button id="recCelBtn" class="btn_disabled03" disabled="disabled">취소</button>
		</span>
	</div>
	
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
