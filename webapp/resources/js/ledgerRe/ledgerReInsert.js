/**
 * ledgerReInsert.js
 */

let recIn = {
	inList : new Array(),
	purList : new Array(),
	purDtlList : new Array(),
	bankList : new Array(),
	
	init : function(purList, purDtlList, bankList){
		this.purList = JSON.parse(purList);
		this.purDtlList = JSON.parse(purDtlList);
		this.bankList = JSON.parse(bankList);		
		return this;
	},
	
	destroy : function(){
		this.inList = new Array();
		this.purList = new Array();
		this.purDtlList = new Array();
		this.bankList = new Array();
		$("#ledgerReList").empty();
	},
	
	add : function(){
		this.inList.push({date: isDate.today(), time: isTime.curTime(), content:"", purSeq: 0, purDtlSeq: 0, bankSeq: 0, moveSeq: 0, money: 0});
		this.view();
	},
	
	del : function(){		
		this.inList.splice(this.inList.length-1,1);
		this.view();
	},
	sync : function(taget){		
		let name = taget.id.split('_')[0];
		let idx = taget.id.split('_')[1];		
		this.inList[idx][name] = taget.value;
	},
	
	view : function(){
		
		$("#ledgerReList").empty();
		
		let tag = "<table border=1>"
				+ "<t6/r>"				
				+ "<th>Date</th>"
				+ "<th>Time</th>"
				+ "<th>content</th>"
				+ "<th>purpose</th>"
				+ "<th>purDetail</th>"
				+ "<th>bankName</th>"
				+ "<th>moveName</th>"
				+ "<th>money</th>";	
			tag += "<tr>";		
		
		for(let i=0; i<this.inList.length; i++){
			
			tag += "<tr>";			
			tag += "<td><input id='date_"+i+"' type='date' value='"+this.inList[i].date+"'></td>";
			tag += "<td><input id='time_"+i+"' type='time' value='"+this.inList[i].time+"'></td>";
			tag += "<td><input id='content_"+i+"' type='text' value='"+this.inList[i].content+"' onkeyup='recInSync(this)'></td>";
			tag += "<td><input id='purSeq_"+i+"' type='text' value='"+this.inList[i].purSeq+"'></td>";
			tag += "<td><input id='purDtlSeq_"+i+"' type='text' value='"+this.inList[i].purDtlSeq+"'></td>";
			tag += "<td><input id='bankSeq_"+i+"' type='text' value='"+this.inList[i].bankSeq+"'></td>";
			tag += "<td><input id='moveSeq_"+i+"' type='text' value='"+this.inList[i].moveSeq+"'></td>";
			tag += "<td><input id='money_"+i+"' type='text' value='"+this.inList[i].money+"' onkeyup='recInSync(this)'></td>";			
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#ledgerReList").append(tag);
	}
	
	
}