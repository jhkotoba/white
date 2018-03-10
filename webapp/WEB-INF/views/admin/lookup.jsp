<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<script type="text/javascript" src="${contextPath}/resources/js/admin/lookup.js"></script>
<script type="text/javascript">
$(document).ready(function(){

	$("#srcBtn").on("click", function(){
		ad.select();
	});
	
	$("#closeInfo").on("click", function(){
		$("input:checkbox[name='authChk']").prop("checked", false).val("none");
		$("#userNo").val("");		
		$("#userNum").text("");
		$("#userId").text("");
		$("#userNm").text("");
		$("#userInfo").hide();		
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
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/ajax/inDelAuthList.do',
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
		    	$('#closeInfo').trigger('click');
			},
			error : function(xhr, stat, err) {
				alert("inDelAuthList error");
			}
		});
	});
});

</script>
</head>
<body>

<div id="userInfo" class="divPop">
	<input id="userNo" type="hidden" value="">
	
	<div id='closeInfo' class='closeIcon maxLeft' title='닫기'></div>
	<table border="1">
		<thead>
			<tr>
				<th>userNo</th>
				<th>userId</th>
				<th>userName</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span id="userNum"></span></td>
				<td><span id="userId"></span></td>
				<td><span id="userNm"></span></td>
			</tr>			
		</tbody>	
	</table>
	
	<br><span>사용자 권한 설정</span>
	<button id="authSave">저장</button>
	<div id="authList">
		<c:forEach items="${authList}" var="item">
			<input id="auth_${item.authNmSeq}" name="authChk" type="checkbox" value="none">${item.authNm}
		</c:forEach>
	</div>
</div>

<div>
	<input id="srhId" type="text" value="" placeholder="사용자 아이디">
	<input id="srhNm" type="text" value="" placeholder="사용자 이름">
	<input id="pageNum" type="hidden" value="1">
		
	<select id="pageCnt">
		<option value="5">5개</option>
		<option value="10" selected="selected">10개</option>
		<option value="20">20개</option>
		<option value="50">50개</option>
		<option value="100">100개</option>
	</select>
	
	<button id="srcBtn">검색</button>
</div>

<div id="userList">	
</div>

<div id="paging">
</div>


</body>
</html>
