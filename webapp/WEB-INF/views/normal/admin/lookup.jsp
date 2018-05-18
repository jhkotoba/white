<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/admin/lookup.js?ver=0.006"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#srhBtn").on("click", function(){
		
		$("#userView").hide();		
		look.select();
	});
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/admin/selectAuthList.ajax',
		dataType: 'json',
		async : false,
	    success : function(data) {
	    	
			$("#authList").empty();
			
			let tag = "";
			for(let i=0; i<data.length; i++){				
				tag += "<div class='form-check form-check-inline'>";
				tag += "<input type='checkbox' name='authChk' id='auth_"+data[i].authNmSeq+"'' class='form-check-input' value='none'>";
				tag += "<label class='form-check-label' for='auth_"+data[i].authNmSeq+"'>"+data[i].authNm+"</label>";
				tag += "</div>";				
			}			
			$("#authList").append(tag);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	$("input:checkbox[name='authChk']").on("change input", function(event){
		
		let name = event.target.value.split('_')[0];
		let seq = event.target.value.split('_')[1];
		
        if($(event.target).prop("checked")){			
        	
			switch(name){
			case "delete" :
				event.target.value =  "select_"+seq;
				break;
			case "none" :
				event.target.value =  "insert";
				break;
			}		
		}else{
			switch(name){
			case "select" : 
				event.target.value =  "delete_"+seq;
				break;
			case "insert" : 
				event.target.value =  "none";
				break;
			}			
		}
	});
	
	$("#authClose").on("click button", function(){
		$("#userView").hide();
		$("#userNum").text("");
		$("#userNo").val("");
		$("#userId").text("");
		$("#userNm").text("");
		$("input:checkbox[id^='auth_']").prop("checked", false).val('none');
		
	});
	
	$("#authSave").on("click button", function(event){
		let userNo = $("#userNo").val();		
		let inList = new Array();
		let delList = new Array();		
		
		let name = "";
		let seq = "";
		$('input:checkbox[name="authChk"]').each(function() {						
			name = this.value.split('_')[0];
			seq = this.value.split('_')[1];			
			if(name === "insert"){
				inList.push({userNo : userNo, authNmSeq : this.id.split('_')[1]})
			}else if(name === "delete"){
				delList.push({authSeq : seq, authNmSeq : this.id.split('_')[1]})
			}
		});
		if(emptyCheck.isEmpty(userNo)){
			alert("userNo Empty");
			return;
		}else if(inList.length <= 0 && delList.length <= 0){
			alert("추가하거나 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("수정한 내용을 저장하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/inDelAuthList.ajax',
			data: {
				inList : JSON.stringify(inList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
			success : function(data, stat, xhr) {				
				let msg = "";
		    	if(data.inCnt > 0){
		    		msg += data.inCnt+" 개의 권한이 추가";
		    	}
		    	
		    	if(data.inCnt > 0 && data.delCnt > 0){
		    		msg += ", ";
		    	}
		    	
		    	if(data.delCnt > 0){
		    		msg += data.delCnt+ "개의 권한이 삭제";
		    	}
		    	msg += " 되었습니다.";
		    	alert(msg);
		    	$('#authClose').trigger('click');
			},
			error : function(xhr, stat, err) {
				alert("error");
			}
		});
	});
});
</script>

<input id="pageNum" type="hidden" value="1">

<div class="article">
	
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">사용자 조회</h1>
	</div>

	<div id="userSearch">		
		<div class="left">	
			<div class="input-group">
				<div class="input-group-prepend">
					<span class="input-group-text">조건</span>
				</div>
				<select id="srhSlt" class="custom-select">
					<option value="all">전체</option>
					<option value="id">아이디</option>
					<option value="nm">이름</option>
				</select>			
			</div>
		</div>
		
		<div class="left">
			<div class="input-group">
				<div class="input-group-prepend">
					<span class="input-group-text">개수</span>
				</div>			
				<select id="pageCnt" class="custom-select">
					<option value="5">5개</option>
					<option value="10" selected="selected">10개</option>
					<option value="20">20개</option>
					<option value="50">50개</option>
					<option value="100">100개</option>
				</select>
			</div>
		</div>
			
		<div class="left">
			<div class="input-group">
				<div class="input-group-prepend">
					<span class="input-group-text">내용</span>
				</div>
				<input id="srhMsg" class="form-control" type="text">
			</div>
		</div>
		
		<div class="left">
			<button id="srhBtn" class="btn btn-secondary">조회</button>
		</div>	
	</div>

	<div id="userView" class="width-vmin" style="display: none;">
		<input id="userNo" type="hidden" value="">
		<div class="space left" style="height: 10px;"></div>
		<h6 class="space left">사용자 상세정보</h6>
		<table class='table table-striped table-sm table-bordered'>		
			<tr>
				<th style="width: 5%">번호</th>
				<th>아이디</th>
				<th>이름</th>
			</tr>
			<tr>
				<td><span id="userNum"></span></td>
				<td><span id="userId"></span></td>
				<td><span id="userNm"></span></td>
			</tr>			
		</table>
		<div>
			<span class="width-full div-head">권한설정</span>
			<div id="authList" class="default-border">
			</div>
		</div>	
		
		<div class="updown-spacing">
			<button id="authClose" type="button" class="btn btn-secondary">Close</button>
			<button id="authSave" type="button" class="btn btn-secondary">Save changes</button>
		</div>
	</div>
	
	<div class="width-vmin">
		<div id="userList">	
		</div>
		
		<div id="paging" style="margin-left: 45%;">
		</div>
	</div>
	
	
</div>