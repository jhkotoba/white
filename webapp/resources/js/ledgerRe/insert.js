/**
 * insert.js
 */

$(document).ready(function(){
	$('#ledgerReList').on("change keyup input", function(event) {
		switch(event.target.id.split('_')[0]){		
		case "purSeq" :			
			recIn.appSel(event.target, event.target.id.split('_')[1]);
		default :
			recIn.sync(event.target);
			break;
		}
	});	
});

let recIn = {
	inList : new Array(),
	purList : new Array(),
	purDtlList : new Array(),
	bankList : new Array(),
	
	init : function(purList, purDtlList, bankList){
		this.purList = purList;
		this.purDtlList = purDtlList;
		this.bankList = bankList;		
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
		this.inList.push({date: isDate.today(), time: isTime.curTime(), position:'', content:'', purSeq: '', purDtlSeq: '', bankSeq: '', moveSeq: '', money: ''});
		return this;
	},
	
	del : function(){		
		this.inList.splice(this.inList.length-1,1);
		return this;
	},
	
	sync : function(target){		
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];
		
		switch(name){
		
		case "purSeq" :
			if(String(target.value) === '0'){				
				this.inList[idx].purDtlSeq = '';
			}			
			if(String(target.value) !== '0' && String(this.inList[idx].moveSeq) !== ''){
				this.inList[idx].moveSeq = '';
			}			
			this.inList[idx][name] = String(target.value);
			this.inList[idx]["purDtlSeq"] = "";
			break;
			
		default :
			this.inList[idx][name] = String(target.value);
			break;
		}
		
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		
		if(this.inList.length < 1){
			check = {check : false, msg : "입력된 데이터가 없습니다."};
			return check;
		}
		
		for(let i=0; i<this.inList.length; i++){
			
			// 빈값, null 체크
			if(this.inList[i].date === '' || this.inList[i].date === null){
				check = {check : false, msg : (i+1) + "행의 날짜 데이터가 입력되지 않았습니다."};
				break;
			}else if(this.inList[i].time === '' || this.inList[i].time === null){
				check = {check : false, msg : (i+1) + "행의 시간 데이터가 입력되지 않았습니다."};
				break;
			}else if(this.inList[i].content === '' || this.inList[i].content === null){
				check = {check : false, msg : (i+1) + "행의 내용이 입력되지 않았습니다."};
				break;
			}else if(this.inList[i].purSeq === '' || this.inList[i].purSeq === null){
				check = {check : false, msg : (i+1) + "행의 목적이 선택되어 있지 않습니다."};
				break;
			}else if(this.inList[i].bankSeq === '' || this.inList[i].bankSeq === null){
				check = {check : false, msg : (i+1) + "행의 사용수단(현금, 은행)이 선택되어 있지 않습니다."};
				break;
			}else if(this.inList[i].money === '' || this.inList[i].money === null){
				check = {check : false, msg : (i+1) + "행의  금액이 입력되지 않았습니다."};
				break;
			}
			
			//금액이동시 체크
			if(Number(this.inList[i].purSeq) === 0 && String(this.inList[i].moveSeq) === ''){
				check = {check : false, msg : (i+1) + "행의 금액이동할 대상이 선택되지 않았습니다."};
				break;
			}else if(String(this.inList[i].bankSeq) === String(this.inList[i].moveSeq)){
				check = {check : false, msg : (i+1) + "행의 금액이 이동할 곳이 같습니다."};
				break;
			}
			
			//비정상 값 체크			
			if(common.isNum(this.inList[i].money) === false){
				check = {check : false, msg : (i+1) + "행의 금액이 잘못 입력하였습니다."};
				break;
			}
		}
		
		return check;
	},
	
	insert : function(){
		
		//moveMoney 마이너스 수정
		for(let i=0; i<this.inList.length; i++){
			if(this.inList[i].purSeq === '0'){			
				this.inList[i].money = "-"+String(Math.abs(Number(this.inList[i].money)));
			}
		}
		if(confirm("입력한 내용을 저장 하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/ledgerRe/insertRecordList.ajax',
				data: {
					inList : JSON.stringify(this.inList)
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {  
			    	alert(data+" 개의 행이 저장되었습니다.");
			    	white.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    },
			    error : function(xhr, stat, err) {
			    	alert("insert error");
			    }
			});
		}			
	},
	
	view : function(){
		
		$("#ledgerReList").empty();
		let selected = "";
		let tag = "";
		
		if(window.innerWidth > 500){
		
			tag += "<table class='table table-striped table-sm table-bordered'>";
			tag	+= "<tr>";
			tag += "<th>no</th>";
			tag	+= "<th>날짜*</th>";
			tag	+= "<th>위치 / 내용*</th>";
			tag	+= "<th>목적* / 상세목적</th>";
			tag	+= "<th>사용수단* / (이동대상)</th>";
			tag	+= "<th>수입 지출*</th>";
			tag += "</tr>";
		
			for(let i=0; i<this.inList.length; i++){
			
				tag += "<tr>";			
				tag += "<td>"+(i+1)+"</td>";
				tag += "<td><input id='date_"+i+"' type='date' class='form-control' value='"+this.inList[i].date+"'>";
				tag += "<input id='time_"+i+"' type='time' class='form-control' value='"+this.inList[i].time+"'></td>";
				tag += "<td><input id='position_"+i+"' type='text' class='form-control' value='"+this.inList[i].position+"'>";			
				tag += "<input id='content_"+i+"' type='text' class='form-control' value='"+this.inList[i].content+"'></td>";			
				tag += "<td><select id='purSeq_"+i+"' class='custom-select slt-fs' onchange='recIn.sync(this); recIn.appSel(this,"+i+");'>";
				tag += "<option value=''>선택</option>";
				tag += "<option value=0>금액이동</option>";			
				for(let j=0; j<this.purList.length; j++){
					this.inList[i].purSeq === String(this.purList[j].purSeq) ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.purList[j].purSeq+">"+this.purList[j].purpose+"</option>";
				}				
				tag += "</select>";
				tag += "<select id='purDtlSeq_"+i+"' class='custom-select slt-fs'>";
				tag += "<option value=''>선택</option>";
				for(let j=0; j<this.purDtlList.length; j++){
					if(this.inList[i].purSeq === String(this.purDtlList[j].purSeq)){
						this.inList[i].purDtlSeq === String(this.purDtlList[j].purDtlSeq) ? selected = "selected='selected'" : selected = "";
						tag += "<option "+selected+" value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
					}
				}	
				tag += "</select></td>";
				tag += "<td><select id='bankSeq_"+i+"' class='custom-select slt-fs'>";
				tag += "<option value=''>선택</option>";
				tag += "<option "+(this.inList[i].bankSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
				for(let j=0; j<this.bankList.length; j++){
					this.inList[i].bankSeq === this.bankList[j].bankSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
				}				
				tag += "</select>";
				tag += "<select id='moveSeq_"+i+"' class='custom-select slt-fs' disabled='disabled'>";
				tag += "<option value=''>선택</option>";
				tag += "<option "+(this.inList[i].moveSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
				for(let j=0; j<this.bankList.length; j++){
					this.inList[i].moveSeq === this.bankList[j].bankSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
				}				
				tag += "</select></td>";
				tag += "<td><input id='money_"+i+"' type='text' class='form-control'  value='"+this.inList[i].money+"'></td>";			
				tag += "</tr>";		
			}		
			tag +="</table>";
		
		}else{			
			tag += "<table class='table table-striped table-sm table-bordered'>";		
			for(let i=0; i<this.inList.length; i++){
				
				tag	+= "<tr>";
				tag += "<th>no</th>";
				tag += "<th style='width: 60px;'>입력사항</th>";
				tag += "<th>입력내용</th>";
				tag += "</tr>";
				
				tag += "<tr><td rowspan='6'>"+(i+1)+"</td></tr>";
				tag	+= "<tr><th>날짜*</th>";
				tag += "<td><input id='date_"+i+"' type='date' class='form-control' value='"+this.inList[i].date+"'>";
				tag += "<input id='time_"+i+"' type='time' class='form-control' value='"+this.inList[i].time+"'></td></tr>";
				
				tag	+= "<tr><th>위치/내용*</th>";
				tag += "<td><input id='position_"+i+"' type='text' class='form-control' value='"+this.inList[i].position+"'>";			
				tag += "<input id='content_"+i+"' type='text' class='form-control' value='"+this.inList[i].content+"'></td></tr>";
				
				tag	+= "<tr><th>목적*/상세목적</th>";
				tag += "<td><select id='purSeq_"+i+"' class='custom-select slt-fs' onchange='recIn.sync(this); recIn.appSel(this,"+i+");'>";
				tag += "<option value=''>선택</option>";
				tag += "<option value=0>금액이동</option>";			
				for(let j=0; j<this.purList.length; j++){
					this.inList[i].purSeq === String(this.purList[j].purSeq) ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.purList[j].purSeq+">"+this.purList[j].purpose+"</option>";
				}				
				tag += "</select>";
				tag += "<select id='purDtlSeq_"+i+"' class='custom-select slt-fs'>";
				tag += "<option value=''>선택</option>";
				for(let j=0; j<this.purDtlList.length; j++){
					if(this.inList[i].purSeq === String(this.purDtlList[j].purSeq)){
						this.inList[i].purDtlSeq === String(this.purDtlList[j].purDtlSeq) ? selected = "selected='selected'" : selected = "";
						tag += "<option "+selected+" value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
					}
				}	
				tag += "</select></td></tr>";
				
				tag	+= "<tr><th>사용수단* / (이동대상)</th>";
				tag += "<td><select id='bankSeq_"+i+"' class='custom-select slt-fs'>";
				tag += "<option value=''>선택</option>";
				tag += "<option "+(this.inList[i].bankSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
				for(let j=0; j<this.bankList.length; j++){
					this.inList[i].bankSeq === this.bankList[j].bankSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
				}				
				tag += "</select>";
				tag += "<select id='moveSeq_"+i+"' class='custom-select slt-fs' disabled='disabled'>";
				tag += "<option value=''>선택</option>";
				tag += "<option "+(this.inList[i].moveSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
				for(let j=0; j<this.bankList.length; j++){
					this.inList[i].moveSeq === this.bankList[j].bankSeq ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
				}				
				tag += "</select></td></tr>";
				tag	+= "<tr><th>수입 지출*</th>";
				tag += "<td><input id='money_"+i+"' type='text' class='form-control'  value='"+this.inList[i].money+"'></td></tr>";				
			}
			tag +="</table>";
			
		}
		$("#ledgerReList").append(tag);
	},
	appSel : function(target, idx){	
		$("#purDtlSeq_"+idx).empty();	

		let selected = "";
		let tag = "<option value=''>선택</option>";
		for(let j=0; j<this.purDtlList.length; j++){
			if(this.inList[idx].purSeq === String(this.purDtlList[j].purSeq)){
				this.inList[idx].purDtlSeq === String(this.purDtlList[j].purDtlSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+"value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
			}
		}	
		$("#purDtlSeq_"+idx).append(tag);
		
		//move 셀렉트박스 금액이동이외 disabled 처리
		if('0' === String(target.value)){			
			$("#moveSeq_"+idx).removeAttr("disabled");
		}else{
			$("#moveSeq_"+idx).val('').prop("selected", true).attr("disabled","disabled");
		}
	}
}