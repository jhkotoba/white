<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/bootstrap-4.1.1/css/bootstrap.min.css" type="text/css" />
<style>
table{color:black !important;}
</style>
<script type="text/javascript" src="${contextPath}/resources/bootstrap-4.1.1/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	if(window.innerWidth > common.platformSize){
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
	
	
	$('#purList').on("change keyup input", function(event) {
		pur.sync(event.target);
	});
	
	$('#purList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "purUp" :
			pur.change(Number(idx), "up").sync(event.target).view();
			break;
		case "purDown" :
			pur.change(Number(idx), "down").sync(event.target).view();
			break;
		}
	});	
	
	$('#purDtlList').on("change keyup input", function(event) {
		purDtl.sync(event.target);
	});
	
	$('#purDtlList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "purDtlUp" :
			purDtl.change(Number(idx), "up").sync(event.target).view();
			break;
		case "purDtlDown" :
			purDtl.change(Number(idx), "down").sync(event.target).view();
			break;
		}
	});
});



let pur = {
	purList : new Array(),
	purClone : new Array(),
	lastIdx : 0,
	
	init : function(purList){		
    	this.purList = purList;
    	this.purClone = common.clone(this.purList);   
    	return this;
	},
	
	add : function(){
		
		if(this.purList.length === 0){
			this.purList.push({purOrder: (this.purList.length+1), purpose: '', state: 'insert'});
		}else{
			this.purList.push({purOrder: (this.purList[this.purList.length-1].purOrder+1), purpose: '', state: 'insert'});
		}				
		return this;
	},
	
	del : function(idx){		
		this.purList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.purList = common.clone(this.purClone);		
		return this;
	},
	
	view : function(){
		
		$("#purList").empty();
		
		let tag = "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";			
			tag += "<th colspan='2'>순서</th>";
			tag	+= "<th>목적내용</th>";
			tag	+= "<th>순서설정</th>";
			tag	+= "<th>상세보기</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		this.lastIdx = 0;
		
		if(this.purList.length === 0){
			tag += "<tr><td colspan='4'>목적 리스트가 없습니다.</td></tr>";
			tag +="</table>";
			$("#purList").append(tag);
		}else{
			for(let i=0; i<this.purList.length; i++){			
				
				if(this.purList[i].state === "insert"){
					addAttr = {chked:"", cls:"insert", read:""};			
				}else if(this.purList[i].state === "delete"){				
					addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
				}else if(this.purList[i].state === "update"){
					addAttr = {chked:"", cls:"update", read:""};
				}else{
					addAttr = {chked:"", cls:"", read:""};
				}
				
				tag += "<tr>";			
				tag += "<td><input id='purDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
				tag += "<td>"+(i+1)+"</td>";
				tag += "<td><input id='purpose_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.purList[i].purpose+"' ></td>";			
				if(this.purList[i].state !== "insert"){
					tag += "<td><button id='purUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>위로</button><button id='purDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>아래</button></td>";
					this.lastIdx++;
				}else{
					tag += "<td><button id='purUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>위로</button><button id='purDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>아래</button></td>";
				}
				tag += "<td><button class='btn btn-secondary btn-sm btn-sm-fs' onclick='purDtl.cancel().view("+this.purList[i].purSeq+",\""+this.purList[i].purpose+"\");'>보기</button></td>";
				tag += "</tr>";
			}			
			tag +="</table>";
			$("#purList").append(tag);
			
			//게시물이 1개일경우 순서버튼 막기
			$("#purList #purUp_0").prop("disabled", true);
			if(this.purList.length === 1){				
				$("#purList #purDown_0").prop("disabled", true);
			}else{				
				$("#purList #purDown_"+String(this.lastIdx-1)).prop("disabled", true);
			}
		}
		
		return this;
	},
	
	change : function(idx, isUpDown){
		let temp = null;
		switch(isUpDown){
		case "up" :
			if(idx <= 0){				
				return this;
			}else{								
				temp = this.purList[idx].purOrder;
				this.purList[idx].purOrder = this.purList[idx-1].purOrder;
				this.purList[idx-1].purOrder = temp;
				
				temp = common.clone(this.purList[idx]);				
				this.purList[idx] = common.clone(this.purList[idx-1]);
				this.purList[idx-1] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.purList.length-1)){
				return this;
			}else{
				temp = this.purList[idx].purOrder;
				this.purList[idx].purOrder = this.purList[idx+1].purOrder;
				this.purList[idx+1].purOrder = temp;
				
				temp = this.purList[idx];
				this.purList[idx] = this.purList[idx+1];
				this.purList[idx+1] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){		
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		
		switch(name){
		
		case "purDel":
			if(this.purList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#purpose_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);				
				this.purList[idx].state = "delete";
			}else{				
				$("#purpose_"+idx).removeClass("delete").prop("readOnly", false);				
				if(idx !== 0) $("#navUp_"+idx).prop("disabled", false);				
				if(idx !== this.lastIdx-1) $("#navDown_"+idx).prop("disabled", false);
				this.purList[idx].state = "select";
			}
			break;
		case "purUp" :
			syncFunc(this, idx-1);
			break;
		case "purDown" :
			syncFunc(this, idx+1);			
			break;
		default :
			this.purList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){
			switch(obj.purList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.purList[idx].state = "update";			
					$("#purpose_"+idx).addClass("update").prop("readOnly", false);					
				}else{
					$(target).is(":checked") === true ? obj.purList[idx].state = "delete" : obj.purList[idx].state = "select";					
					$("#purpose_"+idx).removeClass("update");			
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.purList.length; i++){
			
			// 빈값, null 체크
			if(this.purList[i].purpose === '' || this.purList[i].purpose === null){
				check = {check : false, msg : (i+1) + "행의 목적이 입력되지 않았습니다."};
				break;
			}
			
			if(this.purList[i].state === "select") saveChk++;
		}

		if(this.purList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.purList.length; i++){		
			
			if(this.purList[i].state === "insert"){
				inList.push(this.purList[i]);
			}else if(this.purList[i].state === "update"){
				upList.push(this.purList[i]);
			}else if(this.purList[i].state === "delete"){
				delList.push(this.purList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("추가,수정,삭제한 목적을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/inUpDelPurList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="recodePurUsed"){
		    		alert("record에 사용되는 purpose가 존재하여 실패.");
		    	}else if(data.msg==="purDtlPurUsed"){
		    		alert("상세목적에 사용되는 purpose가 존재하여 실패.");
		    	}else{
		    		alert("추가:"+data.inCnt+"개, 수정:"+data.upCnt+"개, 삭제:"+data.delCnt+"개가 저장되었습니다.");
		    	}		    	
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});	
	},
	
	equals : function(idx){
		
		if(this.purList[idx].purpose !== this.purClone[idx].purpose){
			return false;
		}else{
			return true;	
		}
	}
	
}

let purDtl = {
	purDtlList : new Array(),
	purDtlClone : new Array(),
	purSeq : "",
	purpose : "",
	firstIdx : 0,
	lastIdx : 0,
	
	init : function(purDtlList){		
		this.purDtlList = purDtlList;
		this.purDtlClone = common.clone(this.purDtlList);    
    	return this;
	},
	
	add : function(){
		
		if(emptyCheck.isNotEmpty(this.purSeq)){
			if(this.purDtlList.length === 0){
				this.purDtlList.push({purSeq: this.purSeq, purDtlOrder: 1, purDetail: '', state: 'insert'});
			}else{
				this.purDtlList.push({purSeq: this.purSeq, purDtlOrder:  (this.purDtlList[this.purDtlList.length-1].purDtlOrder+1), purDetail: '', state: 'insert'});	
			}
		}
		return this;
	},
	
	del : function(idx){		
		this.purDtlList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.purDtlList = common.clone(this.purDtlClone);		
		return this;
	},
	
	view : function(purSeq, purpose){
		if(emptyCheck.isNotEmpty(purSeq)){
			this.purSeq = purSeq;
			this.purpose = purpose;
		}
	
		$("#purDtlList").empty();
	
		let tag = "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";
			tag += "<th colspan='2'>순서</th>";
			tag	+= "<th>"+ (emptyCheck.isEmpty(this.purpose)===true?"":"\""+this.purpose+"\"") +" 상세목적 내용</th>";
			tag	+= "<th>순서설정</th>";
			tag += "</tr>";
		
		this.lastIdx = 0;
		let purDtlView = {cnt:0, idxList : new Array()}
		let addAttr = {chked:"", cls:"", read:""};		
		
		if(purDtlList.length === 0){
			tag += "<tr><td colspan='4'>no data</td></tr>";
			tag +="</table>";
			$("#purDtlList").append(tag);
		}else{
			for(let i=0; i<this.purDtlList.length; i++){			
				if(this.purDtlList[i].purSeq === this.purSeq){
					
					if(this.purDtlList[i].state === "insert"){
						addAttr = {chked:"", cls:"insert", read:""};			
					}else if(this.purDtlList[i].state === "delete"){				
						addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
					}else if(this.purDtlList[i].state === "update"){
						addAttr = {chked:"", cls:"update", read:""};
					}else{
						addAttr = {chked:"", cls:"", read:""};
					}				
					
					tag += "<tr>";		
					tag += "<td><input id='purDtlDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
					tag += "<td>"+this.purDtlList[i].purDtlOrder+"</td>";
					tag += "<td><input id='purDetail_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' value='"+this.purDtlList[i].purDetail+"' "+addAttr.read+"></td>";
					if(this.purDtlList[i].state !== "insert"){
						tag += "<td><button id='purDtlUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>위로</button><button id='purDtlDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>아래</button></td>";
						this.lastIdx++;
					}else{
						tag += "<td><button id='purDtlUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>위로</button><button id='purDtlDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>아래</button></td>";
					}
					tag += "</tr>";					
					purDtlView.cnt ++;
					purDtlView.idxList.push(i);
				}
			}	
			
			//해당 게시물이 0개일경우 NoData
			if(purDtlView.cnt === 0){
				tag += "<tr><td colspan='4'>상세목적 리스트가 없습니다.</td></tr>";				
			}
			tag +="</table>";
			$("#purDtlList").append(tag);
			
			if(this.purDtlClone.length === 1){
				$("#purDtlList #purDtlUp_"+purDtlView.idxList[0]).prop("disabled", true);
				$("#purDtlList #purDtlDown_"+purDtlView.idxList[0]).prop("disabled", true);
			}else{
				$("#purDtlList #purDtlUp_"+purDtlView.idxList[0]).prop("disabled", true);
				$("#purDtlList #purDtlDown_"+purDtlView.idxList[purDtlView.idxList.length-1]).prop("disabled", true);
			}			
			this.firstIdx = purDtlView.idxList[0];
		}
		
		if(purDtlView.cnt !== 0){
			document.getElementById('purDtlWidth').scrollIntoView(true);	
		}	
		return this;
	},
	
	change : function(idx, isUpDown){
		let temp = null;
		let purSeq = this.purDtlList[idx].purSeq;
		
		switch(isUpDown){
		case "up" :
			if(idx <= 0){				
				return this;
			}else{
				
				let upIdx = 1;				
				while(true){					
					if(purSeq !== this.purDtlList[idx-upIdx].purSeq){
						upIdx++;
					}else{
						break;
					}
				}				
				
				temp = this.purDtlList[idx].purDtlOrder;
				this.purDtlList[idx].purDtlOrder = this.purDtlList[idx-upIdx].purDtlOrder;
				this.purDtlList[idx-upIdx].purDtlOrder = temp;
				
				temp = common.clone(this.purDtlList[idx]);				
				this.purDtlList[idx] = common.clone(this.purDtlList[idx-upIdx]);
				this.purDtlList[idx-upIdx] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.purDtlList.length-1)){
				return this;
			}else{
				
				let downIdx = 1;				
				while(true){					
					if(purSeq !== this.purDtlList[idx+downIdx].purSeq){
						downIdx++;
					}else{
						break;
					}
				}
				
				temp = this.purDtlList[idx].purDtlOrder;
				this.purDtlList[idx].purDtlOrder = this.purDtlList[idx+downIdx].purDtlOrder;
				this.purDtlList[idx+downIdx].purDtlOrder = temp;
				
				temp = this.purDtlList[idx];
				this.purDtlList[idx] = this.purDtlList[idx+downIdx];
				this.purDtlList[idx+downIdx] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){		
		
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		let purSeq = this.purDtlList[idx].purSeq;
		
		switch(name){
		
		case "purDtlDel":
			if(this.purDtlList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#purDetail_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				this.purDtlList[idx].state = "delete";
			}else{				
				$("#purDetail_"+idx).removeClass("delete").prop("readOnly", false);
				if(idx !== this.firstIdx) $("#purDtlUp_"+idx).prop("disabled", false);				
				if(idx !== this.lastIdx-1) $("#purDtlDown_"+idx).prop("disabled", false);
				this.purDtlList[idx].state = "select";
			}
			break;
		case "purDtlUp" :
			let upIdx = 1;
			while(true){					
				if(purSeq !== this.purDtlList[idx-upIdx].purSeq){
					upIdx++;
				}else{
					break;
				}
			}	
			syncFunc(this, idx-upIdx);
			break;
		case "purDtlDown" :
			let downIdx = 1;				
			while(true){					
				if(purSeq !== this.purDtlList[idx+downIdx].purSeq){
					downIdx++;
				}else{
					break;
				}
			}
			syncFunc(this, idx+downIdx);
			break;
		default :
			this.purDtlList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){			
			switch(obj.purDtlList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.purDtlList[idx].state = "update";			
					$("#purDetail_"+idx).addClass("update").prop("readOnly", false);
				}else{
					$(target).is(":checked") === true ? obj.purDtlList[idx].state = "delete" : obj.purDtlList[idx].state = "select";					
					$("#purDetail_"+idx).removeClass("update");			
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		
		for(let i=0; i<this.purDtlList.length; i++){
			
			// 빈값, null 체크
			if(this.purDtlList[i].purDetail === '' || this.purDtlList[i].purDetail === null){
				check = {check : false, msg : (i+1) + "행의 상세목적이 입력되지 않았습니다."};
				break;
			}
			
			if(this.purDtlList[i].state === "select") saveChk++;
			
		}
		
		if(this.purDtlList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.purDtlList.length; i++){		
			
			if(this.purDtlList[i].state === "insert"){
				inList.push(this.purDtlList[i]);
			}else if(this.purDtlList[i].state === "update"){
				upList.push(this.purDtlList[i]);
			}else if(this.purDtlList[i].state === "delete"){
				delList.push(this.purDtlList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("추가,수정,삭제한 상세목적을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/inUpDelPurDtlList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="purDtlUsed"){
		    		alert("삭제-사용되는 상세목적이 존재하여 실패.");
		    	}else{
		    		alert("추가:"+data.inCnt+"개, 수정:"+data.upCnt+"개, 삭제:"+data.delCnt+"개가 저장되었습니다.");
		    	}		    	
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});	
	},
	
	equals : function(idx){
		
		if(this.purDtlList[idx].purDetail !== this.purDtlClone[idx].purDetail){
			return false;
		}else{
			return true;	
		}
	}
}
</script>

<div>

	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">목적설정</h1>
	</div>
	<div id="purWidth" class="width-half">
		<div class="btn-group" role="group">	
			<button id="purAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="purSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">목적 저장</button>
			<button id="purCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="purList"></div>	
	</div>	
	
	<div id="purDtlWidth" class="width-half">
		<div class="btn-group" role="group">	
			<button id="purDtlAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="purDtlSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">상세목적 저장</button>
			<button id="purDtlCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="purDtlList"></div>
	</div>
</div>