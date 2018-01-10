/**
 * ledgerSetupPurpose.js
 */


$(document).ready(function(){
	//목적 리스트
	purSetup.list = common.clone(purposeList);	
	purSetup.view();
	
	//상세 목적 리스트
	purDtlSetup.list = common.clone(purposeDtlList);
	
	$("#purAdd").click(function(){
		let length = Number(purSetup.list.length+1);		
		purSetup.list.push({purOrder: length, purposeSeq: 0, purpose: ""});
		purSetup.view();
	});
	
	$("#purCancel").click(function(){
		purSetup.list = common.clone(purposeList);		
		purSetup.delList.splice(0, purSetup.delList.length);		
		purSetup.view();
		
		purDtlSetup.list = common.clone(purposeDtlList);		
		purDtlSetup.delList.splice(0, purDtlSetup.delList.length);		
		purDtlSetup.view(-1);
	});	
	
	$("#purDtlAdd").click(function(){
		let length = Number(purDtlSetup.list.length+1);		
		purDtlSetup.list.push({purDetail: "", purposeSeq: purDtlSetup.nowPurSeq, purDtlOrder: length, purDetailSeq:0});
		purDtlSetup.view(purDtlSetup.nowPurSeq);
	});
	
	$("#purDtlCancel").click(function(){		
		purDtlSetup.list = common.clone(purposeDtlList);		
		purDtlSetup.delList.splice(0, purDtlSetup.delList.length);		
		purDtlSetup.view(purDtlSetup.nowPurSeq);
	});	
	
	$("#purSave").click(function(){
				
		let checkSet = new Set();
		let insertList = new Array();
		let updateList = new Array();

		//빈 값 체크, insert값 추출, update값 추출
		for(let i=0; i<purSetup.list.length; i++){
			if( str.trim(purSetup.list[i]["purpose"]) === ""){
				alert("목적: 빈 값은 저장할 수 없습니다.");
				$("#purIdx_"+i).focus();
				return;
			}
			if(purSetup.list[i]["purposeSeq"] === 0){
				insertList.push(purSetup.list[i]);
			}else if(purSetup.list[i]["purposeSeq"] < 0){
				purSetup.list[i]["purposeSeq"] = Math.abs(purSetup.list[i]["purposeSeq"]);
				updateList.push(purSetup.list[i]);
			}
			
			checkSet.add(purSetup.list[i]["purpose"]);
			
		}
		//중복 값 체크
		if(checkSet.size != purSetup.list.length){
			alert("목적: 중복된 값이 존재 합니다.");
			return;
		}
		
		//수정 사항 체크
		if(updateList.length === 0 && insertList.length === 0 && purSetup.delList.length === 0){
			alert("목적: 추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}		
		
		if(confirm("목적을 저장하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/ajax/ledgerSetupPurpose.do',
				data: {
					/*userSeq : $("#userSeq").val(),*/
					insertList : insertList.length === 0 ? "" : JSON.stringify(insertList),				
					updateList : updateList.length === 0 ? "" : JSON.stringify(updateList),					
					deleteList : purSetup.delList.length === 0 ? "" : JSON.stringify(purSetup.delList)		
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {  
			    	alert("목적: 추가, 수정, 삭제하였습니다.");
			    	purposeList = data;
			    	console.log(data);
			    	purSetup.list = common.clone(purposeList);
			    	purSetup.delList.splice(0, purSetup.delList.length);
			    	purSetup.view();
			    },
			    error : function(xhr, stat, err) {			    	
			    	alert("setup error");
			    }
			});
		}
	});
	
	
	$("#purDtlSave").click(function(){
		
				
		let checkSet = new Set();
		let insertDtlList = new Array();
		let updateDtlList = new Array();		
		
		//console.log(purDtlSetup);
		
		//빈 값 체크, insert값 추출, update값 추출
		for(let i=0; i<purDtlSetup.list.length; i++){
			if( str.trim(purDtlSetup.list[i]["purDetail"]) === ""){
				alert("상세목적: 빈 값은 저장할 수 없습니다.");
				$("#purDtlIdx_"+i).focus();
				return;
			}
			if(purDtlSetup.list[i]["purDetailSeq"] === 0){
				insertDtlList.push(purDtlSetup.list[i]);
			}else if(purDtlSetup.list[i]["purDetailSeq"] < 0){
				purDtlSetup.list[i]["purDetailSeq"] = Math.abs(purDtlSetup.list[i]["purDetailSeq"]);
				updateDtlList.push(purDtlSetup.list[i]);
			}			
			checkSet.add(purDtlSetup.list[i]["purDetail"]);
			
		}
		
		//중복 값 체크
		if(checkSet.size != purDtlSetup.list.length){
			alert("상세목적: 중복된 값이 존재 합니다.");
			return;
		}
		
		//수정 사항 체크
		if(updateDtlList.length === 0 && insertDtlList.length === 0 && purDtlSetup.delList.length === 0){
			alert("상세목적: 추가, 수정, 삭제할 대상이 없습니다.").
			return;
		}	
		
		//alert("테스트 중이여서 여기까지 끊음.");
		//return;
		
		//console.log(insertDtlList);
		//console.log(updateDtlList);
		//console.log(purDtlSetup.delList);
		
		if(confirm("상세목적을 저장하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/ajax/ledgerSetupDtlPurpose.do',
				data: {
					userSeq : $("#userSeq").val(),
					insertDtlList : insertDtlList.length === 0 ? "" : JSON.stringify(insertDtlList),				
					updateDtlList : updateDtlList.length === 0 ? "" : JSON.stringify(updateDtlList),					
					deleteDtlList : purDtlSetup.delList.length === 0 ? "" : JSON.stringify(purDtlSetup.delList)		
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {  
			    	alert("상세목적: 추가, 수정, 삭제하였습니다.");
			    	purposeDtlList = data;
			    	//console.log(data);
			    	purDtlSetup.list = common.clone(purposeDtlList);
			    	purDtlSetup.delList.splice(0, purDtlSetup.delList.length);
			    	purDtlSetup.view(purDtlSetup.nowPurSeq);
			    },
			    error : function(xhr, stat, err) {			    	
			    	alert("setup error");
			    }
			});
		}
	});
	
	
	
	
});

let purSetup = {
		list : null,		
		delList : new Array(),		
		up : function(i){		
			if(i < 1) return;
			else{				
				let temp = this.list[i-1]["purposeSeq"];
				this.list[i-1]["purposeSeq"] = this.list[i]["purposeSeq"];
				this.list[i]["purposeSeq"] = temp;
				
				temp = this.list[i-1]["purpose"];
				this.list[i-1]["purpose"] = this.list[i]["purpose"];
				this.list[i]["purpose"] = temp;
				
				this.list[i-1]["purOrder"] = Number($("#tbNo_"+(i-1)).text());
				this.list[i]["purOrder"] = Number($("#tbNo_"+i).text());
				
				
				let seq = this.list[i-1]["purposeSeq"];			
				if(seq > 0)	this.list[i-1]["purposeSeq"] = seq*-1;
				seq = this.list[i]["purposeSeq"];			
				if(seq > 0)	this.list[i]["purposeSeq"] = seq*-1;
			}
			this.view();	
		},
		down : function(i){	
			if((this.list.length-1) <= i){				
				return;
			}else{
				let temp = this.list[i+1]["purposeSeq"];
				this.list[i+1]["purposeSeq"] = this.list[i]["purposeSeq"];
				this.list[i]["purposeSeq"] = temp;
				
				temp = this.list[i+1]["purpose"];
				this.list[i+1]["purpose"] = this.list[i]["purpose"];
				this.list[i]["purpose"] = temp;
				
				this.list[i+1]["purOrder"] = Number($("#tbNo_"+(i+1)).text());
				this.list[i]["purOrder"] = Number($("#tbNo_"+i).text());
				
				let seq = this.list[i+1]["purposeSeq"];			
				if(seq > 0)	this.list[i+1]["purposeSeq"] = seq*-1;
				seq = this.list[i]["purposeSeq"];			
				if(seq > 0)	this.list[i]["purposeSeq"] = seq*-1;
			}
			this.view();
		},		
		view : function(){
			$("#purposeInfo").empty();
			
			let tag = "<table id='purTb' border=1><tr><th>순번</th><th>목적</th><th>수정/삭제</th></tr>";			
			for(let i=0; i<this.list.length; i++){				
				tag += "<tr><td id='tbNo_"+i+"'>"+(i+1)+"</td>"
					+ "<td id='purSeqIdx_"+i+"' style='display: none'>"+this.list[i]["purposeSeq"]+"</td>"
					+ "<td><input id='purIdx_"+i+"' type='text' value='"+this.list[i]["purpose"]
					+ "' onkeyup='purSetup.change("+i+", \"#purIdx_"+i+"\")'></td>"				
					+ this.btnAppend(i, this.list[i]["purposeSeq"]);				
			}	
			$("#purposeInfo").append(tag+"</table>");
			
		},
		btnAppend : function(idx, purSeq){			
			let tag = "<td><button onclick='purSetup.purDtlCall("+purSeq+")'>상세보기</button>"
			+ "<button onclick='purSetup.up("+idx+")'>위</button>"
	 		+ "<button onclick='purSetup.down("+idx+")'>아래</button>"
			+ "<button onclick='purSetup.del("+idx+")'>삭제</button><br></td></tr>";
			return tag;
		},
		purDtlCall : function(purSeq){
			purDtlSetup.list = common.clone(purposeDtlList);
			purDtlSetup.view(purSeq);
		},
		del : function(idx){
			this.list[idx]["purposeSeq"] = Math.abs(this.list[idx]["purposeSeq"]);
			
			if(this.list[idx]["purposeSeq"] !== 0){
				this.delList.push(this.list[idx]);
			}			
			
			this.list.splice(idx, 1);			
			for(let i=idx; i<this.list.length; i++){
				this.list[i]["purOrder"] = this.list[i]["purOrder"]-1;
			}
			this.view();
			
		},
		change : function(i, purIdx){
			let seq = this.list[i]["purposeSeq"];			
			if(seq > 0)	this.list[i]["purposeSeq"] = seq*-1;			
			
			this.list[i]["purpose"] = str.trim($(purIdx).val());
		}
	}

//상세목적 
let purDtlSetup = {
		nowPurSeq : 0,
		list : null,		
		delList : new Array(),
		view : function(purSeq){
			$("#purposeDtlInfo").empty();		
							
			if(purSeq===-1){
				common.allHide(
						["purDtlAdd","purDtlCancel","purDtlSave"]);				
				return;
			}else{
				common.allShow(
						["purDtlAdd","purDtlCancel","purDtlSave"]);				
			}
			
			this.nowPurSeq = purSeq;
			
			let tag = "<table id='purDtlTb' border=1><tr><th>순번</th><th>상세목적</th><th>수정/삭제</th></tr>";		
			for(let i=0; i<this.list.length; i++){	
				if(purSeq===this.list[i]["purposeSeq"]){
					tag += "<tr><td id='tbDtlNo_"+i+"'>"+(i+1)+"</td>"
						+ "<td id='purDtlSeqIdx_"+i+"' style='display: none'>"+this.list[i]["purDetailSeq"]+"</td>"
						+ "<td><input id='purDtlIdx_"+i+"' type='text' value='"+this.list[i]["purDetail"]
						+ "' onkeyup='purDtlSetup.change("+i+", \"#purDtlIdx_"+i+"\")'></td>"				
						+ "<td><button onclick='purDtlSetup.del("+i+")'>삭제</button><br></td></tr>";		
				}
			}	
			$("#purposeDtlInfo").append(tag+"</table>");
			
		},		
		del : function(idx){
			this.list[idx]["purDetailSeq"] = Math.abs(this.list[idx]["purDetailSeq"]);
			
			if(this.list[idx]["purDetailSeq"] !== 0){
				this.delList.push(this.list[idx]);
			}			
			
			this.list.splice(idx, 1);			
			for(let i=idx; i<this.list.length; i++){
				this.list[i]["purDtlOrder"] = this.list[i]["purDtlOrder"]-1;
			}
			this.view(purDtlSetup.nowPurSeq);
			
		},
		change : function(i, purDtlIdx){
			let seq = this.list[i]["purDetailSeq"];			
			if(seq > 0)	this.list[i]["purDetailSeq"] = seq*-1;			
			
			this.list[i]["purDetail"] = str.trim($(purDtlIdx).val());
		}
	}