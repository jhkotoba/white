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
			
		for(let i=0; i<this.purList.length; i++){
			tag += "<tr>";			
			tag += "<td><input id='purDel_"+i+"' type='checkbox' onchange='pur.sync(this)' title='삭제 체크박스'></td>";
			tag += "<td>"+this.purList[i].purOrder+"</td>";
			tag += "<td><input id='purpose_"+i+"' type='text' class='font10' value='"+this.purList[i].purpose
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
				this.purList[idx].state = "select";				;
				$("#purpose_"+idx).removeClass("redLine").prop("readOnly", false);
			}
		}else{			
			this.purList[idx][name] = String(target.value);
		}
		
		if($(target).is(":checked") === false && this.equals(idx) === false){
			this.purList[idx].state = "update";			
			$("#purpose_"+idx).addClass("edit").prop("readOnly", false);
		}else{			
			$(target).is(":checked") === true ? this.purList[idx].state = "delete" : this.purList[idx].state = "select";			
			$("#purpose_"+idx).removeClass("edit");
		}
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
		if(purSeq !== ""){
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
		
		if($(target).is(":checked") === false && this.equals(idx) === false){
			this.purDtlList[idx].state = "update";			
			$("#purDetail_"+idx).addClass("edit").prop("readOnly", false);
		}else{			
			$(target).is(":checked") === true ? this.purDtlList[idx].state = "delete" : this.purDtlList[idx].state = "select";			
			$("#purDetail_"+idx).removeClass("edit");
		}
	},
	
	equals : function(idx){
		
		if(this.purDtlList[idx].purDetail !== this.purDtlClone[idx].purDetail){
			return false;
		}else{
			return true;	
		}
	}
}