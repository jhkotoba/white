/**
 * ledgerRePurpose.js
 */

$(document).ready(function(){
	$('#headList').on("change keyup input", function(event) {
		head.sync(event.target);
	});
	
	$('#headList').on("click", function(event) {
		head.sync(event.target);
	});
	
	$('#sideList').on("change keyup input", function(event) {
		side.sync(event.target);
	});	
});

let head = {
	headList : new Array(),
	headClone : new Array(),		
	
	init : function(headList){		
    	this.headList = headList;
    	this.headClone = common.clone(this.headList);
    	return this;
	},
	
	add : function(){
		this.headList.push({headOrder: (this.headList.length+1), purpose: '', state: 'insert'});		
		return this;
	},
	
	del : function(idx){		
		this.headList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.headList = common.clone(this.headClone);		
		return this;
	},
	
	view : function(){
		
		$("#headList").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";			
			tag	+= "<th>headMenuName</th>";
			tag	+= "<th>headMenuUrl</th>";
			tag	+= "<th>auth</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		for(let i=0; i<this.headList.length; i++){			
			
			if(this.headList[i].state === "insert"){
				addAttr = {chked:"", cls:"add", read:""};			
			}else if(this.headList[i].state === "delete"){				
				addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
			}else if(this.headList[i].state === "update"){
				addAttr = {chked:"", cls:"edit", read:""};
			}else{
				addAttr = {chked:"", cls:"", read:""};
			}
			
			tag += "<tr>";			
			tag += "<td><input id='headDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
			tag += "<td>"+this.headList[i].headOrder+"</td>";
			tag += "<td><input id='headNm_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.headList[i].headNm
				+"' onclick='side.view("+this.headList[i].headSeq+",\""+this.headList[i].headNm+"\")'></td>";
			tag += "<td><input id='headUrl_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.headList[i].headUrl
				+"' onclick='side.view("+this.headList[i].headSeq+",\""+this.headList[i].headNm+"\")'></td>";
			tag += "<td>"+this.headList[i].authNmSeq+"</td>";
			tag += "</tr>";			
		}			
		tag +="</table>";
		$("#headList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "headDel"){
			
			if(this.headList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.headList[idx].state = "delete";				
				$("#purpose_"+idx).addClass("redLine").prop("readOnly", true);
			}else{
				this.headList[idx].state = "select";
				$("#purpose_"+idx).removeClass("redLine").prop("readOnly", false);
			}
		}else{			
			this.headList[idx][name] = String(target.value);
		}
		
		if(this.headList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.headList[idx].state = "update";			
				$("#purpose_"+idx).addClass("edit").prop("readOnly", false);
			}else{
				if(this.headList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.headList[idx].state = "delete" : this.headList[idx].state = "select";			
					$("#purpose_"+idx).removeClass("edit");
				}
			}
		}
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.headList.length; i++){
			
			// 빈값, null 체크
			if(this.headList[i].purpose === '' || this.headList[i].purpose === null){
				check = {check : false, msg : (i+1) + "행의 목적이 입력되지 않았습니다."};
				break;
			}
			
			if(this.headList[i].state === "select") saveChk++;
		}

		if(this.headList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.headList.length; i++){		
			
			if(this.headList[i].state === "insert"){
				inList.push(this.headList[i]);
			}else if(this.headList[i].state === "update"){
				upList.push(this.headList[i]);
			}else if(this.headList[i].state === "delete"){
				delList.push(this.headList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
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
		
		if(this.headList[idx].purpose !== this.headClone[idx].purpose){
			return false;
		}else{
			return true;	
		}
	}
	
}

let side = {
		sideList : new Array(),
		sideClone : new Array(),
		headSeq : "",
	purpose : "",
	
	init : function(sideList){		
		this.sideList = sideList;
		this.sideClone = common.clone(this.sideList);    
    	return this;
	},
	
	add : function(){
		if(this.headSeq === ""){
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
	
	view : function(headSeq, purpose){
		if(emptyCheck.isNotEmpty(headSeq)){
			this.headSeq = headSeq;
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
			if(this.sideList[i].headSeq === this.headSeq){
				
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