/**
 * ledgerSelect.js
 */

function purDtlChange(idx){
	
	let value = $("#purposeS_"+idx).val();	
	$("#purposeDtlS_"+idx).remove();	
	
	let tag  = "<select id='purposeDtlS_"+idx+"'>";
	tag += "<option selected='selected' value='0'>상세사용목적 선택</option>";
	
	if(emptyCheck.isNotEmpty(value)){
		for(let i=0; i<ledgerSelect.purposeDtlList.length; i++){			
			if(Number(value) === ledgerSelect.purposeDtlList[i]["purposeSeq"]){				
				tag += "<option value='"+ledgerSelect.purposeDtlList[i]['purDetailSeq']
				+"'>"+ledgerSelect.purposeDtlList[i]['purDetail']+"</option>";
			}				
		}	
	}
	tag += "</select>";
	$("#purposeDtl_"+idx).append(tag);
}

let ledgerSelect = {
		startDate : "",
		endDate : "",		
		rowCnt : 0,
		checkedCnt : 0,		
		purposeList : null,
		purposeDtlList : null,
		bankList : null,
		searchDateBtn : function(num){			
			
			if(typeof(num) === "string" && num === "today"){
				$("#startDate").val(isDate.today());
				$("#endDate").val(isDate.today());
				
			}else if(typeof(num) === "number"){				
				$("#startDate").val(isDate.addMonfirstDay(num));
				$("#endDate").val( isDate.lastDay(0));			
			}			
		},
		recodeSearch : function(){
		
			ledgerSelect.startDate = $("#startDate").val();
			ledgerSelect.endDate = $("#endDate").val();
			//ledgerSelect.purSeq = $("#purSelect").val();
			
			selectRecode.recodeSearch("select");
		},
		//전체 체크박스 선택 or 취소
		checkboxAll : function(){
			let check = $("#checkTitle").is(":checked");
			
			let idx = 0;
			$('input:checkbox[name="checkbox"]').each(function(){
				
				if(check===true && this.checked==false){					
					this.checked = true;	
					
					let value = $("#recordDateP_"+idx).text();
					ledgerSelect.typeChange(true, idx, value, "recordDate" );
					
					value = $("#contentP_"+idx).text();
					ledgerSelect.typeChange(true, idx, value, "content" );
					
					let purposeSeq = Number($("#purposeSeq_"+idx).text());
					if(purposeSeq !==0){
						value = $("#purposeP_"+idx).text();							
						ledgerSelect.typeChange(true, idx, value, "purpose");
						value = $("#purposeS_"+idx).val();
						let purDtlText = $("#purposeDtlP_"+idx).text();							
						ledgerSelect.typeChange(true, idx, value, "purposeDtl" , purDtlText );
					}
					
					//현금이동은 목적, 상세목적이 수정이 되면 안됨 그래서 ledgerSelect.typeChange 호출 안함
					
					/*value = $("#bankNameP_"+idx).text();					
					ledgerSelect.typeChange(true, idx, value, "bankName");
					
					value = $("#inExpMoneyP_"+idx).text();					
					ledgerSelect.typeChange(true, idx, value, "inExpMoney");*/
					
				}else if(check===false && this.checked==true){
					this.checked = false;					
					ledgerSelect.typeChange(false, idx);					
				}
				idx++;				
			 });
			this.checkedCnt = $('input:checkbox[name="checkbox"]:checked').length;
			if(this.checkedCnt > 0){
				$("#editBtn").prop("disabled",false);
				$("#delBtn").prop("disabled",false);	
			}else{
				$("#editBtn").prop("disabled",true);
				$("#delBtn").prop("disabled",true);	
			}	
		},
		// 체크박스 한개 선택 or 취소
		checkboxOne : function(idx){
			let bool = $("input:checkbox[id='checkbox_"+idx+"']").is(":checked");
			
			let value = $("#recordDateP_"+idx).text();
			ledgerSelect.typeChange(bool, idx, value, "recordDate" );
			
			value = $("#contentP_"+idx).text();			
			ledgerSelect.typeChange(bool, idx, value, "content");
			
			value = $("#purposeP_"+idx).text();			
			//금액이동 때문에 행이 2개됨, 보이기에는 1행으로 해야 하기때문에 윗칸을 체크하면 아래칸도 같이 체크되야됨(삭제때문에) 수정은 숨기는거라 안함
			let purposeSeq = Number($("#purposeSeq_"+idx).text());			
			if(purposeSeq !==0){
				ledgerSelect.typeChange(bool, idx, value, "purpose");	
				
				value = $("#purposeS_"+idx).val();				
				let purDtlText = $("#purposeDtlP_"+idx).text();
				ledgerSelect.typeChange(bool, idx, value, "purposeDtl" , purDtlText);
			}else{		
				if($("#checkbox_"+(idx+1)).prop('checked')){
					$("#checkbox_"+(idx+1)).prop('checked', false);
					
					let bool = $("input:checkbox[id='checkbox_"+idx+"']").is(":checked");
					
					let value = $("#recordDateP_"+(idx+1)).text();
					ledgerSelect.typeChange(bool, (idx+1), value, "recordDate" );
					
					value = $("#contentP_"+(idx+1)).text();			
					ledgerSelect.typeChange(bool, (idx+1), value, "content");
					
					//현금이동은 목적, 상세목적이 수정이 되면 안됨 그래서 ledgerSelect.typeChange 호출 안함
					value = $("#purposeP_"+(idx+1)).text();					
					value = $("#purposeDtlP_"+idx).text();
				}else{
					$("#checkbox_"+(idx+1)).prop('checked', true);
					
					let bool = $("input:checkbox[id='checkbox_"+(idx+1)+"']").is(":checked");
					
					let value = $("#recordDateP_"+(idx+1)).text();
					ledgerSelect.typeChange(bool, (idx+1), value, "recordDate" );	
					
					value = $("#contentP_"+(idx+1)).text();			
					ledgerSelect.typeChange(bool, (idx+1), value, "content");
					
					//현금이동은 목적, 상세목적이 수정이 되면 안됨 그래서 ledgerSelect.typeChange 호출 안함
					value = $("#purposeP_"+(idx+1)).text();					
					value = $("#purposeDtlP_"+idx).text();
				}
			}
			
			
			
			/*value = $("#bankNameP_"+idx).text();					
			ledgerSelect.typeChange(bool, idx, value, "bankName");
			value = $("#inExpMoneyP_"+idx).text();					
			ledgerSelect.typeChange(bool, idx, value, "inExpMoney");*/
			
			this.checkedCnt = $('input:checkbox[name="checkbox"]:checked').length;
			if(this.checkedCnt > 0){
				$("#editBtn").prop("disabled",false);
				$("#delBtn").prop("disabled",false);	
			}else{
				$("#editBtn").prop("disabled",true);
				$("#delBtn").prop("disabled",true);	
			}	
		},
		//체크박스 선택시 타입 변환
		typeChange : function(bool, idx, value, id, purDtlText){
			let teg = "";
			if(bool===true){
				$("#"+id+"P_"+idx).hide();
				switch(id){
				case "recordDate" :					
					$("#"+id+"_"+idx).append("<input id='"+id+"D_"+idx+"' type='date' value='"+value.split(' ')[0]+"'>");
					$("#"+id+"_"+idx).append("<input id='"+id+"T_"+idx+"' type='time' value='"+value.split(' ')[1]+"'>");
					break;
				case "content" :
				//case "inExpMoney" :
					$("#"+id+"_"+idx).append("<input id='"+id+"T_"+idx+"' type='text' value='"+value+"'>");					
					break;
				case "purpose" : 
					
					tag = "<select id='"+id+"S_"+idx+"' onchange='purDtlChange("+idx+")'>";					
					if(value==="deleted"){
						tag += "<option value=''>사용목적 선택</option>";
					}
					for(let i=0; i<this.purposeList.length; i++){						
						if(value===this.purposeList[i]['purpose']){
							tag += "<option selected='selected' value="+this.purposeList[i]['purposeSeq']
									+">"+this.purposeList[i]['purpose']+"</option>";
						}else{
							tag += "<option value='"+this.purposeList[i]['purposeSeq']
							+"'>"+this.purposeList[i]['purpose']+"</option>";
						}						
					}	
					tag += "</select>";
					
					$("#"+id+"_"+idx).append(tag);					
					break;
				case "purposeDtl" : 					
					tag = "<select id='"+id+"S_"+idx+"'>";
					tag += "<option value='0'>상세사용목적 선택</option>";					
					
					if(emptyCheck.isNotEmpty(value)){
						for(let i=0; i<this.purposeDtlList.length; i++){
							
							if(Number(value) === this.purposeDtlList[i]["purposeSeq"]){
								if(purDtlText===this.purposeDtlList[i]['purDetail']){
									tag += "<option selected='selected' value="+this.purposeDtlList[i]['purDetailSeq']
									+">"+this.purposeDtlList[i]['purDetail']+"</option>";
								}else{
									tag += "<option value='"+this.purposeDtlList[i]['purDetailSeq']
									+"'>"+this.purposeDtlList[i]['purDetail']+"</option>";
								}									
							}				
						}	
					}
					tag += "</select>";
					
					$("#"+id+"_"+idx).append(tag);
					break;
				/*case "bankName" :
					tag = "<select id='"+id+"S_"+idx+"'>";					
					if(value==="현금"){
						tag += "<option value=0 selected='selected'>현금</option>";
					}else{
						tag += "<option value=0>현금</option>";							
					}					
					if(value!="현금")	value = value.split("(")[1].replace(")", "");
					
					for(let i=0; i<this.bankList.length; i++){
						if(this.bankList[i]["bankNowUseYN"] === "Y" && this.bankList[i]['bankAccount'] === value ){
							tag += "<option selected='selected' value='"+this.bankList[i]['userBankSeq']
									+"'>"+this.bankList[i]['bankName']+"("+this.bankList[i]["bankAccount"]+")</option>";
						}else{
							tag += "<option value='"+this.bankList[i]['userBankSeq']
							+"'>"+this.bankList[i]['bankName']+"("+this.bankList[i]["bankAccount"]+")</option>";
						}	
					}	
					tag += "</select>";					
					$("#"+id+"_"+idx).append(tag);					
					break;*/
				}				
			}else{
				$("#contentT_"+idx).remove();
				$("#purposeS_"+idx).remove();
				$("#purposeDtlS_"+idx).remove();
				//$("#bankNameS_"+idx).remove();
				$("#recordDateD_"+idx).remove();
				$("#recordDateT_"+idx).remove();
				//$("#inExpMoneyT_"+idx).remove();				
				
				$("#contentP_"+idx).show();
				$("#purposeP_"+idx).show();
				$("#purposeDtlP_"+idx).show();
				//$("#bankNameP_"+idx).show();
				$("#recordDateP_"+idx).show();
				//$("#inExpMoneyP_"+idx).show();
			}
		},
		//수정 및 삭제 로직
		editDel : function(updateType){
			
			//console.log(updateType);
			
			if(updateType === "delete"){
				if(!confirm("삭제하시겠습니까?")){
					return;
				}
			}else if(updateType === "update"){
				if(!confirm("수정하시겠습니까?")){
					return;
				}
			}
			
			
			$("#editBtn").prop("disabled",true);
			$("#delBtn").prop("disabled",true);
			
			let list = new Array();
			let checkIdxList = new Array();
			//let checkSet = new Set();
			let checkedCnt = 0;			
			
			let len = $("input:checkbox[name='checkbox']").length;
			for(let i=0; i<len; i++){						
				if($("#checkbox_"+i).prop("checked")){					
					
					let editData = {};
					editData.userSeq = $("#userSeq").val();
					editData.recordSeq = Number($("#checkbox_"+i).val());
					editData.recordDate = $("#recordDateD_"+i).val() + " " + $("#recordDateT_"+i).val();					
					editData.content = $("#contentT_"+i).val();
					editData.purposeSeq = Number($("#purposeS_"+i).val());
					editData.purposeDtlSeq = Number($("#purposeDtlS_"+i).val());
					editData.userBankSeq = Number($("#userBankSeq_"+i).val());					
					
					checkIdxList.push(i);					
					if(updateType == "update"){	
						//checkSet.add(checkDate);						
						if(	editData.recordDate != $("#recordDateP_"+i).text() ||
								editData.content != $("#contentP_"+i).text() ||	
								editData.purposeSeq != $("#purposeSeq_"+i).text() ||
								editData.purposeDtlSeq != $("#purposeDtlSeq_"+i).text() ){
							
							if(editData.recordDate == $("#recordDateP_"+i).text()) 
								editData.recordDate = "";
							if(editData.content == $("#contentP_"+i).text())
								editData.content = "";
							if(editData.purposeSeq == $("#purposeSeq_"+i).text())
								editData.purposeSeq = "";						
							if(editData.purposeDtlSeq == $("#purposeDtlSeq_"+i).text())
								editData.purposeDtlSeq = "";
							
														
							
							//현금이동일떄는 목적,상세목적은 강제로 "" 날짜는 잘 안되서 그냥 다되도록.. 
							if(Number($("#purposeSeq_"+i).text())===0){
								editData.purposeSeq = "";
								editData.purposeDtlSeq = "";
								$("#recordDateD_"+(i+1)).val($("#recordDateD_"+i).val());
								$("#recordDateT_"+(i+1)).val($("#recordDateT_"+i).val());
							}
							
							//현금이동 수정시 2행째 것도 수정이 필요하므로..							
							if(Number($("#purposeSeq_"+i).text())===0
									&& $("#recordDateD_"+i).val() + " " + $("#recordDateT_"+i).val() === $("#recordDateD_"+(i+1)).val() + " " + $("#recordDateT_"+(i+1)).val()){							
								
								if(editData.content != $("#contentP_"+i).text()){
									$("#contentT_"+(i+1)).val(editData.content);
								}
							}
							
							list.push(editData);
						}
					}else if(updateType == "delete"){
						editData.inExpMoney = Number($("#inExpMoney_"+i).text());						
						editData.bankAccount = $("#bankName_"+i).text();
						
						//console.log(editData.bankAccount);
						if(editData.bankAccount == "현금"){
							editData.bankAccount = "readyMoney";
						}else{
							editData.bankAccount = editData.bankAccount.split("(")[1].replace(")", "");
						}						
						list.push(editData);						
					}
					checkedCnt ++;
				}	
			}			
			
			
			if(this.validityCheck(checkIdxList, updateType)){
				$("#editBtn").prop("disabled",false);
				$("#delBtn").prop("disabled",false);
				return;
			}
			
			
			
			
			/*checkSet.forEach(function(item){
				console.log("item.toString():" + item.toString());				
			});
			console.log("checkSet: "+checkSet.size);
			console.log("checkedCnt: "+checkedCnt);*/
			
			// recordDate 중복체크			
			/*if(updateType == "update" && checkSet.size != checkedCnt){
				alert("중복된 입력시간이 존재합니다.");
				checkSet = null;
				$("#editBtn").prop("disabled",false);
				$("#delBtn").prop("disabled",false);
				return;
			}*/
						
			if(list.length == 0){
				alert("수정사항이 없습니다.");
				$("#editBtn").prop("disabled",false);
				$("#delBtn").prop("disabled",false);
				return;
			}
			//console.log(list);
			//return;
			let editData = JSON.stringify(list);			
			$.ajax({		
				type: 'POST',
				url: getContextPath()+'/ajax/ledgerEditDel.do',
				data :{
					updateType : updateType,
					editData : editData,					
				},
				dataType: 'json',					
			    success : function(data, stat, xhr) {
			    	
			    	alert("수정/삭제가 완료 되었습니다.");
			    	
			    	$("#ledgerInfo").empty();
			    	
			    	$("#startDate").val(ledgerSelect.startDate);
					$("#endDate").val(ledgerSelect.endDate);
					$("#searchBtn").trigger("click");
			    	
			    },
			    error : function(xhr, stat, err) {
			    	alert("수정에 실패하였습니다.");
			    	ledgerSide.pageSubmit("Select");
			    }
			});
		},		
		validityCheck : function(checkIdxList, updateType){
			
			//console.log(checkIdxList)
						
			for(let i=0; i<checkIdxList.length; i++){
				let str = "";
				
				//date
				str = $("#recordDateD_"+checkIdxList[i]).val();
				if(updateType==="edit" && emptyCheck.isEmpty(str)){
					alert((checkIdxList[i]+1)+"행의 날짜가 입력되지 않았습니다.");
					$("#recordDateD_"+checkIdxList[i]).focus();
					return true;
				}else if(updateType==="edit" && !(str.indexOf("-") == 4 && str.lastIndexOf("-") == 7)){
					alert((checkIdxList[i]+1)+"행의 날짜 형식이 맞지 않습니다. \nex) 2000-01-01");
					$("#recordDateD_"+checkIdxList[i]).focus();
					return true;
				}
				
				//time
				str = $("#recordDateT_"+checkIdxList[i]).val();
				if(updateType==="edit" && emptyCheck.isEmpty(str)){
					alert((checkIdxList[i]+1)+"행의 날짜가 입력되지 않았습니다.");
					$("#recordDateT_"+checkIdxList[i]).focus();
					return true;
				}else if(updateType==="edit" && !(str.indexOf(":") == 2 && str.lastIndexOf(":") == 5)){
					alert((checkIdxList[i]+1)+"행의 시간 형식이 맞지 않습니다. \nex) 20:00:00");
					$("#recordDateT_"+checkIdxList[i]).focus();
					return true;
				}
				
				//content
				str = $("#contentT_"+i).val();
				if(updateType==="edit" && emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 내용이 입력되지 않았습니다.");
					$("#contentT_"+i).focus();
					return true;
				}
				
				//purpose
				str = $("#purposeS_"+i).val();
				if(updateType==="edit" && emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 사용목적이 선택되지 않았습니다.");
					$("#purposeS_"+i).focus();
					return true;
				}
				
				/*
				//bank
				str = $("#bankName_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 현금/은행 이 선택되지 않았습니다.");
					$("#bankName_"+i).focus();
					return true;
				}
				
				//money
				str = $("#inExpMoney_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 금액이 입력되지 않았습니다.");
					$("#inExpMoney_"+i).focus();
					return true;
				}*/
			}
			
			return false;			
		}
		
}