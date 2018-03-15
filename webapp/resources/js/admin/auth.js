/**
 * auth.js
 */

$(document).ready(function(){
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
			this.authList.push({authNmSeq: '', authNm: '', authOrder : 1, state: 'insert'});
		}else{
			this.authList.push({authNmSeq: '', authNm: '', authOrder : (this.authList[this.authList.length-1].authOrder+1), state: 'insert'});
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
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>authNm</th>";
			tag	+= "<th>move</th>";
			tag += "</tr>";
		
		this.lastIdx = 0;
		let addAttr = {chked:"", cls:"", read:""};
		
		if(authList.length === 0){
			tag += "<tr><td colspan='4'>no data</td></tr>";
			tag +="</table>";
			$("#authList").append(tag);
		}else{
			for(let i=0; i<this.authList.length; i++){			
				
				if(this.authList[i].state === "insert"){
					addAttr = {chked:"", cls:"add", read:""};			
				}else if(this.authList[i].state === "delete"){				
					addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
				}else if(this.authList[i].state === "update"){
					addAttr = {chked:"", cls:"edit", read:""};
				}else{
					addAttr = {chked:"", cls:"", read:""};
				}
							
				tag += "<tr>";			
				tag += "<td><input id='authDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
				tag += "<td>"+(i+1)+"</td>";
				tag += "<td><input id='authNm_"+i+"' type='text' class='"+addAttr.cls+"' "+addAttr.read+" value='"+this.authList[i].authNm+"' ></td>";
				if(this.authList[i].state !== "insert"){
					tag += "<td><button id='authUp_"+i+"' class='btn_azure02'>위로</button><button id='authDown_"+i+"' class='btn_azure02'>아래</button></td>";
					this.lastIdx++;
				}else{
					tag += "<td><button id='authUp_"+i+"' class='btn_disabled02' disabled'>위로</button><button id='authDown_"+i+"' class='btn_disabled02' disabled>아래</button></td>";
				}
				tag += "</tr>";	
			}			
			tag +="</table>";
			$("#authList").append(tag);
			
			//게시물이 1개일경우 순서버튼 막기
			$("#authList #authUp_0").removeClass().addClass("btn_disabled02").prop("disabled", true);
			if(this.authList.length === 1){				
				$("#authList #authDown_0").removeClass().addClass("btn_disabled02").prop("disabled", true);
			}else{				
				$("#authList #authDown_"+String(this.lastIdx-1)).removeClass().addClass("btn_disabled02").prop("disabled", true);
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
				$("#authNm_"+idx).removeClass().addClass("redLine").prop("readOnly", true);				
				this.authList[idx].state = "delete";
			}else{				
				$("#authNm_"+idx).removeClass().prop("readOnly", false);				
				if(idx !== 0) $("#authUp_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);			
				if(idx !== this.lastIdx-1) $("#authDown_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);
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
					$("#authNm_"+idx).addClass("edit").prop("readOnly", false);					
				}else{
					$(target).is(":checked") === true ? obj.authList[idx].state = "delete" : obj.authList[idx].state = "select";					
					$("#authNm_"+idx).removeClass();			
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
		    	white.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});
	},
	
	equals : function(idx){
		
		if(this.authList[idx].authNm !== this.authClone[idx].authNm){
			return false;		
		}else{
			return true;	
		}
	}
	
}