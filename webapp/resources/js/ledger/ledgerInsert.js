/**
 * ledgerInsert.js
 */
$(document).ready(function(){	
		
	$("#date_0").val(isDate.today());
	$("#time_0").val(isTime.curTime());	
	
	
	$("#purpose_0").append("<option value=''>사용목적 선택</option>").append("<option value='0'>금액이동</option>");
	for(let i=0; i<ledgerInsert.purposeList.length; i++){
		$("#purpose_0").append("<option value='"+ ledgerInsert.purposeList[i]["purposeSeq"] +"'>"+ledgerInsert.purposeList[i]["purpose"]+"</option>");		
	}
	
	$("#purposeDtl_0").append("<option value=''>상세사용목적 선택</option>");	
	
	/*//현금이동 from
	$("#moveFrom_0").append("<option value=''>from 선택</option>").append("<option value=0>현금</option>");
	for(let i=0; i<ledgerInsert.userBankList.length; i++){
		if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
			$("#moveFrom_0").append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
			"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
		}
	}*/
	//현금이동 to
	$("#moveTo_0").append("<option value=''>to 선택</option>").append("<option value=0>현금</option>");
	for(let i=0; i<ledgerInsert.userBankList.length; i++){
		if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
			$("#moveTo_0").append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
			"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
		}
	}
	
	
	$("#bankName_0").append("<option value=''>현금/은행 선택</option>").append("<option value=0>현금</option>");
	for(let i=0; i<ledgerInsert.userBankList.length; i++){
		if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
			$("#bankName_0").append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
			"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
		}
	}
	ledgerInsert.idx = 1;
	
	

	
	
});
//현금이동선택시  현금/은행 숨기고   이동from 이동to show
//상세목적 셀렉트박스 표시
function purposeChanged(data, idx){	
	
	if(data.value == null || data.value == ''){
		$("#moveTo_"+idx).hide();
		$("#purposeDtl_"+idx).empty();
		$("#purposeDtl_"+idx).append("<option value=''>상세사용목적 선택</option>");
	}else{
		let purSeq = Number(data.value);	
		if(purSeq === 0){			
			$("#moveTo_"+idx).show();		
		}else{		
			$("#moveTo_"+idx).hide();
			
			//상세목적 셀렉트박스 표시
			//alert(idx);
			$("#purposeDtl_"+idx).empty();
			$("#purposeDtl_"+idx).append("<option value=''>상세사용목적 선택</option>");	
			
			//상세목적 기능 추가   목적에 따라서 상세목적 셀렉트 박스 생성.		
			for(let i=0; i<ledgerInsert.purposeDtlList.length; i++){			
				if(purSeq === Number(ledgerInsert.purposeDtlList[i]["purposeSeq"])){
					$("#purposeDtl_"+idx).append("<option value='"+ ledgerInsert.purposeDtlList[i]["purDetailSeq"] +"'>"+ledgerInsert.purposeDtlList[i]["purDetail"]+"</option>");
				}					
			}
			
		}
	}
	
	
	

}

