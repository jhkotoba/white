<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/ledgerRe/record.js?ver=0.015"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	if(window.innerWidth < common.platformSize+1){
		$("#dateBox").addClass("width-vmin");
		$("#searchBox").addClass("width-vmin");
	}
	
	$("#startDate").val(isDate.firstDay());
	$("#endDate").val(isDate.lastDay());
		
	//검색 목적리스트, 은행리스트
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ledgerRe/selectLedgerInitData.ajax',
		dataType: 'json',
	    success : function(data) {	    	
	    	
	    	let tag = "";
	    	for(let i=0; i<data.purList.length; i++){		
	    		tag += "<option value='"+data.purList[i].purSeq+"'>"+data.purList[i].purpose+"</option>";
	    	}
	    	$("#srhPur").append(tag);
	    	
	    	tag = "";
	    	for(let i=0; i<data.purDtlList.length; i++){		
	    		tag += "<option name='pSeq_"+data.purDtlList[i].purSeq+"' value='"+data.purDtlList[i].purDtlSeq+"' style='display:none;'>"+data.purDtlList[i].purDetail+"</option>";
	    	}
	    	$("#srhPurDtl").append(tag);
	    	
	    	tag = "";
	    	for(let i=0; i<data.bankList.length; i++){		
	    		tag += "<option value='"+data.bankList[i].bankSeq+"'>"+data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")</option>";
	    	}
	    	$("#srhBank").append(tag);
	    	
	    	rec.initPB(data.purList, data.purDtlList, data.bankList);			
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//조회 리스트
	$("#recShBtn").click(function(){				
		
		let param = {};
		param.startDate =  $("#startDate").val() + " 00:00:00";
		param.endDate = $("#endDate").val() + " 23:59:59";
		param.mode = "select";
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/selectRecordList.ajax',	
			data: param,
			dataType: 'json',
		    success : function(data) {	    	
		    	rec.initRec("select", data.recList).view();		    	
		    	$("#recEditBtn").show();
				$("#recSaveBtn").hide();
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
	
	//수정 및 삭제
	$("#recEditBtn").click(function(){
		rec.edit();
		$("#recSaveBtn").show();
	});
	
	//취소
	$("#recCelBtn").click(function(){
		rec.cancel().view();
		
		$("#recSaveBtn").hide();
		
		$("#srhPur").val("").prop("selected", true);
		$("#srhBank").val("").prop("selected", true);
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
	
	//목적 셀렉트 박스 선택시
	$("#srhPur").change(function(){		
		rec.search.purSeq = this.value;
		
		//상세목적 전체 hide
		$("#srhPurDtl option[name^=pSeq_]").hide();
		//목적 선택 seq에 해당하는 것만 show
		$("#srhPurDtl option[name=pSeq_"+this.value+"]").show();
		
	});
	
	//상세목적 셀렉트 박스 선택시
	$("#srhPurDtl").change(function(){		
		rec.search.purDtlSeq = this.value;
	});
	
	//은행 셀렉트 박스 선택시
	$("#srhBank").change(function(){
		rec.search.bankSeq = this.value;
	});
});

</script>

<div class="article">
	<h6>Date Search</h6>
	
	<div id="dateBox" class="left">
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text span-fs nsrb">날짜</span>
			</div>
			<input id="startDate" value="" type="text" class="datepicker-here form-control" data-language='ko'>
			<input id="endDate" value="" type="text" class="datepicker-here form-control" data-language='ko'>			
		</div>
	</div>

	<div id="searchBox" class="left">
		<div class="input-group">
						
			<div class="input-group-prepend">
				<span class="input-group-text span-fs nsrb">조건</span>
			</div>			
		
			<select id="srhPur" class="custom-select slt-fs">
				<option value=''>목적 검색</option>	
				<option value='0'>금액이동</option>
			</select>
			<select id="srhPurDtl" class="custom-select slt-fs">
				<option value=''>상세 검색</option>
			</select>
			<select id="srhBank" class="custom-select slt-fs">
				<option value=''>은행 검색</option>			
				<option value='0'>현금</option>	
			</select>			
		</div>			      
	</div>
	<div class="left">
		<div class="btn-group" role="group">
			<button id="recShBtn" type="button" class="btn btn-secondary btn-fs nsrb">조회</button>
			<button id="recEditBtn" type="button" style="display:none;" class="btn btn-secondary btn-fs nsrb">편집</button>
			<button id="recSaveBtn" type="button" style="display:none;" class="btn btn-secondary btn-fs nsrb">저장</button>
			<button id="recCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">초기화</button>
		</div>
	</div>
	
	<div id="ledgerReList">		
	</div>
</div>