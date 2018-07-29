<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
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
	
	$('#authList').on("change keyup input", function(event) {
		auth.sync(event.target);
	});
	
	$('#authList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "authUp" :
			auth.change(Number(idx), "up").sync(event.target).view();
			break;
		case "authDown" :
			auth.change(Number(idx), "down").sync(event.target).view();
			break;
		}
	});	
});

let auth = {
		authList : new Array(),
		authClone : new Array(),
		lastIdx : 0,
		
		init : function(authList){		
	    	this.authList = authList;
	    	this.authClone = common.clone(this.authList);   
	    	return this;
		},
		
		add : function(){
			if(authList.length === 0){
				this.authList.push({authNmSeq: '', authNm: '', authCmt:'', authOrder : 1, state: 'insert'});
			}else{
				this.authList.push({authNmSeq: '', authNm: '', authCmt:'', authOrder : (this.authList[this.authList.length-1].authOrder+1), state: 'insert'});
			}
				
			return this;
		},
		
		del : function(idx){		
			this.authList.splice(idx,1);
			return this;
		},
		
		cancel : function(){
			this.authList = common.clone(this.authClone);		
			return this;
		},
		
		view : function(){
			
			$("#authList").empty();
			
			let tag = "<table class='table table-striped table-sm table-bordered'>";
				tag	+= "<tr>";			
				tag += "<th colspan='2'>순서</th>";
				tag	+= "<th>권한이름</th>";
				tag	+= "<th>권한설명</th>";
				tag	+= "<th>순서설정</th>";
				tag += "</tr>";
			
			this.lastIdx = 0;
			let addAttr = {chked:"", cls:"", read:""};
			
			if(authList.length === 0){
				tag += "<tr><td colspan='4'>권한 리스트가 없습니다.</td></tr>";
				tag +="</table>";
				$("#authList").append(tag);
			}else{
				for(let i=0; i<this.authList.length; i++){			
					
					if(this.authList[i].state === "insert"){
						addAttr = {chked:"", cls:"insert", read:""};			
					}else if(this.authList[i].state === "delete"){				
						addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
					}else if(this.authList[i].state === "update"){
						addAttr = {chked:"", cls:"update", read:""};
					}else{
						addAttr = {chked:"", cls:"", read:""};
					}
								
					tag += "<tr>";			
					tag += "<td><input id='authDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
					tag += "<td>"+(i+1)+"</td>";
					tag += "<td><input id='authNm_"+i+"' type='text' class='form-control "+addAttr.cls+"' "+addAttr.read+" value='"+this.authList[i].authNm+"' ></td>";
					tag += "<td><input id='authCmt_"+i+"' type='text' class='form-control "+addAttr.cls+"' "+addAttr.read+" value='"+this.authList[i].authCmt+"' ></td>";
					if(this.authList[i].state !== "insert"){
						tag += "<td><button id='authUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>위로</button><button id='authDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>아래</button></td>";
						this.lastIdx++;
					}else{
						tag += "<td><button id='authUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>위로</button><button id='authDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>아래</button></td>";
					}
					tag += "</tr>";	
				}			
				tag +="</table>";
				$("#authList").append(tag);
				
				//게시물이 1개일경우 순서버튼 막기
				$("#authList #authUp_0").prop("disabled", true);
				if(this.authList.length === 1){				
					$("#authList #authDown_0").prop("disabled", true);
				}else{				
					$("#authList #authDown_"+String(this.lastIdx-1)).prop("disabled", true);
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
					temp = this.authList[idx].authOrder;
					this.authList[idx].authOrder = this.authList[idx-1].authOrder;
					this.authList[idx-1].authOrder = temp;
					
					temp = common.clone(this.authList[idx]);				
					this.authList[idx] = common.clone(this.authList[idx-1]);
					this.authList[idx-1] = temp;
				}
				break;
			case "down" :
				if(idx >= (this.authList.length-1)){
					return this;
				}else{
					temp = this.authList[idx].authOrder;
					this.authList[idx].authOrder = this.authList[idx+1].authOrder;
					this.authList[idx+1].authOrder = temp;
					
					temp = this.authList[idx];
					this.authList[idx] = this.authList[idx+1];
					this.authList[idx+1] = temp;
				}
				break;
			}
			return this;
		},
		
		sync : function(target){	
			
			let name = target.id.split('_')[0];
			let idx = Number(target.id.split('_')[1]);
			
			switch(name){
			
			case "authDel":
				if(this.authList[idx].state === "insert" && $(target).is(":checked") === true){
					this.del(idx).view();
					return;
				}			
				
				if( $(target).is(":checked") === true ){							
					$("#authNm_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);			
					$("#authCmt_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);			
					this.authList[idx].state = "delete";
				}else{				
					$("#authNm_"+idx).removeClass("delete").prop("readOnly", false);				
					$("#authCmt_"+idx).removeClass("delete").prop("readOnly", false);				
					if(idx !== 0) $("#authUp_"+idx).prop("disabled", false);			
					if(idx !== this.lastIdx-1) $("#authDown_"+idx).prop("disabled", false);
					this.authList[idx].state = "select";
				}
				break;			
			case "authUp" :
				syncFunc(this, idx-1);
				break;
			case "authDown" :
				syncFunc(this, idx+1);			
				break;
			default :
				this.authList[idx][name] = String(target.value);
				break;		
			}
			syncFunc(this, idx);
			
			
			function syncFunc(obj, idx){			
				switch(obj.authList[idx].state){
				case "select" :
				case "update" :
					if($(target).is(":checked") === false && obj.equals(idx) === false){
						obj.authList[idx].state = "update";			
						$("#authNm_"+idx).addClass("update").prop("readOnly", false);					
						$("#authCmt_"+idx).addClass("update").prop("readOnly", false);					
					}else{
						$(target).is(":checked") === true ? obj.authList[idx].state = "delete" : obj.authList[idx].state = "select";					
						$("#authNm_"+idx).removeClass("update");		
						$("#authCmt_"+idx).removeClass("update");		
					}
					break;
				}
			}
			return this;
		},
		
		check : function(){
			let check = {check : true, msg : ""};
			let saveChk = 0;
			for(let i=0; i<this.authList.length; i++){
				
				// 빈값, null 체크
				if(this.authList[i].authNm === '' || this.authList[i].authNm === null){
					check = {check : false, msg : (i+1) + "행의 은행이름이 입력되지 않았습니다."};
					break;
				}			
				if(this.authList[i].state === "select") saveChk++;
			}

			if(this.authList.length === saveChk){
				check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
			}
			return check;
		},
		
		save : function(){
			let inList = new Array();
			let upList = new Array();
			let delList = new Array();
			
			for(let i=0; i<this.authList.length; i++){		
				
				if(this.authList[i].state === "insert"){
					inList.push(this.authList[i]);
				}else if(this.authList[i].state === "update"){
					upList.push(this.authList[i]);
				}else if(this.authList[i].state === "delete"){
					delList.push(this.authList[i]);
				}
			}
			
			if(inList.length === 0 && upList.length === 0 && delList.length === 0){
				alert("추가, 수정, 삭제할 대상이 없습니다.");
				return;
			}

			$.ajax({		
				type: 'POST',
				url: common.path()+'/admin/inUpDelAuthNmList.ajax',
				data: {
					inList : JSON.stringify(inList),
					upList : JSON.stringify(upList),
					delList : JSON.stringify(delList)
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {
			    	if(data.msg==="used"){
			    		alert("사용되는 권한이 존재합니다.");
			    	}
			    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    },
			    error : function(xhr, stat, err) {
			    	alert("insert, update, delete error");
			    }
			});
		},
		
		equals : function(idx){
			
			if(this.authList[idx].authNm !== this.authClone[idx].authNm){
				return false;
			}else if(this.authList[idx].authCmt !== this.authClone[idx].authCmt){
				return false;
			}else{
				return true;	
			}
		}
		
	}

</script>
<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">권한설정</h1>
	</div>
	<div class="width-vmin">
		<div class="btn-group" role="group">	
			<button id="authAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="authSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">권한 저장</button>
			<button id="authCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="authList"></div>
	</div>
<div class="article">