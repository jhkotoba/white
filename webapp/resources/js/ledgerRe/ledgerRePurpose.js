/**
 * ledgerRePurpose.js
 */

let pur = {
	purList : new Array(),
	purClone : new Array(),
	purDtlList : new Array(),
	purDtlClone : new Array(),
	selPurSeq : "",
	
	init : function(purList, purDtlList){		
    	this.purList = purList;
		this.purDtlList = purDtlList;		
    	return this;
	},
	
	purView : function(){
		
		$("#purView").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>purpose</th>";
			tag += "</tr>";
			
		for(let i=0; i<this.purList.length; i++){
			tag += "<tr>";			
			tag += "<td><input id='purDel_"+i+"' type='checkbox' title='삭제 체크박스'></td>";
			tag += "<td>"+this.purList[i].purOrder+"</td>";
			tag += "<td><input id='purpose_"+i+"' name='purpose' type='text' class='font10' value='"+this.purList[i].purpose
				+"' onchange='pur.purSync(this)' onclick='pur.purDtlView("+this.purList[i].purSeq+")'></td>";
			tag += "</tr>";	
		}			
		tag +="</table>";
		$("#purList").append(tag);
		
		return this;
	},
	
	purDtlView : function(purSeq){
		if(purSeq !== ""){
			this.selPurSeq = purSeq;
		}		
	
		$("#purDtlList").empty();
	
		let tag = "<table border=1>";
			tag	+= "<tr>";
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>purDtl</th>";
			tag += "</tr>";
		
		for(let i=0; i<this.purDtlList.length; i++){
			if(this.purDtlList[i].purSeq === this.selPurSeq){
				tag += "<tr>";		
				tag += "<td><input id='purDtlDel_"+i+"' type='checkbox' title='삭제 체크박스'></td>";
				tag += "<td>"+this.purDtlList[i].purDtlOrder+"</td>";
				tag += "<td><input id='purDetail_"+i+"' type='text' class='font10' value='"+this.purDtlList[i].purDetail+"' onkeyup='rec.sync(this)'></td>";
				tag += "</tr>";
			}
		}	
		
		tag +="</table>";
		$("#purDtlList").append(tag);
		
		return this;
	}
		
}