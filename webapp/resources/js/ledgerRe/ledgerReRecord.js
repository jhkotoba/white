/**
 * ledgerReRecord.js
 */

let rec = {
	recList : new Array(),
	recClone : new Array(),
	bankList : new Array(),
	init : function(recList, bankList, mode){
    	this.recList = recList;
    	if(mode !== "main"){
    		this.recClone = common.clone(this.recList);
    	}else{
    		this.recClone = null;
    	}
    	this.bankList = bankList;
    	return this;
	},
	destroy : function(){
		this.recList = new Array();
		this.recClone = new Array();
		this.bankList = new Array();
		$("#ledgerReList").empty();
	},
	view : function(){
		
		$("#ledgerReList").empty();
		
		let tag = "<table border=1>"
				+ "<tr>"
				+ "<th>recordSeq</th>"
				+ "<th>recordDate</th>"
				+ "<th>content</th>"
				+ "<th>purpose</th>"
				+ "<th>purDetail</th>"
				+ "<th>bankName</th>"
				+ "<th>money</th>"				
				+ "<th>amount</th>"
				+ "<th>cash</th>";
				for(let i=0; i<this.bankList.length; i++){
					tag += "<th>"+this.bankList[i].bankName+"("+(this.bankList[i].bankAccount==="cash" ? "":this.bankList[i].bankAccount) +")</th>";
				}	
			tag += "<tr>";		
		
		for(let i=this.recList.length-1; i>=0; i--){
			
			tag += "<tr>";
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
	}	
}