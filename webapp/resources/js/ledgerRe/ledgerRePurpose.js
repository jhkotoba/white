/**
 * ledgerRePurpose.js
 */

let pur = {
	purList : new Array(),
	purClone : new Array(),
	purDtlList : new Array(),
	purDtlClone : new Array(),
	
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
			
		tag +="</table>";
		$("#purView").append(tag);
		
		tag = "";
		$("#purDtlView").empty();
		
		tag += "<table border=1>";
		tag	+= "<tr>";			
		tag	+= "<th>No</th>";
		tag	+= "<th>purDtl</th>";
		tag	+= "<th>mod/del</th>";			
		tag += "</tr>";
		
		tag +="</table>";
		$("#purDtlView").append(tag);
	}
		
}