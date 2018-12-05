<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	
	cfnCmmAjax("/ledger/selectPurBankList").done(function(data){
		recIn.init(data.purList, data.purDtlList, data.bankList).add().view();	
	});	
	
	$("#recAddBtn").click(function(){		
		recIn.add().view();
	});
	
	$("#recDelBtn").click(function(){		
		recIn.del().view();
	});
	
	$("#recInsertBtn").click(function(){
		let rtn = recIn.check();
		if(rtn.check === true){
			recIn.insert();
		}else{
			alert(rtn.msg);
		}
	});	
	
	$('#ledgerList').on("change keyup click input", function(event) {		
		switch(event.type){		
		case "keyup":
		case "change":			
			switch(event.target.id.split('_')[0]){		
			case "purSeq" :	
				recIn.appSel(event.target.value, event.target.id.split('_')[1]);		
			default :
				recIn.sync(event.target);
				break;
			}
			break;
		case "click":			
			let idx = Number(event.target.id.split('_')[1]);
			let name = event.target.id.split('_')[0];			
			if(name === "positionCopy" || name === "recordDateCopy" || name === "purSeqCopy" || name === "bankSeqCopy"){
				let targetId = name.replace("Copy", "");				
				let data = recIn.inList[idx][targetId];	
				
				for(let i=idx+1; i<recIn.inList.length; i++){
					recIn.inList[i][targetId] = data;
					$("#"+targetId+"_"+i).val(data);
					if(name === "purSeqCopy"){
						recIn.appSel(data, i);						
					}
				}
			}
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
		$("#ledgerList").empty();
	},
	
	add : function(){
		this.inList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:'', content:'', purSeq: '', purDtlSeq: '', bankSeq: '', moveSeq: '', money: ''});
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
			if(this.inList[i].recordDate === '' || this.inList[i].recordDate === null){
				check = {check : false, msg : (i+1) + "행의 날짜 데이터가 입력되지 않았습니다."};
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
			    	if(data < 0){
			    		alert("입력한 데이터가 정확하지 않습니다.");
			    		//mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    	}else{
			    		alert(data+" 개의 행이 저장되었습니다.");
			    		mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    	}
			    },
			    error : function(xhr, stat, err) {
			    	alert("insert error");
			    }
			});
		}			
	},
	view : function(){
		
		$("#ledgerList").empty();
		let selected = "";
		let tag = "";
		//#4C4C4C
		tag += "<table>";
		tag	+= "<tr class='table-head'>";
		tag += "<th style='width:3%;'>순서</th>";
		tag	+= "<th style='width:13%;'>날짜*</th>";
		tag	+= "<th style='width:12%;'>위치</th>";
		tag	+= "<th style='width:12%;'>내용*</th>";
		tag	+= "<th style='width:12%;'>목적*</th>";
		tag	+= "<th style='width:12%;'>상세목적</th>";
		tag	+= "<th style='width:12%;'>사용수단*</th>";
		tag	+= "<th style='width:12%;'>이동대상</th>";
		tag	+= "<th style='width:12%;'>수입 지출*</th>";
		tag += "</tr>";
	
		for(let i=0; i<this.inList.length; i++){
			tag += "<tr>";			
			tag += "<td>"+(i+1)+"</td>";
			tag += "<td><input id='recordDate_"+i+"' type='text' class='input-gray wth100p' value='"+this.inList[i].recordDate+"'>";
			tag += "<input id='recordDateCopy_"+i+"' type='button' value='↓' title='하단 일괄복사'></td>";
			tag += "<td><input id='position_"+i+"' type='text' class='input-gray wth100p' value='"+this.inList[i].position+"'>";
			tag += "<input id='positionCopy_"+i+"' type='button' value='↓' title='하단 일괄복사'></td>";			
			tag += "<td><input id='content_"+i+"' type='text' class='input-gray wth100p' value='"+this.inList[i].content+"'></td>";			
			tag += "<td><select id='purSeq_"+i+"' class='select-gray' onchange='recIn.sync(this); recIn.appSel(\""+this.inList[i].purSeq+"\","+i+");'>";
			tag += "<option value=''>선택</option>";
			tag += "<option "+ (String(this.inList[i].purSeq) === '0' ? "selected='selected'" : "" )+" value='0'>금액이동</option>";
			for(let j=0; j<this.purList.length; j++){
				String(this.inList[i].purSeq) === String(this.purList[j].purSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value="+this.purList[j].purSeq+">"+this.purList[j].purpose+"</option>";				
			}				
			tag += "</select>";
			tag += "<input id='purSeqCopy_"+i+"' type='button' value='↓' title='하단 일괄복사'></td>";
			tag += "<td><select id='purDtlSeq_"+i+"' class='select-gray'>";
			tag += "<option value=''>선택</option>";
			for(let j=0; j<this.purDtlList.length; j++){
				if(String(this.inList[i].purSeq) === String(this.purDtlList[j].purSeq)){
					String(this.inList[i].purDtlSeq) === String(this.purDtlList[j].purDtlSeq) ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value="+this.purDtlList[j].purDtlSeq+">"+this.purDtlList[j].purDetail+"</option>";
				}
			}	
			tag += "</select></td>";				
			tag += "<td><select id='bankSeq_"+i+"' class='select-gray'>";
			tag += "<option value=''>선택</option>";
			tag += "<option "+(this.inList[i].bankSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
			for(let j=0; j<this.bankList.length; j++){
				String(this.inList[i].bankSeq) === String(this.bankList[j].bankSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
			}				
			tag += "</select>";
			tag += "<input id='bankSeqCopy_"+i+"' type='button' value='↓' title='하단 일괄복사'></td>";
			tag += "<td><select class='select-gray' id='moveSeq_"+i+"'"+ (String(this.inList[i].purSeq) === '0' ? "" : "disabled='disabled'")+">";
			tag += "<option value=''>선택</option>";
			tag += "<option "+(this.inList[i].moveSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
			for(let j=0; j<this.bankList.length; j++){
				String(this.inList[i].moveSeq) === String(this.bankList[j].bankSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value="+this.bankList[j].bankSeq+">"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
			}				
			tag += "</select></td>";
			tag += "<td><input id='money_"+i+"' class='input-gray wth100p' type='text' value='"+this.inList[i].money+"'></td>";			
			tag += "</tr>";		
		}		
		tag +="</table>";
		
		
		$("#ledgerList").append(tag);
		
		//Air Datepicker 설정
		for(let i=0; i<this.inList.length; i++){
			$("#recordDate_"+i).datepicker({
				language: 'ko',
				timepicker: true,
				onSelect: function() {
					//rec.sync 연결
					$("#ledgerList #recordDate_"+i).trigger('change');
				}
			});
			$("#recordDate_"+i).data('datepicker');	
		}
	},
	appSel : function(value, idx){
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
		if('0' === String(value)){			
			$("#moveSeq_"+idx).removeAttr("disabled");
		}else{
			$("#moveSeq_"+idx).val('').prop("selected", true).attr("disabled","disabled");
		}
	}
}

</script>
	
<div id="recIn">	
	<button id="recAddBtn" type="button" class="btn-gray trs">추가</button>
	<button id="recDelBtn" type="button" class="btn-gray trs">삭제</button>
	<button id="recInsertBtn" type="button" class="btn-gray trs">저장</button>
</div>

<div class="space left"></div>

<div id="ledgerList">		
</div>