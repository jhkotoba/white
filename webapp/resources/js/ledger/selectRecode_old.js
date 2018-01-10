/* 
 * selectRecode.js
 */
//최근 자료 검색
function latestSelectRecode(userSeq){
	if(emptyCheck.isEmpty(userSeq)){
		console.log("userSeq IS NULL");
		alert("로그인을 다시 하세요.");
		location.href = getContextPath()+"/loginPage.do";
		return;
	}
	
	$.ajax({		
		type: 'POST',
		url: 'latestLedgerInquire.do',	
		data: {
			userSeq : userSeq			
		},
		dataType: 'json',
	    success : function(data, stat, xhr) {	    	
	    	if(data["session"] === "IS_NULL"){
	    		alert("세선정보가 없습니다. 다시 로그인을 다시 하세요.");
	    		location.href = getContextPath()+"loginPage.do";
	    	}else{
	    		selectMainRecodeView(userSeq, data["userBankList"], data["moneyRecordList"]);
	    	}
	    	let recordList = data["moneyRecordList"];
	    	$("#latestCnt").text(recordList.length +" 건");
	    	$("#DetailDate").text(recordList[recordList.length-1]['recordDate']+ " ~ " + recordList[0]['recordDate']);
	    },
	    error : function(xhr, stat, err) {
	    	alert(err);
	    	console.log(err);
	    }
	});
}

function selectRecode(userSeq){
	
	var startDate = $('#startDate').val();
	var endDate = $('#endDate').val();
	
	//null check
	if(emptyCheck.isEmpty(userSeq)){
		console.log("userSeq IS NULL");
		alert("로그인을 다시 하세요.");
		location.href = getContextPath()+"/loginPage.do";
		return;
	}else if(emptyCheck.isEmpty(startDate)){
		console.log("startDate IS NULL");
		alert("시작날짜를 입력하세요.");
		return;
	}else if(emptyCheck.isEmpty(endDate)){
		console.log("endDate IS NULL");
		alert("끝나는 날짜는 입력하세요.");
		return;
	}
		
	$.ajax({		
		type: 'POST',
		url: 'ledgerInquire.do',
		data: {
			userSeq : userSeq,
			startDate : startDate,
			endDate : endDate
		},
		dataType: 'json',
	    success : function(data, stat, xhr) {	    	
	    	if(data["session"] === "IS_NULL"){
	    		alert("세선정보가 없습니다. 다시 로그인을 다시 하세요.");
	    		location.href = getContextPath()+"/loginPage.do";
	    	}else{
	    		selectMainRecodeView(userSeq, data["userBankList"], data["moneyRecordList"]);
	    	}
	    },
	    error : function(xhr, stat, err) {
	    	alert(err);
	    	console.log(err);
	    }
	});
}

