/**
 * ledgerReBank.js
 */

$(document).ready(function(){
	$('#bankList').on("change keyup input", function(event) {
		bank.sync(event.target);
	});
	
	$('#bankList').on("click", function(event) {
		bank.sync(event.target);
	});
});

let bank = {
	bankList : new Array(),
	bankClone : new Array(),		
	
	init : function(bankList){		
    	this.bankList = bankList;
    	this.bankClone = common.clone(this.bankList);   
    	return this;
	},
	
	add : function(){
		this.bankList.push({bankName: '', bankAccount: '', bankNowUseYn: 'Y', state: 'insert'});		
		return this;
	},
	
	del : function(idx){		
		this.bankList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.bankList = common.clone(this.bankClone);		
		return this;
	},
	
	view : function(){
		
		$("#bankList").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";
			tag	+= "<th>bankName</th>";
			tag	+= "<th>bankAccount</th>";
			tag	+= "<th>bankUse</th>";
			tag += "</tr>";
		
		let addAttr = {chked:"", cls:"", read:""};
		let useCls = "";
		
		for(let i=0; i<this.bankList.length; i++){			
			
			if(this.bankList[i].state === "insert"){
				addAttr = {chked:"", cls:"add", read:""};			
			}else if(this.bankList[i].state === "delete"){				
				addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
			}else if(this.bankList[i].state === "update"){
				addAttr = {chked:"", cls:"edit", read:""};
			}else{
				addAttr = {chked:"", cls:"", read:""};
			}
			
			this.bankList[i].bankNowUseYn === "Y" ? useCls = "btn_azure01" : useCls = "btn_pink01";
						
			tag += "<tr>";			
			tag += "<td><input id='delete_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
			tag += "<td>"+(i+1)+"</td>";
			tag += "<td><input id='bankName_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.bankList[i].bankName+"' ></td>";
			tag += "<td><input id='bankAccount_"+i+"' type='text' class='font10 "+addAttr.cls+"' "+addAttr.read+" value='"+this.bankList[i].bankAccount+"'></td>";
			tag += "<td><input id='bankNowUseYn_"+i+"' type='button' class='"+addAttr.cls+" "+useCls+"' "+addAttr.read+" value='"+this.bankList[i].bankNowUseYn+"'></td>";
			tag += "</tr>";	
		}			
		tag +="</table>";
		$("#bankList").append(tag);
		
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];		
		
		if(name === "delete"){
			
			if(this.bankList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){				
				this.bankList[idx].state = "delete";				
				$("#bankName_"+idx).addClass("redLine").prop("readOnly", true);
				$("#bankAccount_"+idx).addClass("redLine").prop("readOnly", true);				
				$("#bankNowUseYn_"+idx).removeClass("btn_azure01").addClass("btn_disabled01").prop("disabled", true);
			}else{
				this.bankList[idx].state = "select";
				$("#bankName_"+idx).removeClass("redLine").prop("readOnly", false);
				$("#bankAccount_"+idx).removeClass("redLine").prop("readOnly", false);
				$("#bankNowUseYn_"+idx).removeClass("btn_disabled01").addClass("btn_azure01").prop("disabled", false);
			}
		}else if(name === "bankNowUseYn"){
			if(target.value === "Y"){
				this.bankList[idx][name] = "N";
				$(target).val("N").removeClass("btn_azure01").addClass("btn_pink01");
			}else if(target.value === "N"){
				this.bankList[idx][name] = "Y";
				$(target).val("Y").removeClass("btn_pink01").addClass("btn_azure01");
			}			
		}else{			
			this.bankList[idx][name] = String(target.value);
		}
		
		
		if(this.bankList[idx].state !== "insert"){
			if($(target).is(":checked") === false && this.equals(idx) === false){
				this.bankList[idx].state = "update";			
				$("#bankName_"+idx).addClass("edit").prop("readOnly", false);
				$("#bankAccount_"+idx).addClass("edit").prop("readOnly", false);
				$("#bankNowUseYn_"+idx).addClass("edit").prop("disabled", false);
			}else{
				if(this.bankList[idx].state !== "insert"){
					$(target).is(":checked") === true ? this.bankList[idx].state = "delete" : this.bankList[idx].state = "select";			
					$("#bankName_"+idx).removeClass("edit");
					$("#bankAccount_"+idx).removeClass("edit");
					$("#bankNowUseYn_"+idx).removeClass("edit");
				}
			}
		}
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.bankList.length; i++){
			
			// 빈값, null 체크
			if(this.bankList[i].bankName === '' || this.bankList[i].bankName === null){
				check = {check : false, msg : (i+1) + "행의 은행이름이 입력되지 않았습니다."};
				break;
			}else if(this.bankList[i].bankAccount === '' || this.bankList[i].bankAccount === null){
				check = {check : false, msg : (i+1) + "행의 은행계좌번호가 입력되지 않았습니다."};
				break;
			}
			
			if(this.bankList[i].state === "select") saveChk++;
		}

		if(this.bankList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.bankList.length; i++){		
			
			if(this.bankList[i].state === "insert"){
				inList.push(this.bankList[i]);
			}else if(this.bankList[i].state === "update"){
				upList.push(this.bankList[i]);
			}else if(this.bankList[i].state === "delete"){
				delList.push(this.bankList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/ajax/inUpDelBankList.do',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	if(data.msg==="bankUsed"){
		    		alert("삭제-사용되는 은행이 존재하여 실패.");
		    	}
		    	white.sideSubmit("ledgerRe", "Bank");
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});	
	},
	
	equals : function(idx){
		
		if(this.bankList[idx].bankName !== this.bankClone[idx].bankName){
			return false;
		}else if(this.bankList[idx].bankAccount !== this.bankClone[idx].bankAccount){
			return false;
		}else if(this.bankList[idx].bankNowUseYn !== this.bankClone[idx].bankNowUseYn){
			return false;
		}else{
			return true;	
		}
	}
	
}