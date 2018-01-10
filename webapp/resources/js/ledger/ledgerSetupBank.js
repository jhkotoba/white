/**
 * ledgerSetupBank.js
 */

$(document).ready(function(){
	bankSetup.list = common.clone(bankList);
	bankSetup.view();
	
	$("#bankAdd").click(function(){	
		bankSetup.list.push({bankAccount: "", userBankSeq: 0, bankNowUseYN: "Y",bankName: "", });
		bankSetup.view();
	});
	
	$("#bankCancel").click(function(){
		bankSetup.list = common.clone(bankList);		
		bankSetup.delList.splice(0, bankSetup.delList.length);		
		bankSetup.view();
	});
	
	$("#bankSave").click(function(){
		
		let checkSetNm = new Set();
		let checkSetAcc = new Set();
		let insertList = new Array();
		let updateList = new Array();		
		
		//빈 값 체크, insert값 추출, update값 추출
		for(let i=0; i<bankSetup.list.length; i++){
			if(str.trim(bankSetup.list[i]["bankName"]) === ""){
				alert("빈 값은 저장할 수 없습니다.");
				$("#bankNm_"+i).focus();
				return;
			}else if(str.trim(bankSetup.list[i]["bankAccount"]) === ""){
				alert("빈 값은 저장할 수 없습니다.");
				$("#bankAcc_"+i).focus();
				return;
			}
			
			
			if(bankSetup.list[i]["userBankSeq"] === 0){
				insertList.push(bankSetup.list[i]);
			}else if(bankSetup.list[i]["userBankSeq"] < 0){
				bankSetup.list[i]["userBankSeq"] = Math.abs(bankSetup.list[i]["userBankSeq"]);
				updateList.push(bankSetup.list[i]);
			}
			
			checkSetNm.add(bankSetup.list[i]["bankName"]);
			checkSetAcc.add(bankSetup.list[i]["bankAccount"]);
			
		}
		
		//중복 값 체크
		if(checkSetNm.size != bankSetup.list.length){
			alert("중복된 값이 존재 합니다.");
			return;
		}else if(checkSetAcc.size != bankSetup.list.length){
			alert("중복된 값이 존재 합니다.");
			return;
		}
		console.log(updateList.length);
		//수정 사항 체크
		if(updateList.length === 0 && insertList.length === 0 && bankSetup.delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.").
			return;
		}		
		
		if(confirm("저장하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/ajax/ledgerSetupBank.do',
				data: {
					userSeq : $("#userSeq").val(),
					insertList : insertList.length === 0 ? "" : JSON.stringify(insertList),				
					updateList : updateList.length === 0 ? "" : JSON.stringify(updateList),					
					deleteList : bankSetup.delList.length === 0 ? "" : JSON.stringify(bankSetup.delList)		
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {  
			    	alert("추가, 수정, 삭제하였습니다.");
			    	bankList = data;
			    	console.log(data);
			    	bankSetup.list = common.clone(bankList);
			    	bankSetup.delList.splice(0, bankSetup.delList.length);
			    	bankSetup.view();
			    },
			    error : function(xhr, stat, err) {			    	
			    	alert("setup error");
			    }
			});
		}
	});
	
});


let bankSetup = {
		list : null,
		delList : new Array(),	
		view : function(){			
			$("#bankInfo").empty();
			
			let tag = "<table id='bankTb' border=1><tr><th>순번</th><th>은행명</th><th>계좌번호</th><th>수정/삭제</th></tr>";	
			for(let i=0; i<this.list.length; i++){				
				tag += "<td id='bankNo_"+i+"'>"+(i+1)
					+ "<input type='hidden' id='bankSeq_"+i+"' value='"+this.list[i]["userBankSeq"]+"'></td>"
					+ "<td><input id='bankNm_"+i+"' type='text' value='"+this.list[i]["bankName"]
					+ "' onkeyup='bankSetup.change("+i+",0)'></td>"
					+ "<td><input id='bankAcc_"+i+"' type='text' value='"+this.list[i]["bankAccount"]
					+ "' onkeyup='bankSetup.change("+i+",1)'></td>"
					+ "<td><button onclick='bankSetup.del("+i+")'>삭제</button></td></tr>";
			}			
			$("#bankInfo").append(tag+"</table>");
		},
		change : function(idx, type){
			
			let seq = this.list[idx]["userBankSeq"];	
			if(seq > 0)	this.list[idx]["userBankSeq"] = seq*-1;
			
			//bankName
			if(type===0){
				this.list[idx]["bankName"] = str.trim($("#bankNm_"+idx).val());
				
			//bankAccount
			}else if(type===1){
				this.list[idx]["bankAccount"] = str.trim($("#bankAcc_"+idx).val());				
			}
			
			
					
				
			
			
		},
		del : function(idx){
			this.list[idx]["userBankSeq"] = Math.abs(this.list[idx]["userBankSeq"]);
			
			if(this.list[idx]["userBankSeq"] !== 0){
				this.delList.push(this.list[idx]);
			}			
			
			this.list.splice(idx, 1);
			this.view();
		}	
		
}