function selectMainRecodeView(userSeq, bankList, recordList){
	
	$("#ledgerInfo").empty();
	
	//목록 생성/출력
	let view = "<table id='recodeTable' border=1><tr>";
	
	if(selectRecode.viewType === 'select'){
		view += "<th><input type='checkbox'></th>";
	}
	
	view +=	"<th>No</th>" +
				"<th>시간</th>" +
				"<th>내용</th>" +
				"<th>구분</th>" +
				"<th>사용수단</th>" +
				"<th>수입/지출</th>" +				
				"<th>현금</th>";
	
	let bankMoneyCheck = false;
	for(let i=0; i<bankList.length; i++){
		bankMoneyCheck = false;
		
		if(bankList[i]["bankNowUseYN"] === "N"){				
			for(let j=0; j<recordList.length; j++){
				if(bankList[i]["bankAccount"] === recordList[j]['bankAccount'] && !(recordList[j]['resultBankMoney'] === 0)){					
					bankMoneyCheck = true;
				}
			}
		}else{
			bankMoneyCheck = true;		
		}
		
		if(bankMoneyCheck === true){		
			view += "<th>"+bankList[i]["bankName"] + "<br>(" + bankList[i]["bankAccount"]+")</th>";
		}else{
			bankList[i]["bankAccount"] = "NODATA";			
		}		
	}				
	view +=	"<th>합계</th></tr>";
	for(let i=0; i<recordList.length; i++){
		view += "<tr>";
		if(selectRecode.viewType === 'select'){
			view += "<th><input id='recordSeq_"+i+" 'type='checkbox' value="+recordList[i]['recordSeq']+"></th>";
		}
		view += "<td>"+(i+1)+"</td>"+
		"<td id='recordDate_"+i+"'>"+recordList[i]['recordDate']+"</td>"+
		"<td id='content_"+i+"'>"+recordList[i]['content']+"</td>" +
		"<td id='purpose_"+i+"'>"+recordList[i]['purpose']+"</td>" +
		"<td id='bankName_"+i+"'>"+recordList[i]['bankName'];		
		
		if(recordList[i]['bankAccount'] === 'readyMoney'){
			view += "</td>"+
			"<td id='inExpMoney_"+i+"'>"+recordList[i]['inExpMoney']+"</td>"+
			"<td id='readyMoney_"+i+"'>"+recordList[i]['readyMoney']+"</td>";
		}else{
			view += "("+recordList[i]['bankAccount']+")</td>"+
			"<td id='inExpMoney_"+i+"'>"+recordList[i]['inExpMoney']+"</td>"+
			"<td id='readyMoney_"+i+"'>n</td>";
		}	
		
		for(let j=0; j<bankList.length; j++){			
			if(bankList[j]["bankAccount"] === recordList[i]['bankAccount']){
				view += "<td id='resultBankMoney_"+ bankList[j]['bankAccount'] + "_" + +i+"'>"+recordList[i]['resultBankMoney']+"</td>";
			}else{
				if(bankList[j]["bankAccount"] != "NODATA"){
					view += "<td id='resultBankMoney_"+ bankList[j]['bankAccount'] + "_" + +i+"'>n</td>";
				}				
			}			
		}		
		view +="<td id='moneySum_"+i+"'>s</td></tr>";	
		
	}
	view += "</table>";
	$("#ledgerInfo").append(view);
	
	//빈곳 채워넣기
	var empList = new Array();  // readyMoney + resultBankMoney's
	var empTagIdList = new Array();
	
	empTagIdList.push("readyMoney");
	empList.push(
			$("#readyMoney_"+String(recordList.length-1)).text());
	
	for(let i=0; i<bankList.length; i++){
		empTagIdList.push("resultBankMoney_"+bankList[i]['bankAccount']);
		empList.push(
				$("#resultBankMoney_"+bankList[i]['bankAccount']+"_"+String(recordList.length-1)).text());		
	}

	for(let i=0; i<empTagIdList.length; i++){
		
		let tagId = empTagIdList[i];
		
		if(empList[i] === "n"){
			
			$.ajax({		
				type: 'POST',
				url: 'ledgerEmpAdd.do',	
				async: false,
				data: {
					userSeq : userSeq,
					recordSeq : $("#recordSeq_"+String(recordList.length-1)).text(),
					bankAccount : (empTagIdList[i] === "readyMoney") ? "readyMoney" : empTagIdList[i].split('_')[1],
					recordDate : $("#recordDate_"+String(recordList.length-1)).text()			
				},			
				dataType: 'text',
			    success : function(data, stat, xhr) {
			    	
			    	if(emptyCheck.isEmpty(data.trim())){
			    		emptySpaceAdd(String(0), tagId, i+1);
			    	}else{
			    		emptySpaceAdd(data.trim(), tagId, i+1);
			    	}
			    },
			    error : function(xhr, stat, err) {
			    	alert(err);
			    	console.log(err);
			    }
			});
		}else{
			emptySpaceAdd(empList[i], tagId, i+1);			
		}		
	}
	
	function emptySpaceAdd(addData, tagId, cnt, maxcnt){
		
		//emptySpaceAdd
		for(let i=recordList.length; i>0; i--){	 
			
			if( i === Number(1)){					
				if( $("#"+tagId+"_"+String(i-1)).text() === "n"){
					$("#"+tagId+"_"+String(i-1)).text(addData);
				}
			}else{
				if( $("#"+tagId+"_"+String(i-1)).text() === "n"){
					$("#"+tagId+"_"+String(i-1)).text(addData);
				}else{
					addData = $("#"+tagId+"_"+String(i-1)).text();
				}
			}			
    	}
		
		//emptySpaceSum
		if(empTagIdList.length === cnt){
			for(let i=0; i<recordList.length; i++){	
				let moneySum = 0;
				
				for(let j=0; j<empTagIdList.length; j++){					
					moneySum += Number($("#"+empTagIdList[j]+"_"+String(i)).text());
				}
				$("#moneySum_"+String(i)).text(String(moneySum));
			}			
		}
		
		//데이터 초기화
		selectRecode.viewType = "main";
	}
}