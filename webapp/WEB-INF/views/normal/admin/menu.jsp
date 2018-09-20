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
		$("#navMenuWidth").addClass("left");
		$("#sideMenuWidth").addClass("left");
	}	
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/admin/selectNavSideMenuList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {	
	    	nav.init(data.navList, data.authList).view();
	    	side.init(data.sideList, data.authList).view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//헤더메뉴 추가
	$("#navAddBtn").click(function(){		
		nav.add().view();
	});
	
	//취소
	$("#navCelBtn").click(function(){		
		nav.cancel().view();
	});
	
	//네비메뉴 저장, 수정, 삭제
	$("#navSaveBtn").click(function(){
		let rtn = nav.check();
		if(rtn.check === true){
			nav.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	
	
	//사이드메뉴 추가
	$("#sideAddBtn").click(function(){		
		side.add().view();
	});
	
	//사이드메뉴 취소
	$("#sideCelBtn").click(function(){		
		side.cancel().view();
	});
	
	
	//사이드메뉴 저장
	$("#sideSaveBtn").click(function(){
		let rtn = side.check();
		if(rtn.check === true){
			side.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	
	
	$('#navList').on("change keyup input", function(event) {
		nav.sync(event.target);
	});
	
	$('#navList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "navUp" :
			nav.change(Number(idx), "up").sync(event.target).view();
			break;
		case "navDown" :
			nav.change(Number(idx), "down").sync(event.target).view();
			break;
		case "navShowYn" :
			nav.sync(event.target);
			break;
		}
	});	
	
	$('#sideList').on("change keyup input", function(event) {
		side.sync(event.target);
	});
	
	$('#sideList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "sideUp" :
			side.change(Number(idx), "up").sync(event.target).view();
			break;
		case "sideDown" :
			side.change(Number(idx), "down").sync(event.target).view();
			break;
		case "sideShowYn" :
			side.sync(event.target);
			break;
		}
	});
});



let nav = {
	navList : new Array(),
	navClone : new Array(),
	authList : new Array(),
	lastIdx : 0,
	
	init : function(navList, authList){		
    	this.navList = navList;
    	this.authList = authList;
    	this.navClone = common.clone(this.navList);
    	return this;
	},
	
	add : function(){
		if(this.navList.length === 0){
			this.navList.push({navUrl : '', navAuthNmSeq : '', navNm : '', navShowYn : 'Y', navOrder : 1, state: 'insert'});
		}else{
			this.navList.push({navUrl : '', navAuthNmSeq : '', navNm : '', navShowYn : 'Y', navOrder : (this.navList[this.navList.length-1].navOrder+1), state: 'insert'});
		}				
		return this;
	},
	
	del : function(idx){		
		this.navList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.navList = common.clone(this.navClone);		
		return this;
	},
	
	view : function(){
		
		$("#navList").empty();
		
		let tag = "";
		
		if(window.innerWidth > common.platformSize){

			tag += "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";			
			tag += "<th colspan='2'>순서</th>";		
			tag	+= "<th>네비메뉴 이름/URL</th>";
			tag	+= "<th>권한</th>";
			tag += "<th>표시</th>";
			tag	+= "<th>순서설정</th>";
			tag	+= "<th>상세보기</th>";
			tag += "</tr>";
			
			this.lastIdx = 0;
			let addAttr = {chked:"", cls:"", read:""};
			
			if(this.navList.length === 0){
				tag += "<tr><td colspan='6'>메뉴 리스트가 없습니다.</td></tr>";
				tag +="</table>";
				$("#navList").append(tag);
			}else{
				for(let i=0; i<this.navList.length; i++){			
					
					if(this.navList[i].state === "insert"){
						addAttr = {chked:"", cls:"insert", read:""};			
					}else if(this.navList[i].state === "delete"){				
						addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
					}else if(this.navList[i].state === "update"){
						addAttr = {chked:"", cls:"update", read:""};
					}else{
						addAttr = {chked:"", cls:"", read:""};
					}
									
					this.navList[i].navShowYn === "N" ? useCls = "btn-outline-danger" : useCls = "";
					
					tag += "<tr>";			
					tag += "<td><input id='navDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
					tag += "<td>"+(i+1)+"</td>";
					tag += "<td><input id='navNm_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navNm+"'>";
					tag += "<input id='navUrl_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navUrl+"'></td>";
					tag += "<td><select id='navAuthNmSeq_"+i+"' class='custom-select custom-select-sm slt-fs "+addAttr.cls+"'>";				
					tag += "<option value=''>선택</option>";			
					for(let j=0; j<this.authList.length; j++){
						String(this.navList[i].navAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
						tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
					}
					tag += "</select></td>";
					tag += "<td><input id='navShowYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs "+useCls+"' "+addAttr.read+" value='"+this.navList[i].navShowYn+"'></td>";
					if(this.navList[i].state !== "insert"){
						tag += "<td><button id='navUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>위로</button><button id='navDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>아래</button></td>";
						this.lastIdx++;
					}else{
						tag += "<td><button id='navUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>위로</button><button id='navDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>아래</button></td>";
					}
					tag += "<td><button class='btn btn-secondary btn-sm btn-sm-fs' onclick='side.cancel().view("+this.navList[i].navSeq+",\""+this.navList[i].navUrl+"\")'>보기</button></td>";
					tag += "</tr>";	
				}			
				tag +="</table>";
				$("#navList").append(tag);
				
				//게시물이 1개일경우 순서버튼 막기
				$("#navList #navUp_0").prop("disabled", true);
				if(this.navList.length === 1){				
					$("#navList #navDown_0").prop("disabled", true);
				}else{				
					$("#navList #navDown_"+String(this.lastIdx-1)).prop("disabled", true);
				}
			}
		}else{		
			
			tag += "<table class='table table-striped table-sm table-bordered'>";
			
			this.lastIdx = 0;
			let addAttr = {chked:"", cls:"", read:""};
			
			if(this.navList.length === 0){
				tag += "<tr><td colspan='2'>메뉴 리스트가 없습니다.</td></tr>";
				tag +="</table>";
				$("#navList").append(tag);
			}else{
				for(let i=0; i<this.navList.length; i++){			
					
					if(this.navList[i].state === "insert"){
						addAttr = {chked:"", cls:"insert", read:""};			
					}else if(this.navList[i].state === "delete"){				
						addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
					}else if(this.navList[i].state === "update"){
						addAttr = {chked:"", cls:"update", read:""};
					}else{
						addAttr = {chked:"", cls:"", read:""};
					}
									
					this.navList[i].navShowYn === "N" ? useCls = "btn-outline-danger" : useCls = "";						
				
					tag += "<tr><th colspan='2'>순서</th>";					
					tag += "<th style='width: 60px;'>입력사항</th>";
					tag += "<th>입력내용</th>";
					tag += "<tr>";
										
					tag += "<tr><td rowspan='6'><input id='navDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
					tag += "<td rowspan='6'>"+(i+1)+"</td></tr>";
					
					tag += "<tr><th>네비메뉴 이름</th>";
					tag += "<td><input id='navNm_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navNm+"'></td></tr>";
					
					tag	+= "<tr><th>URL</th>";
					tag += "<td><input id='navUrl_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navUrl+"'></td></tr>";
					
					tag	+= "<tr><th>권한</th>";
					tag += "<td><select id='navAuthNmSeq_"+i+"' class='custom-select custom-select-sm slt-fs "+addAttr.cls+"'>";				
					tag += "<option value=''>선택</option>";			
					for(let j=0; j<this.authList.length; j++){
						String(this.navList[i].navAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
						tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
					}
					tag += "</select></td></tr>";
					
					tag += "<tr><th>표시</th>";
					tag += "<td><input id='navShowYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs "+useCls+"' "+addAttr.read+" value='"+this.navList[i].navShowYn+"'></td></tr>";
					
					tag	+= "<tr><th>상세보기</th>";
					tag += "<td><button class='btn btn-secondary btn-sm btn-sm-fs' onclick='side.cancel().view("+this.navList[i].navSeq+",\""+this.navList[i].navUrl+"\")'>보기</button></td></tr>";
					
					tag += "<tr style='height:2px;'></tr>";
					tag += "<tr style='height:2px;'></tr>";
				}			
				tag +="</table>";
				$("#navList").append(tag);
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
				temp = this.navList[idx].navOrder;
				this.navList[idx].navOrder = this.navList[idx-1].navOrder;
				this.navList[idx-1].navOrder = temp;
				
				temp = common.clone(this.navList[idx]);				
				this.navList[idx] = common.clone(this.navList[idx-1]);
				this.navList[idx-1] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.navList.length-1)){
				return this;
			}else{
				temp = this.navList[idx].navOrder;
				this.navList[idx].navOrder = this.navList[idx+1].navOrder;
				this.navList[idx+1].navOrder = temp;
				
				temp = this.navList[idx];
				this.navList[idx] = this.navList[idx+1];
				this.navList[idx+1] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		
		switch(name){
		
		case "navDel":
			if(this.navList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#navNm_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				$("#navUrl_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				$("#navAuthNmSeq_"+idx).removeClass("update").addClass("delete").prop("disabled", true);
				$("#navShowYn_"+idx).prop("disabled", true);
				this.navList[idx].state = "delete";
			}else{				
				$("#navNm_"+idx).removeClass("delete").prop("readOnly", false);
				$("#navUrl_"+idx).removeClass("delete").prop("readOnly", false);
				$("#navAuthNmSeq_"+idx).removeClass("delete").prop("disabled", false);
				$("#navShowYn_"+idx).prop("disabled", false);
				if(idx !== 0) $("#navUp_"+idx).prop("disabled", false);			
				if(idx !== this.lastIdx-1) $("#navDown_"+idx).prop("disabled", false);
				this.navList[idx].state = "select";
			}
			break;
		case "navShowYn" :
			if(target.value === "Y"){
				this.navList[idx][name] = "N";
				$(target).val("N").addClass("btn-outline-danger");
			}else if(target.value === "N"){
				this.navList[idx][name] = "Y";
				$(target).val("Y").removeClass("btn-outline-danger");
			}
			break;			
		case "navUp" :
			syncFunc(this, idx-1);
			break;
		case "navDown" :
			syncFunc(this, idx+1);			
			break;
		default :
			this.navList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){			
			switch(obj.navList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.navList[idx].state = "update";			
					$("#navNm_"+idx).addClass("update").prop("readOnly", false);
					$("#navUrl_"+idx).addClass("update").prop("readOnly", false);
					$("#navAuthNmSeq_"+idx).addClass("update").prop("readOnly", false);
				}else{
					$(target).is(":checked") === true ? obj.navList[idx].state = "delete" : obj.navList[idx].state = "select";					
					$("#navNm_"+idx).removeClass("update");
					$("#navUrl_"+idx).removeClass("update");
					$("#navAuthNmSeq_"+idx).removeClass("update");					
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.navList.length; i++){
			
			// 빈값, null 체크
			if(this.navList[i].navNm === '' || this.navList[i].navNm === null){
				check = {check : false, msg : (i+1) + "행의 메뉴이름이 입력되지 않았습니다."};
				break;
			}else if(this.navList[i].navUrl === '' || this.navList[i].navUrl === null){
				check = {check : false, msg : (i+1) + "행의 URL이 입력되지 않았습니다."};
				break;				
			}else if(this.navList[i].navAuthNmSeq === '' || this.navList[i].navAuthNmSeq === null){
				check = {check : false, msg : (i+1) + "행의 권한이 선택되지 않았습니다"};
				break;
			}
			
			if(this.navList[i].state === "select") saveChk++;
		}

		if(this.navList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.navList.length; i++){		
			
			if(this.navList[i].state === "insert"){
				inList.push(this.navList[i]);
			}else if(this.navList[i].state === "update"){
				upList.push(this.navList[i]);
			}else if(this.navList[i].state === "delete"){
				delList.push(this.navList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("추가, 수정, 삭제한 네비URL을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/inUpDelNavMenuList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="used"){
		    		alert("삭제하려는 navUrl의 하위 sideUrl이 존재하여 삭제 불가.");
		    	}else{
		    		alert(data.inCnt+" 개의 메뉴가 입력, "+data.upCnt+" 개의 메뉴가 수정, "+ data.delCnt+" 개의 메뉴가 삭제되었습니다");
		    	}		    	
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});
	},
	
	equals : function(idx){
		
		if(this.navList[idx].navNm !== this.navClone[idx].navNm){
			return false;
		}else if(this.navList[idx].navUrl !== this.navClone[idx].navUrl){
			return false;
		}else if(String(this.navList[idx].navAuthNmSeq) !== String(this.navClone[idx].navAuthNmSeq)){
			return false;
		}else if(this.navList[idx].navShowYn !== this.navClone[idx].navShowYn){
			return false;
		}else{
			return true;	
		}
	}
	
}

let side = {
	sideList : new Array(),
	sideClone : new Array(),
	navSeq : "",
	navUrl : "",
	firstIdx : 0,
	lastIdx : 0,
	
	init : function(sideList, authList){		
    	this.sideList = sideList;
    	this.authList = authList;
    	this.sideClone = common.clone(this.sideList);
    	return this;
	},
	
	add : function(){console.log(this.navSeq);
		if(emptyCheck.isNotEmpty(this.navSeq)){
			if(this.sideList.length === 0){
				this.sideList.push({navSeq : this.navSeq, sideUrl : '', sideAuthNmSeq : '', sideNm : '', sideShowYn : 'Y', sideOrder : 1, state: 'insert'});
			}else{
				this.sideList.push({navSeq : this.navSeq, sideUrl : '', sideAuthNmSeq : '', sideNm : '', sideShowYn : 'Y', sideOrder : (this.sideList[this.sideList.length-1].sideOrder+1), state: 'insert'});	
			}
		}				
		return this;
	},
	
	del : function(idx){		
		this.sideList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.sideList = common.clone(this.sideClone);		
		return this;
	},
	
	view : function(navSeq, navUrl){
		if(emptyCheck.isNotEmpty(navSeq)){
			this.navSeq = navSeq;
			this.navUrl = navUrl;
		}
	
		$("#sideList").empty();		
		let tag = "";
		
		if(window.innerWidth > common.platformSize){
	
			tag += "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";			
			tag += "<th colspan='2'>순서</th>";		
			tag	+= "<th>하단메뉴 이름/URL</th>";
			tag	+= "<th>권한</th>";
			tag	+= "<th>표시</th>";
			tag	+= "<th>순서설정</th>";
			tag += "</tr>";
			
			this.lastIdx = 0;
			let sideView = {cnt:0, idxList : new Array()};
			let addAttr = {chked:"", cls:"", read:""};
			
			if(this.sideList.length === 0){
				tag += "<tr><td colspan='7'>no data</td></tr>";
				tag +="</table>";
				$("#sideList").append(tag);
			}else{
				for(let i=0; i<this.sideList.length; i++){
					
					//navSeq 일치하는 것만 view하는 조건문
					if(this.sideList[i].navSeq === this.navSeq){ 
					
						if(this.sideList[i].state === "insert"){
							addAttr = {chked:"", cls:"insert", read:""};			
						}else if(this.sideList[i].state === "delete"){				
							addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
						}else if(this.sideList[i].state === "update"){
							addAttr = {chked:"", cls:"update", read:""};
						}else{
							addAttr = {chked:"", cls:"", read:""};
						}
						
						this.sideList[i].sideShowYn === "N" ? useCls = "btn-outline-danger" : useCls = "";
						
						tag += "<tr>";			
						tag += "<td><input id='sideDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
						tag += "<td>"+(i+1)+"</td>";
						tag += "<td><input id='sideNm_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideNm+"'>";					
						tag += "<div class='input-group input-group-sm'><div class='input-group-prepend'><span class='input-group-text'>";
						tag += this.navUrl+"</span></div><input id='sideUrl_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideUrl+"'></div></td>";
						tag += "<td><select id='sideAuthNmSeq_"+i+"' class='custom-select custom-select-sm slt-fs "+addAttr.cls+"'>";
						tag += "<option value=''>선택</option>";			
						for(let j=0; j<this.authList.length; j++){
							String(this.sideList[i].sideAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
							tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
						}	
						tag += "</select></td>";
						tag += "<td><input id='sideShowYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs "+useCls+"' "+addAttr.read+" value='"+this.sideList[i].sideShowYn+"'></td>";
						if(this.sideList[i].state !== "insert"){
							tag += "<td><button id='sideUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>위로</button><button id='sideDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs'>아래</button></td>";
							this.lastIdx++;
						}else{
							tag += "<td><button id='sideUp_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>위로</button><button id='sideDown_"+i+"' class='btn btn-secondary btn-sm btn-sm-fs' disabled>아래</button></td>";
						}
						
						tag += "</tr>";						
						sideView.cnt ++;
						sideView.idxList.push(i);
					}
				}
				
				//해당 게시물이 0개일경우 NoData
				if(sideView.cnt === 0){
					tag += "<tr><td colspan='7'>하단메뉴 리스트가 없습니다.</td></tr>";				
				}
				tag +="</table>";
				$("#sideList").append(tag);
				if(this.sideClone.length === 1){
					$("#sideList #sideUp_"+sideView.idxList[0]).prop("disabled", true);
					$("#sideList #sideDown_"+sideView.idxList[0]).prop("disabled", true);
				}else{
					$("#sideList #sideUp_"+sideView.idxList[0]).prop("disabled", true);
					$("#sideList #sideDown_"+sideView.idxList[sideView.idxList.length-1]).prop("disabled", true);
				}				
				this.firstIdx = sideView.idxList[0];
			}
		}else{
			tag += "<table class='table table-striped table-sm table-bordered'>";			
			
			this.lastIdx = 0;
			let sideView = {cnt:0, idxList : new Array()};
			let addAttr = {chked:"", cls:"", read:""};
			
			if(this.sideList.length === 0){
				tag += "<tr><td colspan='2'>no data</td></tr>";
				tag +="</table>";
				$("#sideList").append(tag);
			}else{
				for(let i=0; i<this.sideList.length; i++){
					
					//navSeq 일치하는 것만 view하는 조건문
					if(this.sideList[i].navSeq === this.navSeq){ 
					
						if(this.sideList[i].state === "insert"){
							addAttr = {chked:"", cls:"insert", read:""};			
						}else if(this.sideList[i].state === "delete"){				
							addAttr = {chked:"checked='checked'", cls:"delete", read:"readonly='readonly'"};
						}else if(this.sideList[i].state === "update"){
							addAttr = {chked:"", cls:"update", read:""};
						}else{
							addAttr = {chked:"", cls:"", read:""};
						}
						
						this.sideList[i].sideShowYn === "N" ? useCls = "btn-outline-danger" : useCls = "";
						
						tag += "<tr><th colspan='2'>순서</th>";					
						tag += "<th style='width: 60px;'>입력사항</th>";
						tag += "<th>입력내용</th>";
						tag += "<tr>";
						
						tag += "<tr><td rowspan='5'><input id='sideDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
						tag += "<td rowspan='5'>"+(i+1)+"</td></tr>";
						
						tag	+= "<tr><th>하단메뉴 이름</th>";
						tag += "<td><input id='sideNm_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideNm+"'></td></tr>";
						
						tag	+= "<tr><th>URL</th>";
						tag += "<td><div class='input-group'><div class='input-group-prepend'><span class='input-group-text'>";
						tag += this.navUrl+"</span></div><input id='sideUrl_"+i+"' type='text' class='form-control form-control-sm "+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideUrl+"'></div></td></tr>";
						
						tag	+= "<tr><th>권한</th>";
						tag += "<td><select id='sideAuthNmSeq_"+i+"' class='custom-select custom-select-sm slt-fs "+addAttr.cls+"'>";
						tag += "<option value=''>선택</option>";			
						for(let j=0; j<this.authList.length; j++){
							String(this.sideList[i].sideAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
							tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
						}	
						tag += "</select></td></tr>";
						
						tag	+= "<tr><th>표시</th>";
						tag += "<td><input id='sideShowYn_"+i+"' type='button' class='btn btn-outline-secondary btn-sm btn-sm-fs "+useCls+"' "+addAttr.read+" value='"+this.sideList[i].sideShowYn+"'></td></tr>";
						tag += "<tr style='height:5px;'></tr>";
						
						sideView.cnt ++;
						sideView.idxList.push(i);
					}
				}
				
				//해당 게시물이 0개일경우 NoData
				if(sideView.cnt === 0){
					tag += "<tr><td colspan='2'>하단메뉴 리스트가 없습니다.</td></tr>";				
				}
				tag +="</table>";
				$("#sideList").append(tag);								
				this.firstIdx = sideView.idxList[0];
			}
			
			if(sideView.cnt !== 0){
				document.getElementById('sideMenuWidth').scrollIntoView(true);
			}
		}		
		return this;
	},
	
	change : function(idx, isUpDown){
		let temp = null;
		let navSeq = this.sideList[idx].navSeq;
		
		switch(isUpDown){
		case "up" :
			if(idx <= 0){				
				return this;
			}else{
				
				let upIdx = 1;				
				while(true){					
					if(navSeq !== this.sideList[idx-upIdx].navSeq){
						upIdx++;
					}else{
						break;
					}
				}
				
				temp = this.sideList[idx].sideOrder;
				this.sideList[idx].sideOrder = this.sideList[idx-upIdx].sideOrder;
				this.sideList[idx-upIdx].sideOrder = temp;
				
				temp = common.clone(this.sideList[idx]);				
				this.sideList[idx] = common.clone(this.sideList[idx-upIdx]);
				this.sideList[idx-upIdx] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.sideList.length-1)){
				return this;
			}else{
				
				let downIdx = 1;				
				while(true){					
					if(navSeq !== this.sideList[idx+downIdx].navSeq){
						downIdx++;
					}else{
						break;
					}
				}
				
				temp = this.sideList[idx].sideOrder;
				this.sideList[idx].sideOrder = this.sideList[idx+downIdx].sideOrder;
				this.sideList[idx+downIdx].sideOrder = temp;
				
				temp = this.sideList[idx];
				this.sideList[idx] = this.sideList[idx+downIdx];
				this.sideList[idx+downIdx] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){			
		
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		let navSeq = this.sideList[idx].navSeq;
		
		switch(name){
		
		case "sideDel":
			if(this.sideList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#sideNm_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				$("#sideNavUrl_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				$("#sideUrl_"+idx).removeClass("update").addClass("delete").prop("readOnly", true);
				$("#sideAuthNmSeq_"+idx).removeClass("update").addClass("delete").prop("disabled", true);
				$("#sideShowYn_"+idx).prop("disabled", true);
				this.sideList[idx].state = "delete";
			}else{				
				$("#sideNm_"+idx).removeClass("delete").prop("readOnly", false);
				$("#sideNavUrl_"+idx).removeClass("delete").prop("readOnly", false);
				$("#sideUrl_"+idx).removeClass("delete").prop("readOnly", false);
				$("#sideAuthNmSeq_"+idx).removeClass("delete").prop("disabled", false);
				$("#sideShowYn_"+idx).prop("disabled", false);
				if(idx !== this.firstIdx) $("#sideUp_"+idx).prop("disabled", false);				
				if(idx !== this.lastIdx-1) $("#sideDown_"+idx).prop("disabled", false);
				this.sideList[idx].state = "select";
			}
			break;
		case "sideUp" :			
			let upIdx = 1;				
			while(true){					
				if(navSeq !== this.sideList[idx-upIdx].navSeq){
					upIdx++;
				}else{
					break;
				}
			}			
			syncFunc(this, idx-upIdx);
			break;
		case "sideDown" :
			let downIdx = 1;				
			while(true){					
				if(navSeq !== this.sideList[idx+downIdx].navSeq){
					downIdx++;
				}else{
					break;
				}
			}
			syncFunc(this, idx+downIdx);			
			break;
		case "sideShowYn" :
			if(target.value === "Y"){
				this.sideList[idx][name] = "N";
				$(target).val("N").addClass("btn-outline-danger");
			}else if(target.value === "N"){
				this.sideList[idx][name] = "Y";
				$(target).val("Y").removeClass("btn-outline-danger");
			}
			break;	
		default :
			this.sideList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){			
			switch(obj.sideList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.sideList[idx].state = "update";			
					$("#sideNm_"+idx).addClass("update").prop("readOnly", false);
					$("#sideNavUrl_"+idx).addClass("update").prop("readOnly", false);
					$("#sideUrl_"+idx).addClass("update").prop("readOnly", false);
					$("#sideAuthNmSeq_"+idx).addClass("update").prop("readOnly", false);
				}else{
					$(target).is(":checked") === true ? obj.sideList[idx].state = "delete" : obj.sideList[idx].state = "select";					
					$("#sideNm_"+idx).removeClass("update");
					$("#sideNavUrl_"+idx).removeClass("update");
					$("#sideUrl_"+idx).removeClass("update");
					$("#sideAuthNmSeq_"+idx).removeClass("update");					
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		
		for(let i=0; i<this.sideList.length; i++){
			
			// 빈값, null 체크
			if(this.sideList[i].sideNm === '' || this.sideList[i].sideNm === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL이름이 입력되지 않았습니다."};
				break;
			}else if(this.sideList[i].sideUrl === '' || this.sideList[i].sideUrl === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL이 입력되지 않았습니다."};
				break;
			}else if(String(this.sideList[i].sideAuthNmSeq) === '' || String(this.sideList[i].sideAuthNmSeq) === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL 권한이 선택되지 않았습니다."};
				break;
			}
			
			if(this.sideList[i].state === "select") saveChk++;
			
		}
		
		if(this.sideList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.sideList.length; i++){		
			
			if(this.sideList[i].state === "insert"){
				inList.push(this.sideList[i]);
			}else if(this.sideList[i].state === "update"){
				upList.push(this.sideList[i]);
			}else if(this.sideList[i].state === "delete"){
				delList.push(this.sideList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("변경한 사이드URL을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/inUpDelSideMenuList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	alert(data.inCnt+" 개의 메뉴가 입력, "+data.upCnt+" 개의 메뉴가 수정, "+ data.delCnt+" 개의 메뉴가 삭제되었습니다");
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});
	},
	
	equals : function(idx){
		
		if(this.sideList[idx].sideNm !== this.sideClone[idx].sideNm){
			return false;
		}else if(this.sideList[idx].sideUrl !== this.sideClone[idx].sideUrl){
			return false;
		}else if(this.sideList[idx].sideAuthNmSeq !== this.sideClone[idx].sideAuthNmSeq){
			return false;
		}else if(this.sideList[idx].sideShowYn !== this.sideClone[idx].sideShowYn){
			return false;
		}else{
			return true;
		}
	}
}
</script>
<div class="article">
	
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">메뉴설정</h1>
	</div>

	<div id="navMenuWidth" class="width-half">
		<h6 class="nsrb">상위메뉴</h6>
		<div class="btn-group" role="group">	
			<button id="navAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="navSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">네비메뉴 저장</button>
			<button id="navCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="navList"></div>	
	</div>	
	
	<div id="sideMenuWidth" class="width-half">
		<h6 class="nsrb">하위메뉴</h6>
		<div class="btn-group" role="group">	
			<button id="sideAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="sideSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">하단메뉴 저장</button>
			<button id="sideCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="sideList"></div>
	</div>
</div>