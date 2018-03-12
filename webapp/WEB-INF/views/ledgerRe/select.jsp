<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/record.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	let purList = JSON.parse('${purList}');
	let purDtlList = JSON.parse('${purDtlList}');
	let bankList = JSON.parse('${bankList}');
	
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay());
	
	//메인조회 리스트
	$("#recShBtn").click(function(){
		
		$("#srhBox").hide();		
		
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
		    	rec.init("select", data.recList, purList, purDtlList, bankList).view();
		    	$("#recEditBtn").prop("disabled",false)
		    		.attr("class", "btn_azure03");
		    	
		    	$("#recSaveBtn").prop("disabled",true)
				.attr("class", "btn_disabled03");	
				$("#recCelBtn").prop("disabled",true)
				.attr("class", "btn_disabled03");
				
				$("#srhPur").val("").prop("selected", true);
				$("#srhBank").val("").prop("selected", true);
				
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
	
	//수정 및 삭제
	$("#recEditBtn").click(function(){
		rec.edit();
		
		$("#recSaveBtn").prop("disabled",false)
			.attr("class", "btn_azure03");	
		$("#recCelBtn").prop("disabled",false)
			.attr("class", "btn_azure03");
		
		$("#srhBox").show();
	});
	
	//취소
	$("#recCelBtn").click(function(){
		rec.cancel().view();
				
		$("#recSaveBtn").prop("disabled", true)
			.attr("class", "btn_disabled03");    	
		$("#recCelBtn").prop("disabled", true)
			.attr("class", "btn_disabled03");		
		
		$("#srhPur").val("").prop("selected", true);
		$("#srhBank").val("").prop("selected", true);
		
		$("#srhBox").hide();
	});
	
	//저장
	$("#recSaveBtn").click(function(){
		let rtn = rec.check();
		if(rtn.check === true){
			rec.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	//검색 목적리스트, 은행리스트	
	let tag = "";
	for(let i=0; i<purList.length; i++){		
		tag += "<option value='"+purList[i].purSeq+"'>"+purList[i].purpose+"</option>";
	}
	$("#srhPur").append(tag);	
	
	tag = "";
	for(let i=0; i<bankList.length; i++){		
		tag += "<option value='"+bankList[i].bankSeq+"'>"+bankList[i].bankName+"("+bankList[i].bankAccount+")</option>";
	}
	$("#srhBank").append(tag);	
	
	//검색 텍스트  purSeq sync
	$("#srhPur").change(function(){
		rec.search.purSeq = this.value;
	});	
	//검색 텍스트  bankSeq sync
	$("#srhBank").change(function(){
		rec.search.bankSeq = this.value;
	});
	
	//검색 텍스트  초기화
	$("#reset").click(function(){
		rec.searchReset().cancel().edit();
		$("#srhPur").val("").prop("selected", true);
		$("#srhBank").val("").prop("selected", true);
	});
	
	//검맥
	$("#srhBtn").click(function(){	
		rec.cancel("search").edit();		
	});
	
});

</script>
</head>
<body>
	
	<h4>금전기록 기간조회</h4>
	
	<div>
		<input id="startDate" type="date" value="">
		<input id="endDate" type="date" value="">
		<button id="recShBtn" class="btn_azure03">조회</button>		
		<button id="recEditBtn" class="btn_disabled03" disabled="disabled">편집</button>
		<button id="recSaveBtn" class="btn_disabled03" disabled="disabled">저장</button>
		<button id="recCelBtn" class="btn_disabled03" disabled="disabled">취소</button>		
	</div>
	
	<div id="srhBox" style="display: none">		
		<select id="srhPur">
			<option value=''>목적 검색</option>			
		</select>
		<select id="srhBank">
			<option value=''>은행 검색</option>			
			<option value='0'>현금</option>			
		</select>
		<button id="srhBtn" class="btn_azure03">검색</button>
		<button id="reset" class="btn_azure03">초기화</button>
	</div>
	
	<div id="ledgerReList">		
	</div>
	<br>	
	
</body>
</html>
