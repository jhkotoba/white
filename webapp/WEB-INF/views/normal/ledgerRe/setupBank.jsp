<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){	
	
	$.ajax({
		type: 'POST',
		url: common.path()+'/ledgerRe/selectBankList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {
	    	bank.init(data).view();
	    },
	    error : function(request, status, error){
	    	alert("bank error");
	    }
	});
	
	//은행 추가
	$("#bankAddBtn").click(function(){
		bank.add().view();
	});
	
	//은행 취소
	$("#bankCelBtn").click(function(){
		bank.cancel().view();
	});
	
	$("#bankSaveBtn").click(function(){
		let rtn = bank.check();
		if(rtn.check === true){
			bank.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	
	$('#bankList').on("change keyup input", function(event) {
		bank.sync(event.target);
	});
	
	$('#bankList').on("click", function(event) {
		bank.sync(event.target);
	});
});

let bank = {
	bankList : new Array(),
	bankClone : new Array(),		
	
	init : function(bankList){		
    	this.bankList = bankList;
    	this.bankClone = common.clone(this.bankList);   
    	return this;
	},
	
	add : function(){
		this.bankList.push({bankName: '', bankAccount: '', bankUseYn: 'Y', state: 'insert'});		
		return this;
	},
	
	del : function(idx){		
		this.bankList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.bankList = common.clone(this.bankClone);		
		return this;
	},
	
	view : function(){
		
		$("#bankList").empty();
		
		let tag = "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";			
			tag += "<th colspan='2' style='width:3%'>순서</th>";
			tag	+= "<th>은행이름</th>";
			tag	+= "<th>계좌번호</th>";
			tag	+= "<th style='width: 20px;'>표시여부</th>";
			tag	+= "<th style='width: 20px;'>사용여부</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		let useCls = "";
		
		for(let i=0; i<this.bankList.length; i++){			
			
			if(this.bankList[i].state === "insert"){
				addAttr = {chked:"", cls:"insert", read:""};			
			}else if(this.bankList[i].state === "delete"){				
				addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
			}else if(this.bankList[i].state === "update"){
				addAttr = {chked:"", cls:"update", read:""};
			}else{
				addAttr = {chked:"", cls:"", read:""};
			}
			
			this.bankList[i].bankUseYn === "N" ? useCls = "btn-outline-danger" : useCls = "";
						
			tag += "<tr>";			
			tag += "<td><input id='delete_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
			tag += "<td>"+(i+1)+"</td>";
			tag += "<td><input id='bankName_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.bankList[i].bankName+"' ></td>";
			tag += "<td><input id='bankAccount_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.bankList[i].bankAccount+"'></td>";
			tag += "<td><input id='bankShowYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs' value='Y' ></td>";
			tag += "<td><input id='bankUseYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs "+useCls+"' "+addAttr.read+" value='"+this.bankList[i].bankUseYn+"'></td>";
			tag += "</tr>";	
		}			
		tag +="</table>";
		$("#bankList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "delete"){
			
			if(this.bankList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.bankList[idx].state = "delete";				
				$("#bankName_"+idx).addClass("delete").prop("readOnly", true);
				$("#bankAccount_"+idx).addClass("delete").prop("readOnly", true);				
				$("#bankUseYn_"+idx).prop("disabled", true);
			}else{
				this.bankList[idx].state = "select";
				$("#bankName_"+idx).removeClass("delete").prop("readOnly", false);
				$("#bankAccount_"+idx).removeClass("delete").prop("readOnly", false);
				$("#bankUseYn_"+idx).prop("disabled", false);
			}
		}else if(name === "bankUseYn"){
			if(target.value === "Y"){
				this.bankList[idx][name] = "N";
				$(target).val("N").addClass("btn-outline-danger");				
			}else if(target.value === "N"){
				this.bankList[idx][name] = "Y";
				$(target).val("Y").removeClass("btn-outline-danger");
			}			
		}else{			
			this.bankList[idx][name] = String(target.value);
		}
		
		
		if(this.bankList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.bankList[idx].state = "update";			
				$("#bankName_"+idx).addClass("update").prop("readOnly", false);
				$("#bankAccount_"+idx).addClass("update").prop("readOnly", false);
			}else{
				if(this.bankList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.bankList[idx].state = "delete" : this.bankList[idx].state = "select";			
					$("#bankName_"+idx).removeClass("update");
					$("#bankAccount_"+idx).removeClass("update");
				}
			}
		}
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.bankList.length; i++){
			
			// 빈값, null 체크
			if(this.bankList[i].bankName === '' || this.bankList[i].bankName === null){
				check = {check : false, msg : (i+1) + "행의 은행이름이 입력되지 않았습니다."};
				break;
			}else if(this.bankList[i].bankAccount === '' || this.bankList[i].bankAccount === null){
				check = {check : false, msg : (i+1) + "행의 은행계좌번호가 입력되지 않았습니다."};
				break;
			}
			
			if(this.bankList[i].state === "select") saveChk++;
		}

		if(this.bankList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.bankList.length; i++){		
			
			if(this.bankList[i].state === "insert"){
				inList.push(this.bankList[i]);
			}else if(this.bankList[i].state === "update"){
				upList.push(this.bankList[i]);
			}else if(this.bankList[i].state === "delete"){
				delList.push(this.bankList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/inUpDelBankList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="bankUsed"){
		    		alert("삭제-사용되는 은행이 존재하여 실패.");
		    	}		    	
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());		    	
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});	
	},
	
	equals : function(idx){
		
		if(this.bankList[idx].bankName !== this.bankClone[idx].bankName){
			return false;
		}else if(this.bankList[idx].bankAccount !== this.bankClone[idx].bankAccount){
			return false;
		}else if(this.bankList[idx].bankUseYn !== this.bankClone[idx].bankUseYn){
			return false;
		}else{
			return true;	
		}
	}
	
}

</script>
<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">은행설정</h1>
	</div>	
	<div class="btn-group" role="group">	
		<button id="bankAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
		<button id="bankSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">저장</button>
		<button id="bankCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
	</div>	
	<div id="bankList" class="width-full"></div>
</div>