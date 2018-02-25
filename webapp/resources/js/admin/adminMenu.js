/**
 * adminMenu.js
 */

$(document).ready(function(){
	$('#navList').on("change keyup input", function(event) {
		nav.sync(event.target);
	});
	
	/*$('#navList').on("click", function(event) {
		nav.sync(event.target);
	});*/	
	
	$('#sideList').on("change keyup input", function(event) {
		side.sync(event.target);
	});	
});

let nav = {
	navList : new Array(),
	navClone : new Array(),
	authList : new Array(),
	
	init : function(navList, authList){		
    	this.navList = navList;
    	this.authList = authList;
    	this.navClone = common.clone(this.navList);
    	return this;
	},
	
	add : function(){
		this.navList.push({navUrl : '', authNmSeq : '', navNm : '', navOrder : (this.navList.length+1), state: 'insert'});		
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
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";			
			tag	+= "<th>navMenuName</th>";
			tag	+= "<th>navMenuUrl</th>";
			tag	+= "<th>auth</th>";
			tag	+= "<th>move</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		for(let i=0; i<this.navList.length; i++){			
			
			if(this.navList[i].state === "insert"){
				addAttr = {chked:"", cls:"add", read:""};			
			}else if(this.navList[i].state === "delete"){				
				addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
			}else if(this.navList[i].state === "update"){
				addAttr = {chked:"", cls:"edit", read:""};
			}else{
				addAttr = {chked:"", cls:"", read:""};
			}
			
			tag += "<tr>";			
			tag += "<td><input id='navDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
			tag += "<td>"+this.navList[i].navOrder+"</td>";
			tag += "<td><input id='navNm_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navNm
				+"' onclick='side.view("+this.navList[i].navSeq+",\""+this.navList[i].navNm+"\")'></td>";
			tag += "<td><input id='navUrl_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navUrl
				+"' onclick='side.view("+this.navList[i].navSeq+",\""+this.navList[i].navNm+"\")'></td>";
			tag += "<td><select id='authNmSeq_"+i+"' class='"+addAttr.cls+"'>";
			tag += "<option value=''>선택</option>";			
			for(let j=0; j<this.authList.length; j++){
				String(this.navList[i].authNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
			}	
			tag += "</select></td>";
			tag += "<td><button id='navUp_"+i+"' class='btn_azure02' onclick='nav.change();'>위로</button><button id='navDown_"+i+"' class='btn_azure02'>아래</button></td>";
			tag += "</tr>";			
		}			
		tag +="</table>";
		$("#navList").append(tag);
		
		return this;
	},
	
	change : function(){
		console.log("aaa");
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "navDel"){
			
			if(this.navList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.navList[idx].state = "delete";				
				$("#navNm_"+idx).addClass("redLine").prop("readOnly", true);
				$("#navUrl_"+idx).addClass("redLine").prop("readOnly", true);
				$("#authNmSeq_"+idx).addClass("redLine").prop("disabled", true);
				$("#navUp_"+idx).removeClass("btn_azure02").addClass("btn_disabled02").prop("disabled", true);
				$("#navDown_"+idx).removeClass("btn_azure02").addClass("btn_disabled02").prop("disabled", true);
			}else{
				this.navList[idx].state = "select";
				$("#navNm_"+idx).removeClass("redLine").prop("readOnly", false);
				$("#navUrl_"+idx).removeClass("redLine").prop("readOnly", false);
				$("#authNmSeq_"+idx).removeClass("redLine").prop("disabled", false);
				$("#navUp_"+idx).removeClass("btn_disabled02").addClass("btn_azure02").prop("disabled", false);
				$("#navDown_"+idx).removeClass("btn_disabled02").addClass("btn_azure02").prop("disabled", false);
			}
		}else{			
			this.navList[idx][name] = String(target.value);
		}
		
		if(this.navList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.navList[idx].state = "update";			
				$("#navNm_"+idx).addClass("edit").prop("readOnly", false);
				$("#navUrl_"+idx).addClass("edit").prop("readOnly", false);
				$("#authNmSeq_"+idx).addClass("edit").prop("readOnly", false);
			}else{
				if(this.navList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.navList[idx].state = "delete" : this.navList[idx].state = "select";			
					$("#navNm_"+idx).removeClass("edit");
					$("#navUrl_"+idx).removeClass("edit");
					$("#authNmSeq_"+idx).removeClass("edit");
				}
			}
		}
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
				
			}else if(this.navList[i].authNmSeq === '' || this.navList[i].authNmSeq === null){
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
		}return;
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/ajax/inUpDelPurList.do',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="purUsed"){
		    		alert("삭제-사용되는 purpose가 존재하여 실패.");
		    	}
		    	white.sideSubmit("ledgerRe", "Purpose");
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
		}else if(String(this.navList[idx].authNmSeq) !== String(this.navClone[idx].authNmSeq)){
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
	navNm : "",
	
	init : function(sideList){		
		this.sideList = sideList;
		this.sideClone = common.clone(this.sideList);    
    	return this;
	},
	
	add : function(){
		if(this.navSeq === ""){
			return this;
		}else{
			this.sideList.push({purSeq: this.purSeq, sideOrder: (this.sideList.length+1), purDetail: '', state: 'insert'});
			return this;
		}		
	},
	
	del : function(idx){		
		this.sideList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.sideList = common.clone(this.sideClone);		
		return this;
	},
	
	view : function(navSeq, purpose){
		if(emptyCheck.isNotEmpty(navSeq)){
			this.navSeq = navSeq;
			this.purpose = purpose;
		}
	
		$("#sideList").empty();
	
		let tag = "<table border=1>";
			tag	+= "<tr>";
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>"+ (emptyCheck.isEmpty(this.purpose)===true?"":this.purpose) +" Detailed Purpose</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		for(let i=0; i<this.sideList.length; i++){			
			if(this.sideList[i].navSeq === this.navSeq){
				
				if(this.sideList[i].state === "insert"){
					addAttr = {chked:"", cls:"add", read:""};			
				}else if(this.sideList[i].state === "delete"){				
					addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
				}else if(this.sideList[i].state === "update"){
					addAttr = {chked:"", cls:"edit", read:""};
				}else{
					addAttr = {chked:"", cls:"", read:""};
				}				
				
				tag += "<tr>";		
				tag += "<td><input id='sideDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
				tag += "<td>"+this.sideList[i].sideOrder+"</td>";
				tag += "<td><input id='purDetail_"+i+"' type='text' class='font10 "+addAttr.cls+"' value='"+this.sideList[i].purDetail+"' "+addAttr.read+"></td>";
				tag += "</tr>";
			}
		}	
		
		tag +="</table>";
		$("#sideList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];
			
		if(name === "sideDel"){
			
			if(this.sideList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}	
			
			if( $(target).is(":checked") === true ){				
				this.sideList[idx].state = "delete";				
				$("#purDetail_"+idx).addClass("redLine").prop("readOnly", true);
			}else{
				this.sideList[idx].state = "select";
				$("#purDetail_"+idx).removeClass("redLine").prop("readOnly", false);
			}
		}else{			
			this.sideList[idx][name] = String(target.value);
		}
		
		if(this.sideList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.sideList[idx].state = "update";			
				$("#purDetail_"+idx).addClass("edit").prop("readOnly", false);
			}else{
				
				$(target).is(":checked") === true ? this.sideList[idx].state = "delete" : this.sideList[idx].state = "select";			
				$("#purDetail_"+idx).removeClass("edit");
				
			}
		}
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		
		for(let i=0; i<this.sideList.length; i++){
			
			// 빈값, null 체크
			if(this.sideList[i].purDetail === '' || this.sideList[i].purDetail === null){
				check = {check : false, msg : (i+1) + "행의 상세목적이 입력되지 않았습니다."};
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
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/ajax/inUpDelPurDtlList.do',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="purDtlUsed"){
		    		alert("삭제-사용되는 상세목적이 존재하여 실패.");
		    	}
		    	white.sideSubmit("ledgerRe", "Purpose");
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});	
	},
	
	equals : function(idx){
		
		if(this.sideList[idx].purDetail !== this.sideClone[idx].purDetail){
			return false;
		}else{
			return true;	
		}
	}
}