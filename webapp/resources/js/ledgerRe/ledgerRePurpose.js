/**
 * ledgerRePurpose.js
 */

let pur = {
	purList : new Array(),
	purClone : new Array(),
	purDtlList : new Array(),
	purDtlClone : new Array(),
	selectPur : "",
	
	init : function(purList, purDtlList){		
    	this.purList = purList;
		this.purDtlList = purDtlList;		
    	return this;
	},
	
	view : function(){
		
		$("#purView").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag	+= "<th>No</th>";
			tag	+= "<th>purpose</th>";
			tag	+= "<th>mod/del</th>";			
			tag += "</tr>";
			
		for(let i=0; i<this.purList.length; i++){
			
		}
			
		tag +="</table>";
		$("#purList").append(tag);
		
		tag = "";
		$("#purDtlList").empty();
		
		tag += "<table border=1>";
		tag	+= "<tr>";			
		tag	+= "<th>No</th>";
		tag	+= "<th>purDtl</th>";
		tag	+= "<th>mod/del</th>";			
		tag += "</tr>";
		
		tag +="</table>";
		$("#purDtlList").append(tag);
	}
		
}