let ledgerInsert = {
		idx : 0,
		purposeList : "",
		purposeDtlList : "",
		userBankList : "",
		insert : function(){			
			
			if(this.validityCheck()) return;			
			
			let list = new Array();			
			let checkSet = new Set();
			let recordDate = "";
			
			for(let i=0; i<ledgerInsert.idx; i++){
				
				let userBankSeq = Number($("#bankName_"+i+" option:selected").val());
				let bankAcc = "";
				if(userBankSeq === 0){
					bankAcc = "readyMoney";
				}else{
					bankAcc = $("#bankName_"+i+" option:selected").text().split("(")[1].replace(")", "");					
				}
				
				let purposeSeq = Number($("#purpose_"+i+" option:selected").val());
				let purposeDtlSeq = Number($("#purposeDtl_"+i+" option:selected").val());
				
				let insertData = {
						idx : i,
						userSeq : $("#userSeq").val(),
						recordDate : $("#date_"+i).val() + " " +$("#time_"+i).val(),
						content : $("#content_"+i).val(),						
						purposeSeq : purposeSeq,					
						purposeDtlSeq : purposeDtlSeq,					
						userBankSeq : userBankSeq,
						moveToSeq : Number($("#moveTo_"+i+" option:selected").val()),
						bankAccount : bankAcc,
						inExpMoney : purposeSeq == 0 ? (Number($("#inExpMoney_"+i).val())*-1) : Number($("#inExpMoney_"+i).val())
				}
				checkSet.add(insertData.recordDate);
				list.push(insertData);
				
				//recordDate += insertData.recordDate + ",";
			}			
			
			// recordDate 중복체크
			if(checkSet.size != ledgerInsert.idx){
				alert("중복된 입력시간이 존재합니다.");
				checkSet = null;
				return;
			}
			
			// recordDate DB 유니크 체크
			//console.log(recordDate);
			//alert(recordDate);
			
			let insertData = JSON.stringify(list);
			
			$.ajax({		
				type: 'POST',
				url: getContextPath()+'/ajax/ledgerInsert.do',
				data: {
					insertData : insertData
				},
				dataType: 'text',
			    success : function(data, stat, xhr) {  
			    	alert(data+" row Insert success.");
			    	ledgerSide.pageSubmit("Main");
			    },
			    error : function(xhr, stat, err) {
			    	/*console.log(xhr);
			    	console.log(stat);
			    	console.log(err);*/
			    	alert("insert error");
			    }
			});
			
		},
		add : function(){		
			let idx = ledgerInsert.idx;
			if(idx === 10){
				alert("maxCnt: 10");
				return;
			}
			
			$("#ledgerInsertForm").append("<div id='ledgerInsert_"+idx+"'></div>");
			
			
			$("#ledgerInsert_"+idx).append("<span style='border: 1px solid black;'>"+(idx+1)+"</span>");
			
			$("#ledgerInsert_"+idx).append("<input id='date_"+idx+"' name='date_"+idx+"' type='date' value=''>");
			$("#ledgerInsert_"+idx).append("<input id='time_"+idx+"' name='time_"+idx+"' type='time' value=''>");
			$("#date_"+idx).val(isDate.today());
			$("#time_"+idx).val(isTime.addCurSec(idx));
			
			$("#ledgerInsert_"+idx).append("<input id='content_"+idx+"' name='content_"+idx+"' type='text' value=''>");			
			$("#ledgerInsert_"+idx).append("<select id='purpose_"+idx+"' name='purpose_"+idx+"' onchange='purposeChanged(this, "+idx+")'></select>");
			
			$("#purpose_"+idx).append("<option value=''>사용목적 선택</option>").append("<option value='0'>금액이동</option>");			
			for(let i=0; i<ledgerInsert.purposeList.length; i++){
				$("#purpose_"+idx).append("<option value='"+ ledgerInsert.purposeList[i]["purposeSeq"] +"'>"+ledgerInsert.purposeList[i]["purpose"]+"</option>");		
			}
			
			$("#ledgerInsert_"+idx).append("<select id='purposeDtl_"+idx+"' name='purposeDtl_"+idx+"'></select>");
			$("#purposeDtl_"+idx).append("<option value=''>상세사용목적 선택</option>");	
			
			/*//현금이동 from
			$("#ledgerInsert_"+idx).append("<select id='moveFrom_"+idx+"' name='moveFrom_"+idx+"' style='display: none;'></select>");*/
			
			$("#ledgerInsert_"+idx).append("<select id='bankName_"+idx+"' name='bankName_"+idx+"'></select>");
			//현금이동 to
			$("#ledgerInsert_"+idx).append("<select id='moveTo_"+idx+"' name='moveTo_"+idx+"' style='display: none;'></select>");
			
			
			
			
			
			//현금이동 from
			$("#moveFrom_"+idx).append("<option value=''>from 선택</option>").append("<option value=0>현금</option>");		
			for(let i=0; i<ledgerInsert.userBankList.length; i++){
				if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
					$("#moveFrom_"+idx).append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
					"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
				}
			}
			//현금이동 to
			$("#moveTo_"+idx).append("<option value=''>to 선택</option>").append("<option value=0>현금</option>");		
			for(let i=0; i<ledgerInsert.userBankList.length; i++){
				if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
					$("#moveTo_"+idx).append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
					"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
				}
			}
			
			
			
			
			
			
			
			$("#bankName_"+idx).append("<option value=''>현금/은행 선택</option>").append("<option value=0>현금</option>");		
			for(let i=0; i<ledgerInsert.userBankList.length; i++){
				if(ledgerInsert.userBankList[i]["bankNowUseYN"] === "Y"){
					$("#bankName_"+idx).append("<option value='"+ ledgerInsert.userBankList[i]["userBankSeq"] +"'>"+ledgerInsert.userBankList[i]["bankName"]+
					"("+ledgerInsert.userBankList[i]["bankAccount"]+")</option>");
				}
			}
			$("#ledgerInsert_"+idx).append("<input id='inExpMoney_"+idx+"' name='inExpMoney_"+idx+"' type='text'>");			
			ledgerInsert.idx++;
		},
		del : function(){
			if(ledgerInsert.idx>1){
				ledgerInsert.idx--;
				$('#ledgerInsert_'+ledgerInsert.idx).remove();
			}
		},
		validityCheck : function(){
			let idx = this.idx;
			
			for(let i=0; i<idx; i++){
				let str = "";
				
				//date
				str = $("#date_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 날짜가 입력되지 않았습니다.");
					$("#date_"+i).focus();
					return true;
				}else if(!(str.indexOf("-") == 4 && str.lastIndexOf("-") == 7)){
					alert((i+1)+"행의 날짜 형식이 맞지 않습니다. \nex) 2000-01-01");
					$("#date_"+i).focus();
					return true;
				}
				
				//time
				str = $("#time_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 날짜가 입력되지 않았습니다.");
					$("#time_"+i).focus();
					return true;
				}/*else if(!(str.indexOf(":") == 2 && str.lastIndexOf(":") == 5)){
					alert((i+1)+"행의 시간 형식이 맞지 않습니다. \nex) 20:00:00");
					$("#time_"+i).focus();
					return true;
				}*/
				
				//content
				str = $("#content_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 내용이 입력되지 않았습니다.");
					$("#content_"+i).focus();
					return true;
				}
				
				//purpose
				str = $("#purpose_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 사용목적이 선택되지 않았습니다.");
					$("#purpose_"+i).focus();
					return true;
				}
				
				//bank
				str = $("#bankName_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 현금/은행 이 선택되지 않았습니다.");
					$("#bankName_"+i).focus();
					return true;
				}
				
				//moveTo
				str = $("#purpose_"+i).val();
				if(Number(str) == 0){					
					
					let move = $("#moveTo_"+i+" option:selected").val();
					if(emptyCheck.isEmpty(move)){
						alert((i+1)+"행의 이동 금액 대상을 선택되지 않았습니다.");
						$("#moveTo_"+i).focus();
						return true;
					}
					
					if(move == $("#bankName_"+i).val()){
						alert("금액이동은 같은 곳으로 이동할 수 없습니다.");
						$("#moveTo_"+i).focus();
						return true;
					}
					
					let money = Number($("#inExpMoney_"+i).val());
					if(money <= 0){
						alert("금액이동시 "+(i+1)+"행은 0이하값을 입력할 수 없습니다.");
						$("#inExpMoney_"+i).focus();
						return true;
					}
					
					
				}
				
				
				
				
				
				//money
				str = $("#inExpMoney_"+i).val();
				if(emptyCheck.isEmpty(str)){
					alert((i+1)+"행의 금액이 입력되지 않았습니다.");
					$("#inExpMoney_"+i).focus();
					return true;
				}
				return false;
			}
		}
}

//엑셀양식 다운로드
function excelStyleDown(){
	if(confirm("엑셀양식을 다운로드 하시겠습니까?")){
		$("#excelStyle").attr("action", common.path()+"/excelStyleDown.do").submit();
		
	}else{
		return;
	}
}

//엑셀 업로드
function excelUpload(){
	
	let formData = new FormData();
	formData.append("file", $("input[name=dataFile]")[0].files[0]);						
	$.ajax({
	    url: common.path()+'/ajax/insertExcelUpload.do',
	    data:  formData, 
	    processData: false,
	    contentType: false,
	    type: 'POST',
	    success: function(data){
	    	
	    	
	    },
	    error : function(request,status,error){			    	
	    	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    }
	});
	
}