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
		this.inList.push({date: isDate.today(), time: isTime.curTime(), content:'', purSeq: 0, purDtlSeq: 0, bankSeq: 0, moveSeq: 0, money: ''});
		this.view();
	},
	
	del : function(){		
		this.inList.splice(this.inList.length-1,1);
		this.view();
	},
	
	sync : function(taget, isNum){		
		let name = taget.id.split('_')[0];
		let idx = taget.id.split('_')[1];
		this.inList[idx][name] = (isNum === 1 ? Number(taget.value) : String(taget.value));
	},
	
	view : function(){
		
		$("#ledgerReList").empty();
		let selected = "";
		
		let tag = "<table border=1>"
				+ "<tr>"				
				+ "<th>Date</th>"
				+ "<th>Time</th>"
				+ "<th>content</th>"
				+ "<th>purpose</th>"
				+ "<th>purDetail</th>"
				+ "<th>bankName</th>"
				+ "<th>moveName</th>"
				+ "<th>money</th>";	
			tag += "</tr>";		
		
		for(let i=0; i<this.inList.length; i++){
			
			tag += "<tr>";			
			tag += "<td><input id='date_"+i+"' type='date' value='"+this.inList[i].date+"' onkeyup='recIn.sync(this, 0)'></td>";
			tag += "<td><input id='time_"+i+"' type='time' value='"+this.inList[i].time+"' onkeyup='recIn.sync(this, 0)'></td>";
			tag += "<td><input id='content_"+i+"' type='text' value='"+this.inList[i].content+"' onkeyup='recIn.sync(this, 0)'></td>";			
			tag += "<td><select id='purSeq_"+i+"' onchange='recIn.sync(this, 1); recIn.selDtl("+i+");'>";
			tag += "<option value=''>선택</option>";
			tag += "<option value=0>금액이동</option>";			
			for(let j=0; j<this.purList.length; j++){
				this.inList[i].purSeq === this.purList[j].purSeq ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+"value="+this.purList[j].purSeq+">"+this.purList[j].purpose+"</option>";
			}				
			tag += "</select></td>";
			tag += "<td><select id='purDtlSeq_"+i+"' onchange='recIn.sync(this, 1)'>";
			tag += "<option value=''>선택</option>";
			for(let j=0; j<this.purDtlList.length; j++){
				if(this.inList[i].purSeq === this.purDtlList[j].purSeq){
					this.inList[i].purDtlSeq === this.purDtlList[j].purDtlSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+"value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
				}
			}	
			tag += "</select></td>";		
			tag += "<td><input id='bankSeq_"+i+"' type='text' value='"+this.inList[i].bankSeq+"'></td>";
			tag += "<td><input id='moveSeq_"+i+"' type='text' value='"+this.inList[i].moveSeq+"'></td>";
			tag += "<td><input id='money_"+i+"' type='text' value='"+this.inList[i].money+"' onkeyup='recIn.sync(this)'></td>";			
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#ledgerReList").append(tag);
	},
	selDtl : function(idx){		
		$("#purDtlSeq_"+idx).empty();		
		let tag = "<option value=''>선택</option>";
		for(let j=0; j<this.purDtlList.length; j++){
			if(this.inList[idx].purSeq === this.purDtlList[j].purSeq){
				this.inList[idx].purDtlSeq === this.purDtlList[j].purDtlSeq ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+"value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
			}
		}	
		$("#purDtlSeq_"+idx).append(tag);
	}
}