/**
 * ledgerReRecord.js
 */

let rec = {
	recList : new Array(),
	recClone : new Array(),
	purList : new Array(),
	purDtlList : new Array(),
	bankList : new Array(),
	mode : "main",
	
	init : function(mode, recList, purList, purDtlList, bankList){
    	this.recList = recList;
    	this.mode = mode;
    	if(this.mode === "main"){
    		this.recClone = null;    		
    	}else{
    		this.recClone = common.clone(this.recList);    		
    	}
    	this.purList = JSON.parse(purList);
		this.purDtlList = JSON.parse(purDtlList);
		this.bankList = JSON.parse(bankList);
    	return this;
	},
	destroy : function(){
		this.recList = new Array();
		this.recClone = new Array();
		this.purList = new Array();
		this.purDtlList = new Array();
		this.bankList = new Array();
		$("#ledgerReList").empty();
	},
	view : function(){		
		$("#ledgerReList").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag	+= "<th>recordDate</th>";
			tag	+= "<th>content</th>";
			tag	+= "<th>purpose</th>";
			tag	+= "<th>purDetail</th>";
			tag	+= "<th>bankName</th>";
			tag	+= "<th>money</th>";			
			tag	+= "<th>amount</th>";
			tag	+= "<th>cash</th>";
				for(let i=0; i<this.bankList.length; i++){
					tag += "<th>"+this.bankList[i].bankName+"("+(this.bankList[i].bankAccount==="cash" ? "":this.bankList[i].bankAccount) +")</th>";
				}	
			tag += "<tr>";		
		
		for(let i=this.recList.length-1; i>=0; i--){
			
			tag += "<tr>";			
			tag += "<td>"+this.recList[i].recordDate+"</td>";
			tag += "<td>"+this.recList[i].content+"</td>";
			tag += "<td>"+this.recList[i].purpose+"</td>";
			tag += "<td>"+this.recList[i].purDetail+"</td>";
			tag += "<td>"+this.recList[i].bankName+"</td>";
			tag += "<td>"+this.recList[i].money+"</td>";			
			tag += "<td>"+this.recList[i].amount+"</td>";
			tag += "<td>"+this.recList[i].cash+"</td>";
			
			for(let j=0; j<this.bankList.length; j++){
				tag += "<td>"+this.recList[i]["bank"+j]+"</td>";
			}		
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#ledgerReList").append(tag);
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];
		
		this.recList[idx][name] = String(target.value);
		if(type === "Number"){
			if(target.value === ''){
				this.recList[idx][name] = String(target.value);		
			}else{
				this.recList[idx][name] = Number(target.value);		
			}
			
		}else if( type === "String"){
			if(name === "date"){
				this.recList[idx].recordDate = String(target.value) + " " + this.recList[idx].recordDate.split(' ')[1];
			}else if( name === "time"){
				this.recList[idx].recordDate = this.recList[idx].recordDate.split(' ')[0] + " " + String(target.value);
			}else{
				this.recList[idx][name] = String(target.value);
			}		
		}
		
	},
	
	edit : function(){
		$("#ledgerReList").empty();
		let selected = "";
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag	+= "<th>date</th>";
			tag	+= "<th>time</th>";
			tag	+= "<th>content</th>";
			tag	+= "<th>purpose</th>";
			tag	+= "<th>purDetail</th>";
			tag	+= "<th>bankName</th>";
			tag	+= "<th>money</th>";
			tag += "</tr>";		
		
		for(let i=this.recList.length-1; i>=0; i--){
			
			tag += "<tr>";			
			tag += "<td><input id='date_"+i+"' type='date'  value='"+this.recList[i].recordDate.split(' ')[0]+"' onkeyup='rec.sync(this, \"String\")'></td>";
			tag += "<td><input id='time_"+i+"' type='time' value='"+this.recList[i].recordDate.split(' ')[1]+"' onkeyup='rec.sync(this, \"String\")'></td>";
			tag += "<td><input id='content_"+i+"' type='text' value='"+this.recList[i].content+"' onkeyup='rec.sync(this, \"String\")'></td>";
			tag += "<td><select id='purSeq_"+i+"' onchange='rec.sync(this, \"Number\")'; rec.appSel(this,"+i+");'>";			
			tag += "<option value=0>금액이동</option>";			
			for(let j=0; j<this.purList.length; j++){
				this.recList[i].purSeq === this.purList[j].purSeq ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value="+this.purList[j].purSeq+">"+this.purList[j].purpose+"</option>";
			}	
			tag += "</select></td>";
			tag += "<td><select id='purDtlSeq_"+i+"' onchange='rec.sync(this, \'Number\');'>";
			tag += "<option value=''>선택</option>";
			for(let j=0; j<this.purDtlList.length; j++){
				if(this.recList[i].purSeq === this.purDtlList[j].purSeq){
					this.recList[i].purDtlSeq === this.purDtlList[j].purDtlSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
				}
			}	
			tag += "</select></td>";
			tag += "<td><select id='bankSeq_"+i+"' onchange='rec.sync(this, \"Number\");'>";
			tag += "<option "+(this.recList[i].bankSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
			for(let j=0; j<this.bankList.length; j++){
				this.recList[i].bankSeq === this.bankList[j].bankSeq ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
			}	
			tag += "<td><input type='text' value='"+this.recList[i].money+"' onkeyup='rec.sync(this, \"String\")'></td>";			
			tag += "</tr>";
			
			delete this.recList[i].bankAccount;
		}
		
		tag +="</table>";
		$("#ledgerReList").append(tag);
	},
	cancel : function(){		
		this.recList = common.clone(this.recClone);
		this.view();
	}
}