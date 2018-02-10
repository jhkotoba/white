/**
 * ledgerRePurpose.js
 */

let pur = {
	purList : new Array(),
	purClone : new Array(),		
	
	init : function(purList){		
    	this.purList = purList;
    	this.purClone = common.clone(this.purList);   
    	return this;
	},
	
	add : function(){
		this.purList.push({purOrder: (this.purList.length+1), purpose: '', state: 'insert'});		
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
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>purpose</th>";
			tag += "</tr>";
			
		let addCls = "";
		let delChk = "";
		let readonly = "";
		
		let addAttr = {chked:"", cls:"", read:""};
		for(let i=0; i<this.purList.length; i++){			
			
			if(this.purList[i].state === "insert"){
				addAttr = {chked:"", cls:"add", read:""};			
			}else if(this.purList[i].state === "delete"){				
				addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
			}else if(this.purList[i].state === "update"){
				addAttr = {chked:"", cls:"edit", read:""};
			}else{
				addAttr = {chked:"", cls:"", read:""};
			}
						
			tag += "<tr>";			
			tag += "<td><input id='purDel_"+i+"' type='checkbox' "+addAttr.chked+" onchange='pur.sync(this)' title='삭제 체크박스'></td>";
			tag += "<td>"+this.purList[i].purOrder+"</td>";
			tag += "<td><input id='purpose_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.purList[i].purpose
				+"' onkeyup='pur.sync(this)' onclick='purDtl.view("+this.purList[i].purSeq+",\""+this.purList[i].purpose+"\")'></td>";
			tag += "</tr>";	
		}			
		tag +="</table>";
		$("#purList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "purDel"){
			
			if(this.purList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.purList[idx].state = "delete";				
				$("#purpose_"+idx).addClass("redLine").prop("readOnly", true);
			}else{
				this.purList[idx].state = "select";
				$("#purpose_"+idx).removeClass("redLine").prop("readOnly", false);
			}
		}else{			
			this.purList[idx][name] = String(target.value);
		}
		
		if(this.purList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.purList[idx].state = "update";			
				$("#purpose_"+idx).addClass("edit").prop("readOnly", false);
			}else{
				if(this.purList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.purList[idx].state = "delete" : this.purList[idx].state = "select";			
					$("#purpose_"+idx).removeClass("edit");
				}
			}
		}
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
		    	sideSubmit("Purpose");
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
	
	init : function(purDtlList){		
		this.purDtlList = purDtlList;
		this.purDtlClone = common.clone(this.purDtlList);    
    	return this;
	},
	
	add : function(){
		this.purDtlList.push({purSeq: this.purSeq, purDtlOrder: (this.purDtlList.length+1), purDetail: '', state: 'insert'});
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
	
		let tag = "<table border=1>";
			tag	+= "<tr>";
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>"+ (emptyCheck.isEmpty(this.purpose)===true?"":this.purpose) +" Detailed Purpose</th>";
			tag += "</tr>";
		
		for(let i=0; i<this.purDtlList.length; i++){
			if(this.purDtlList[i].purSeq === this.purSeq){
				tag += "<tr>";		
				tag += "<td><input id='purDtlDel_"+i+"' type='checkbox' onchange='purDtl.sync(this)' title='삭제 체크박스'></td>";
				tag += "<td>"+this.purDtlList[i].purDtlOrder+"</td>";
				tag += "<td><input id='purDetail_"+i+"' type='text' class='font10' value='"+this.purDtlList[i].purDetail+"' onkeyup='purDtl.sync(this)'></td>";
				tag += "</tr>";
			}
		}	
		
		tag +="</table>";
		$("#purDtlList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];
			
		if(name === "purDtlDel"){
			
			if(this.purDtlList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}	
			
			if( $(target).is(":checked") === true ){				
				this.purDtlList[idx].state = "delete";				
				$("#purDetail_"+idx).addClass("redLine").prop("readOnly", true);
			}else{
				this.purDtlList[idx].state = "select";
				$("#purDetail_"+idx).removeClass("redLine").prop("readOnly", false);
			}
		}else{			
			this.purDtlList[idx][name] = String(target.value);
		}
		
		if(this.purList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.purDtlList[idx].state = "update";			
				$("#purDetail_"+idx).addClass("edit").prop("readOnly", false);
			}else{
				
				$(target).is(":checked") === true ? this.purDtlList[idx].state = "delete" : this.purDtlList[idx].state = "select";			
				$("#purDetail_"+idx).removeClass("edit");
				
			}
		}
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		
		for(let i=0; i<this.purDtlList.length; i++){
			
			// 빈값, null 체크
			if(this.purDtlList[i].purpose === '' || this.purDtlList[i].purpose === null){
				check = {check : false, msg : (i+1) + "행의 상세목적이 입력되지 않았습니다."};
				break;
			}
			
		}
		
		if(saveChk === false){
			check = {check : false, msg : (i+1) + "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		
	},
	
	equals : function(idx){
		
		if(this.purDtlList[idx].purDetail !== this.purDtlClone[idx].purDetail){
			return false;
		}else{
			return true;	
		}
	}
}