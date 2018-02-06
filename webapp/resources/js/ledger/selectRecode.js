/* 
 * selectRecode.js
 */
let selectRecode = {
		userSeq : "",
		startDate : "",
		endDate :  "",	
		
		viewType : "main",			
		bankMoneyCheck : false,
		length : 0,
		
		//유효성 검사
		validityCheck : function(){
			
			if(emptyCheck.isEmpty(this.userSeq)){
				console.log("userSeq IS NULL");
				alert("로그인을 다시 하세요.");
				location.href = getContextPath()+"/loginPage.do";
				return;
			}				
			if(this.viweType === "select"){
				if(emptyCheck.isEmpty(this.startDate)){
					console.log("startDate IS NULL");
					alert("시작날짜를 입력하세요.");
					return;
				}else if(emptyCheck.isEmpty(this.endDate)){
					console.log("endDate IS NULL");
					alert("끝나는 날짜는 입력하세요.");
					return;
				}
			}
		},		
		//최근 자료 Select
		latestSelect : function(){
			
			this.validityCheck();
			
			$.ajax({		
				type: 'POST',
				url: getContextPath()+'/ajax/latestLedgerInquire.do',	
				data: {
					userSeq : this.userSeq			
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {	    	
			    				    		
			    	selectRecode.view(data["userBankList"], data["moneyRecordList"]);
			    	
			    	let recordList = data["moneyRecordList"];
			    	$("#latestCnt").text(recordList.length +" 건");
			    	if(recordList.length > 0){
			    		$("#DetailDate").text(recordList[recordList.length-1]['recordDate']+ " ~ " + recordList[0]['recordDate']);
			    	}
			    	
			    },
			    error : function(xhr, stat, err) {
			    	alert(err);
			    	console.log(err);
			    }
			});
		},	
		//날짜별, 목적 검색
		recodeSearch : function(type){
			
			this.viewType = type;
			
			this.startDate = $('#startDate').val();
			this.endDate = $('#endDate').val();
			
			this.validityCheck();
			
			let purSeqSearch = $("#purSelect").val();
				
			$.ajax({		
				type: 'POST',
				url: getContextPath()+'/ajax/ledgerInquire.do',
				data: {
					userSeq : this.userSeq,
					startDate : this.startDate,
					endDate : this.endDate,
					purSeqSearch : purSeqSearch
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {
			    		selectRecode.view(data["userBankList"], data["moneyRecordList"]);			    	
			    },
			    error : function(xhr, stat, err) {
			    	alert(err);
			    	console.log(err);
			    }
			});
		},
		//select 후 view
		view : function(bankList, recordList){
			
			this.length = recordList.length;			
			$("#ledgerInfo").empty();
			
			//목록 생성/출력
			let view = "<table id='recodeTable' border=1 style='font-size: 10px;'><tr>";
			
			if(this.viewType === 'select'){
				view += "<th><input type='checkbox' id='checkTitle' name='checkTitle' onchange='ledgerSelect.checkboxAll()'></th>";
			}
			
			view +=	"<th>No</th>" +
						"<th>시간</th>" +
						"<th>내용</th>" +
						"<th>구분</th>" +
						"<th>상세구분</th>" +
						"<th>사용수단</th>" +
						"<th>수입/지출</th>" +				
						"<th>현금</th>";			
			
			for(let i=0; i<bankList.length; i++){
				this.bankMoneyCheck = false;
				
				if(bankList[i]["bankNowUseYN"] === "N"){				
					for(let j=0; j<recordList.length; j++){
						if(bankList[i]["bankAccount"] === recordList[j]['bankAccount'] && !(recordList[j]['resultBankMoney'] === 0)){					
							this.bankMoneyCheck = true;
						}
					}
				}else{
					this.bankMoneyCheck = true;		
				}
				
				if(this.bankMoneyCheck === true){		
					view += "<th>"+bankList[i]["bankName"] + "<br>(" + bankList[i]["bankAccount"]+")</th>";
				}else{
					bankList[i]["bankAccount"] = "NODATA";			
				}		
			}				
			view +=	"<th>합계</th></tr>";	
			
			let viewTd = ""
			for(let i=0; i<recordList.length; i++){
				
				
			
			
				view += "<input type='hidden' id='bankSeq_"+i+"' value="+(recordList[i]['bankSeq']==undefined ? 0 : recordList[i]['bankSeq'])+">"
						+"<tr "+ viewTd +">";
				if(this.viewType === 'select'){
					view += "<th><input id='checkbox_"+i+"' name='checkbox' type='checkbox' value="+recordList[i]['recordSeq']
						+ " onclick='ledgerSelect.checkboxOne("+i+")'></th>";
				}
				
				/*let purpose = "";
				if(emptyCheck.isEmpty(recordList[i]['purpose']) === true){				
					purpose = "취소";
				}else{
					purpose = recordList[i]['purpose'];
				}*/
				let purpose = "";
				if(recordList[i]['purSeq'] === -1){				
					purpose = "deleted"; //목적정보 없을때 표시  //-1은 목적정보를 삭제했을때 seq값, //추가 엑셀업로드시 해당정보 없을때 -1로 insert
				}else if(recordList[i]['purSeq'] === 0){
					purpose = "금액이동";		
				}else{
					purpose = recordList[i]['purpose'];
				}						
				
				view += "<td>"+(i+1)+"</td>"+
				"<td id='recordDate_"+i+"'><p id='recordDateP_"+i+"'>"+recordList[i]['recordDate']+"</p></td>"+
				"<td id='content_"+i+"'><p id='contentP_"+i+"'>"+recordList[i]['content']+"</p></td>" +
				"<td id='purSeq_"+i+"' style='display:none'>"+recordList[i]['purSeq']+"</td>" +
				"<td id='purpose_"+i+"'><p id='purposeP_"+i+"'>"+purpose+"</p></td>" +
				
				"<td id='purposeDtlSeq_"+i+"' style='display:none'>"+recordList[i]['purDetailSeq']+"</td>" +
				"<td id='purposeDtl_"+i+"'><p id='purposeDtlP_"+i+"'>"+recordList[i]['purDetail']+"</p></td>" +
				
				///금액이동일때 AAA->BBB 형식으로 나오게 start
				//원본//"<td id='bankName_"+i+"'>"+recordList[i]['bankName'];	
				"<td id='bankName_"+i+"'>"+recordList[i]['bankName'];	
				//버그있음
				/*if(recordList[i]['groupSeq']!==0){
					view+="<td id='bankName_"+i+"'>"+recordList[i+1]['bankName'];
					
					if(recordList[i+1]['bankAccount'] !== 'readyMoney'){					
						view += "("+recordList[i+1]['bankAccount']+")</p>";
					}					
					view+="->"+recordList[i]['bankName'];
					
				}else{
					view+="<td id='bankName_"+i+"'>"+recordList[i]['bankName']
				}*/
				///test 금액이동일때 AAA->BBB 형식으로 나오게 end 
				
				if(recordList[i]['bankAccount'] === 'readyMoney'){
					view += "</td>"+
					"<td id='inExpMoney_"+i+"'>"+recordList[i]['inExpMoney']+"</td>"+
					"<td id='readyMoney_"+i+"'>"+recordList[i]['readyMoney']+"</td>";
				}else{
					view += "("+recordList[i]['bankAccount']+")</p></td>"+
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
				
				//금액 수정시 2행을 사용하기 때문에 첫번째 행은 보이고 2번째 행은 가림
				if(recordList[i]['groupSeq']!==0){
					viewTd = "style='display: none;'";
				}else{
					viewTd = "";
				}
				
			}
			view += "</table>";
				
			$("#ledgerInfo").append(view);
			
					
			//빈곳 채워넣기
			let empList = new Array();  // readyMoney + resultBankMoney's
			let empTagIdList = new Array();
			let empBankSeq = new Array();
			
			empTagIdList.push("readyMoney");
			empList.push(
					$("#readyMoney_"+String(recordList.length-1)).text());
			empBankSeq.push(0);
			
			for(let i=0; i<bankList.length; i++){
				empTagIdList.push("resultBankMoney_"+bankList[i]['bankAccount']);
				empList.push(
						$("#resultBankMoney_"+bankList[i]['bankAccount']+"_"+String(recordList.length-1)).text());
				empBankSeq.push(bankList[i]['bankSeq']);
			}

			for(let i=0; i<empTagIdList.length; i++){
				
				let tagId = empTagIdList[i];				
				
				if(empList[i] === "n"){
					
					$.ajax({		
						type: 'POST',
						url: getContextPath()+'/ajax/ledgerEmpAdd.do',	
						async: false,
						data: {
							userSeq : this.userSeq,							
							bankAccount : (empTagIdList[i] === "readyMoney") ? "readyMoney" : empTagIdList[i].split('_')[1],
							bankSeq : empBankSeq[i],
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
				this.viewType = "main";	
				this.startDate = "";
				this.endDate =  "";
				this.bankMoneyCheck = false;
			}
			
		}
}