/**
 * auth.js
 */

$(document).ready(function(){
	$('#authList').on("change keyup input", function(event) {
		auth.sync(event.target);
	});
	
	$('#authList').on("click", function(event) {
		auth.sync(event.target);
	});
});

let auth = {
	authList : new Array(),
	authClone : new Array(),		
	
	init : function(authList){		
    	this.authList = authList;
    	this.authClone = common.clone(this.authList);   
    	return this;
	},
	
	add : function(){
		this.authList.push({authNmSeq: '', authNm: '', state: 'insert'});		
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
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		let useCls = "";
		
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
			
			this.authList[i].authNowUseYn === "Y" ? useCls = "btn_azure01" : useCls = "btn_pink01";
						
			tag += "<tr>";			
			tag += "<td><input id='delete_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
			tag += "<td>"+(i+1)+"</td>";
			tag += "<td><input id='authNm_"+i+"' type='text' class='"+addAttr.cls+"' "+addAttr.read+" value='"+this.authList[i].authNm+"' ></td>";
			tag += "</tr>";	
		}			
		tag +="</table>";
		$("#authList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "delete"){
			
			if(this.authList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.authList[idx].state = "delete";				
				$("#authNm_"+idx).addClass("redLine").prop("readOnly", true);			
			}else{
				this.authList[idx].state = "select";
				$("#authNm_"+idx).removeClass("redLine").prop("readOnly", false);				
			}
		}else{			
			this.authList[idx][name] = String(target.value);
		}
		
		
		if(this.authList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.authList[idx].state = "update";			
				$("#authNm_"+idx).addClass("edit").prop("readOnly", false);				
			}else{
				if(this.authList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.authList[idx].state = "delete" : this.authList[idx].state = "select";			
					$("#authNm_"+idx).removeClass("edit");					
				}
			}
		}
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
		alert("test");
		return;
		/*$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/inUpDelauthList.ajax',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="authUsed"){
		    		alert("삭제-사용되는 은행이 존재하여 실패.");
		    	}
		    	white.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});*/	
	},
	
	equals : function(idx){
		
		if(this.authList[idx].authNm !== this.authClone[idx].authNm){
			return false;		
		}else{
			return true;	
		}
	}
	
}