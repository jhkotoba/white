<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/bootstrap-4.1.1/css/bootstrap.min.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/bootstrap-4.1.1/js/bootstrap.bundle.min.js"></script>
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
	
	
	
	$('#paging').on("click button", function(event) {
		
		if(!common.isOnlyNum(event.target.value)) return;
		
		$("#pageNum").val(event.target.value);
		look.select();	
	});
	
	$("#pageCnt").on("change select", function(event){
		$("#pageNum").val("1");
	});
	
	$('#userList').on("click button", function(event) {	
		let name = event.target.id.split('_')[0];
		let idx = event.target.id.split('_')[1];
		
		switch(name){
		
		case "viewBtn" :			
			
			$("#userNum").text(look.userList[idx].userSeq);
			$("#userNo").val(look.userList[idx].userSeq);
			$("#userId").text(look.userList[idx].userId);
			$("#userNm").text(look.userList[idx].userName);		
			
			$.ajax({		
				type: 'POST',
				url: common.path()+'/admin/selectUserAuth.ajax',
				data: {
					userNo : Number(event.target.value)
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {		    	
			    	
			    	$("#userView").show();			    	
			    
			    	$("input:checkbox[id^='auth_']").prop("checked", false).val('none');			    	
			    	for(let i=0; i<data.length; i++){
			    		$("#auth_"+data[i].authNmSeq).prop("checked", true).val("select_"+data[i].authSeq);
			    	}
			    },
			    error : function(xhr, stat, err) {
			    	alert("error");
			    }
			});			
		break;
		}
	});
});

let look = {
		count : 0,
		pageNum : 1,
		pageCnt : 10,
		blockCnt : 10,
		userList : new Array(),
		
		init : function(pageCnt, pageNum, count, userList){
			this.pageCnt = Number(pageCnt);
			this.pageNum = Number(pageNum);		
			this.count = Number(count);
			this.userList = userList;
			return this;
		},
		
		select : function(){
			
			let param = {};
			param.srhSlt = $("#srhSlt").val();
			param.srhMsg = $("#srhMsg").val();	
			param.pageNum = $("#pageNum").val();
			param.pageCnt = $("#pageCnt").val();
			this.pageNum = $("#pageNum").val();
			
			$.ajax({		
				type: 'POST',
				url: common.path()+'/admin/selectUserList.ajax',	
				data: param,
				dataType: 'json',
			    success : function(data) {		    
			    	look.init(param.pageCnt, param.pageNum, data.count, data.userList).view().paging();			
			    },
			    error : function(request, status, error){
			    	alert("error");
			    }
			});
		},
		
		view : function(){
			
			$("#userList").empty();
			
			let tag = "<table class='table table-sm table-striped table-bordered'>";
				tag	+= "<tr>";			
				tag	+= "<th style='width: 5%;'>번호</th>";
				tag	+= "<th>아이디</th>";
				tag	+= "<th>이름</th>";			
				tag	+= "<th>상세정보</th>";			
				tag += "</tr>";		
			
			for(let i=0; i<this.userList.length; i++){			
				tag += "<tr>";			
				tag += "<td>"+this.userList[i].userSeq+"</td>";
				tag += "<td>"+this.userList[i].userId+"</td>";
				tag += "<td>"+this.userList[i].userName+"</td>";	
				tag += "<td><button id='viewBtn_"+i+"' class='btn btn-outline-secondary btn-sm btn-sm-fs' value='"+this.userList[i].userSeq+"'>보기</button></td>";	
				tag += "</tr>";		
			}
			
			tag +="</table>";
			$("#userList").append(tag);
			return this;
		},
		
		paging : function(){
			
			$("#paging").empty();
			
			let tag = "<div class='btn-toolbar' role='toolbar'>";
			let blockNum = Math.floor(this.pageNum/this.blockCnt)*this.blockCnt;
			let blockLen = Math.ceil(this.count / this.pageCnt);
			
			if(blockNum !== 0){
				tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
				tag += "<button type='button' class='btn btn-secondary' value='1'><<</button>";
				
				if(this.pageNum <= 10){
					tag += "<button type='button' class='btn btn-secondary' value='1'><</button>";
				}else{
					tag += "<button type='button' class='btn btn-secondary' value='"+(blockNum-this.blockCnt)+"'><</button>";
				}
			}
			tag += "</div>";
			
			
			tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
			for(let i=blockNum; i<blockNum+this.blockCnt; i++){
				if(i === 0) continue;			
				
				if(i <= blockLen){
					if(this.pageNum === i){
						tag += "<button type='button' class='btn btn-dark' value="+i+">"+i+"</button>";
					}else{
						tag += "<button type='button' class='btn btn-secondary' value="+i+">"+i+"</button>";
					}
				}			
			}
			tag += "</div>";
			
			if(this.pageNum < blockLen){
				
				tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
				if(this.pageNum <= blockLen-this.blockCnt){
					tag += "<button type='button' class='btn btn-secondary' value='"+(blockNum+this.blockCnt)+"'>></button>";
				}else{
					tag += "<button type='button' class='btn btn-secondary' value='"+String(blockLen)+"'>></button>";
				}			
				tag += "<button type='button' class='btn btn-secondary' value='"+String(blockLen)+"'>>></button>";
				tag += "</div>";
			}		
					
			tag += "</div>";
			$("#paging").append(tag);
			
			return this;
		}
			
	}
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