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
			if(this.mode === "select")
				tag	+= "<th><input type='checkbox' onchange='rec.chkAll()'></th>";
			tag	+= "<th>recordSeq</th>";
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
			if(this.mode === "select")
				tag += "<td><input type='checkbox' onchange='rec.chk()'></td>";
			tag += "<td>"+this.recList[i].recordSeq+"</td>";
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
	chkAll : function(){
		alert("chkAll");
	},
	chk : function(){
		alert("chk");
	}
}