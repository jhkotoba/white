<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/bootstrap-4.1.1/css/bootstrap.min.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/bootstrap-4.1.1/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/cmmMemo.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	
	//ledger 메모 리스트 조회
	cmmMemo.create("ledgerMemo","ledger");
	
	//메인조회 리스트
	$("#startDate").val(isDate.addMonToday(-1));
	$("#endDate").val(isDate.today());
	$("span[name=date]").text($("#startDate").val() +" ~ "+$("#endDate").val());
		
	let param = {};	
	param.startDate = $("#startDate").val() + " 00:00:00";
	param.endDate = $("#endDate").val() + " 23:59:59";
	param.mode = "index";
	
	$.ajax({		
		url: common.path()+'/ledgerRe/selectRecordList.ajax',	
		data: param,
	    success : function(data) {	    	
	    	chart.view(data.recList);
	    	rec.initPB(data.purList, data.purDtlList, data.bankList).initRec("index", data.recList).view();
	    }
	});
	
	let chart = {
		view : function(recList){
			
			google.charts.load('current', {'packages':['corechart']});
			
			//comboChart
			let recCombo = new Array();
			let recAve = 0;
			
			recCombo.push(['Date', '지출']);
			if(recList.length === 0){
				recAve = 5000;
				recCombo.push(["No Data", 0]);
			}else{
				for(let i=0; i<recList.length; i++){
					if(recList[i].purSeq !== 0){
						if(recList[i].money < 0){						
							if(recCombo[recCombo.length-1][0] === recList[i].recordDate.split(" ")[0]){
								recCombo[recCombo.length-1][1] += Math.abs(recList[i].money);
								recAve += recCombo[recCombo.length-1][1];
							}else{
								recCombo.push([recList[i].recordDate.split(" ")[0], Math.abs(recList[i].money)]);
								recAve += recCombo[recCombo.length-1][1];
							}						
						}
					}				
				}
				recAve = Math.floor(recAve/recCombo.length);
			}
			
			google.charts.setOnLoadCallback(drawVisualization);
			function drawVisualization() {
				let data = google.visualization.arrayToDataTable(recCombo);

				let options = {
					axisTitlesPosition : 'none',
					chartArea: {
						width:'60%',
						height:'300px'
					},
					colors:['#F15F5F'],
					vAxis: {
						baseline : 0,
						viewWindow : {
							max : recAve*2,
							min : 0
						},
						viewWindowMode : 'maximized'
					},
					seriesType: 'bars',
					series: {5: {type: 'line'}}
				};

				let chart = new google.visualization.ComboChart(document.getElementById('comboChart'));
				chart.draw(data, options);
			}
			
			
			//donutChart
			let recDonut = new Array();
			let purpose = new Object();
			
			recDonut.push(['Purpose', 'money']);
			if(recList.length === 0){				
				recDonut.push(["No Data", 1]);
			}else{
				for(let i=0; i<recList.length; i++){
					if(recList[i].purSeq !== 0){
						if(recList[i].money < 0){						
							if(emptyCheck.isEmpty(purpose[recList[i].purpose])){								
								purpose[recList[i].purpose] = Math.abs(recList[i].money);								
							}else{								
								purpose[recList[i].purpose] = purpose[recList[i].purpose]+Math.abs(recList[i].money);								
							}						
						}
					}				
				}
				let purKeys = Object.keys(purpose);				
				for(let i=0; i<purKeys.length; i++){
					recDonut.push([purKeys[i], purpose[purKeys[i]]]);
				}
			}
			
			google.charts.setOnLoadCallback(drawChart);
			function drawChart() {

			    let data = google.visualization.arrayToDataTable(recDonut);
			    
				let options = {
					axisTitlesPosition : 'none',
					chartArea: {
						width:'100%',
						height:'300px'
					},
					pieHole: 0.4
				};

				let chart = new google.visualization.PieChart(document.getElementById('donutChart'));
				chart.draw(data, options);
			}
		}
	}
	
	$('#ledgerReList').on("change keyup input", function(event) {
		switch(event.target.id.split('_')[0]){		
		case "purSeq" :			
			rec.appSel(event.target, event.target.id.split('_')[1]);
		default :
			rec.sync(event.target);
			break;
		}
	});	
});

let rec = {
	recList : new Array(),
	recClone : new Array(),
	purList : new Array(),
	purDtlList : new Array(),
	bankList : new Array(),
	mode : "index",
	search : {		
		purSeq : "",
		purDtlSeq : "",
		bankSeq : ""
	},
	
	initRec : function(mode, recList, purList, purDtlList, bankList){
    	this.recList = recList;
    	this.mode = mode;
    	if(this.mode === "index"){
    		this.recClone = null;
    		this.searchReset();
    	}else{
    		this.recClone = common.clone(this.recList);    		
    	}
    	return this;
	},
	
	initPB : function(purList, purDtlList, bankList){
		this.purList = purList;
		this.purDtlList = purDtlList;
		this.bankList = bankList;
		return this;
	},
	
	destroy : function(){
		this.recList = new Array();
		this.recClone = new Array();
		this.purList = new Array();
		this.purDtlList = new Array();
		this.bankList = new Array();
		this.searchReset();
		$("#ledgerReList").empty();
	},
	view : function(){		
		$("#ledgerReList").empty();				
		
		let tag = "";
		tag += "<table class='table table-striped table-bordered table-sm'>";
		tag	+= "<tr>";			
		tag	+= "<th>날짜</th>";
		tag	+= "<th>위치</th>";
		tag	+= "<th>내용</th>";
		tag	+= "<th>목적</th>";
		tag	+= "<th>상세목적</th>";
		tag	+= "<th>사용수단</th>";
		tag	+= "<th>수입/지출</th>";			
		tag	+= "<th>소지금액</th>";
		
		//index화면일 경우 간략화(금액은 +-금액과 총액만 출력)
		if(this.mode === "select"){
			tag	+= "<th>현금</th>";
			for(let i=0; i<this.bankList.length; i++){
				tag += "<th>"+this.bankList[i].bankName+"<br>("+(this.bankList[i].bankAccount==="cash" ? "":this.bankList[i].bankAccount) +")</th>";
			}
		}	
		tag += "</tr>";		
		
		for(let i=this.recList.length-1; i>=0; i--){
			
			if(this.search.purSeq !== "" && this.search.purSeq  !== String(this.recList[i].purSeq)){
				continue;				
			}
			if(this.search.purDtlSeq !== "" && this.search.purDtlSeq  !== String(this.recList[i].purDtlSeq)){
				continue;				
			}
			if(this.search.bankSeq !== "" && this.search.bankSeq  !== String(this.recList[i].bankSeq)){
				continue;				
			}
			
			tag += "<tr>";			
			tag += "<td>"+this.recList[i].recordDate+"</td>";
			tag += "<td>"+this.recList[i].position+"</td>";
			tag += "<td>"+this.recList[i].content+"</td>";			
			tag += "<td>"+(this.recList[i].purpose === 'move' ? (Number(this.recList[i].purSeq) === -1 ? "excel" : "금액이동") : this.recList[i].purpose)+"</td>";
			tag += "<td>"+this.recList[i].purDetail+"</td>";
			tag += "<td>"+(this.recList[i].bankName === 'cash' ? "현금" : this.recList[i].bankName +"<br>("+this.recList[i].bankAccount+")")+"</td>";
			if(this.recList[i].purpose === 'move'){
				tag += "<td>("+common.comma(Math.abs(this.recList[i].money))+")</td>";
			}else{
				tag += "<td>"+common.comma(this.recList[i].money)+"</td>";
			}
			tag += "<td>"+common.comma(this.recList[i].amount)+"</td>";
			
			//index화면일 경우 간략화(금액은 +-금액과 총액만 출력)
			if(this.mode === "select"){
				tag += "<td>"+common.comma(this.recList[i].cash)+"</td>";
				
				for(let j=0; j<this.bankList.length; j++){
					tag += "<td>"+common.comma(this.recList[i]["bank"+j])+"</td>";
				}
			}
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#ledgerReList").append(tag);
		
	
	},
	
	edit : function(){
		
		$("#ledgerReList").empty();
		let tag = "";
		let selected = "";
		let disabled = "";	
		
		tag += "<table class='table table-striped table-sm table-bordered'>";
		tag	+= "<tr>";
		tag += "<th style='width:3%;'>순번</th>";
		tag += "<th style='width:3%;'>삭제</th>";
		tag	+= "<th style='width:12%;'>날짜*</th>";
		tag	+= "<th style='width:11%;'>위치</th>";
		tag	+= "<th style='width:11%;'>내용*</th>";
		tag	+= "<th style='width:12%;'>목적*</th>";
		tag	+= "<th style='width:12%;'>상세목적</th>";
		tag	+= "<th style='width:12%;'>사용수단*</th>";
		tag	+= "<th style='width:12%;'>이동대상</th>";
		tag	+= "<th style='width:12%;'>수입 지출*</th>";
		tag += "</tr>";		
		
		let n = 1;
		for(let i=this.recList.length-1; i>=0; i--){
			
			if(this.search.purSeq !== "" && this.search.purSeq  !== String(this.recList[i].purSeq)){
				continue;				
			}
			if(this.search.purDtlSeq !== "" && this.search.purDtlSeq  !== String(this.recList[i].purDtlSeq)){
				continue;				
			}
			if(this.search.bankSeq !== "" && this.search.bankSeq  !== String(this.recList[i].bankSeq)){
				continue;				
			}
			
			disabled = this.recList[i].purSeq === 0 ? disabled = "" : disabled = "disabled='disabled'";
			
			tag += "<tr>";			
			tag += "<td>"+n+"</td>";			
			tag += "<td><input id='delete_"+i+"' type='checkbox' onchange='rec.sync(this)' title='삭제 체크박스'></td>";			
			tag += "<td><input id='date_"+i+"' type='text' class='form-control form-control-sm' value='"+this.recList[i].recordDate+"'></td>";
			tag += "<td><input id='position_"+i+"' type='text' class='form-control form-control-sm' value='"+this.recList[i].position+"'></td>";
			tag += "<td><input id='content_"+i+"' type='text' class='form-control form-control-sm' value='"+this.recList[i].content+"'></td>";
			tag += "<td><select id='purSeq_"+i+"' class='custom-select custom-select-sm slt-fs'>";			
			if(Number(this.recList[i].purSeq) === -1){
				tag += "<option value=-1>excel</option>";
			}					
			tag += "<option value=0>금액이동</option>";		
			for(let j=0; j<this.purList.length; j++){
				String(this.recList[i].purSeq) === String(this.purList[j].purSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value='"+this.purList[j].purSeq+"'>"+this.purList[j].purpose+"</option>";
			}	
			tag += "</select></td>";
			tag += "<td><select id='purDtlSeq_"+i+"' class='custom-select custom-select-sm slt-fs'>";
			tag += "<option value=''>선택</option>";			
			for(let j=0; j<this.purDtlList.length; j++){				
				if(String(this.recList[i].purSeq) === String(this.purDtlList[j].purSeq)){
					String(this.recList[i].purDtlSeq) === String(this.purDtlList[j].purDtlSeq)	 ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value='"+this.purDtlList[j].purDtlSeq+"'>"+this.purDtlList[j].purDetail+"</option>";
				}
			}	
			tag += "</select></td>";
			tag += "<td><select id='bankSeq_"+i+"' class='custom-select custom-select-sm slt-fs'>";
			tag += "<option "+(this.recList[i].bankSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";			
			for(let j=0; j<this.bankList.length; j++){
				String(this.recList[i].bankSeq) === String(this.bankList[j].bankSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value='"+this.bankList[j].bankSeq+"'>"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
			}
			tag += "</select></td>";
			tag += "<td><select id='moveSeq_"+i+"' "+disabled+" class='custom-select custom-select-sm slt-fs'>";
			tag += "<option value=''>선택</option>";
			tag += "<option "+(this.recList[i].moveSeq === '0' ? "selected='selected'" : "")+" value=0>현금</option>";		
			for(let j=0; j<this.bankList.length; j++){
				String(this.recList[i].moveSeq) === String(this.bankList[j].bankSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+" value='"+this.bankList[j].bankSeq+"'>"+this.bankList[j].bankName+"("+this.bankList[j].bankAccount+")</option>";
			}
			tag += "</td>";
			tag += "<td><input id='money_"+i+"' type='text' class='form-control form-control-sm' value='"+this.recList[i].money+"'></td>";			
			tag += "</tr>";
			
			this.deleteRow(i);
			n++;
		}			
		tag +="</table>";
		$("#ledgerReList").append(tag);
		
		//Air Datepicker 설정
		for(let i=this.recList.length-1; i>=0; i--){			
			$("#date_"+i).datepicker({
				language: 'ko',
				timepicker: true,
				onSelect: function() {
					//rec.sync 연결
					$("#ledgerReList #date_"+i).trigger('change');
				}
			});
			$("#date_"+i).data('datepicker');	
		}
		
	},
		
	appSel : function(target, idx){
		$("#purDtlSeq_"+idx).empty();	

		let selected = "";
		let tag = "<option value=''>선택</option>";
		for(let j=0; j<this.purDtlList.length; j++){
			if(String(this.recList[idx].purSeq) === String(this.purDtlList[j].purSeq)){
				String(this.recList[idx].purDtlSeq) === String(this.purDtlList[j].purDtlSeq) ? selected = "selected='selected'" : selected = "";
				tag += "<option "+selected+"value='"+this.purDtlList[j].purDtlSeq+"'>"+this.purDtlList[j].purDetail+"</option>";
			}
		}	
		$("#purDtlSeq_"+idx).append(tag);
		
		//move 셀렉트박스 금액이동이외 disabled 처리
		if('0' === String(target.value)){			
			$("#moveSeq_"+idx).removeAttr("disabled");
		}else{
			$("#moveSeq_"+idx).val('').prop("selected", true).attr("disabled","disabled");
		}
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = target.id.split('_')[1];
		
		switch(name){		
		
		case "date" :
			this.recList[idx].recordDate = String(target.value);
			break;
		case "delete" :
			if( $(target).is(":checked") === true ){				
				this.recList[idx].state = "delete";
				this.addClass(idx, "delete");
			}else{
				this.recList[idx].state = "select";
				this.removeClass(idx, "delete");
			}
			break;
		case "purSeq" :
			if(String(target.value) === '0'){				
				this.recList[idx].purDtlSeq = '';
			}			
			if(String(target.value) !== '0' && this.recList[idx].moveSeq !== ''){
				this.recList[idx].moveSeq = '';
			}			
			this.recList[idx][name] = String(target.value);
			this.recList[idx]["purDtlSeq"] = "";
			break;
		case "purDtlSeq" :
		case "bankSeq" :		
		case "moveSeq" :
		case "content" :
		case "position" :
		case "money" :	
			this.recList[idx][name] = String(target.value);
			break;		
		}
		
		
		if($(target).is(":checked") === false && this.equals(idx) === false){
			this.recList[idx].state = "update";
			this.addClass(idx, "update");
		}else{			
			$(target).is(":checked") === true ? this.recList[idx].state = "delete" : this.recList[idx].state = "select";
			this.removeClass(idx, "update");			
		}
	},
	
	equals : function(idx){
		
		if(String(this.recList[idx].recordDate) !== String(this.recClone[idx].recordDate)){
			return false;
		}else if(String(this.recList[idx].content) !== String(this.recClone[idx].content)){
			return false;
		}else if(String(this.recList[idx].position) !== String(this.recClone[idx].position)){
			return false;
		}else if(String(this.recList[idx].purSeq) !== String(this.recClone[idx].purSeq)){
			return false;
		}else if(String(this.recList[idx].purDtlSeq) !== String(this.recClone[idx].purDtlSeq)){
			return false;
		}else if(String(this.recList[idx].bankSeq) !== String(this.recClone[idx].bankSeq)){
			return false;
		}else if(String(this.recList[idx].moveSeq) !== String(this.recClone[idx].moveSeq)){
			return false;
		}else if(String(this.recList[idx].money) !== String(this.recClone[idx].money)){
			return false;
		}
		
		return true;		
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		
		let j = 1;
		for(let i=this.recList.length-1; i>=0; i--){
			
			if(this.search.purSeq !== "" && this.search.purSeq  !== String(this.recList[i].purSeq)){
				continue;				
			}
			if(this.search.purDtlSeq !== "" && this.search.purDtlSeq  !== String(this.recList[i].purDtlSeq)){
				continue;				
			}
			if(this.search.bankSeq !== "" && this.search.bankSeq  !== String(this.recList[i].bankSeq)){
				continue;				
			}
			
			// 빈값, null 체크
			if(this.recList[i].date === '' || this.recList[i].date === null){
				check = {check : false, msg : j + "행의 날짜 데이터가 입력되지 않았습니다."};
				break;			
			}else if(this.recList[i].content === '' || this.recList[i].content === null){
				check = {check : false, msg : j + "행의 내용이 입력되지 않았습니다."};
				break;
			}else if(this.recList[i].money === 0 || this.recList[i].money === null){
				check = {check : false, msg : j + "행의  금액이 입력되지 않았습니다."};
				break;
			}
			
			//금액이동시 체크
			if(this.recList[i].purSeq === 0 && (this.recList[i].moveSeq === '' || this.recList[i].moveSeq === null)){
				check = {check : false, msg : j + "행의 금액이동할 대상이 선택되지 않았습니다."};
				break;
			}else if(this.recList[i].bankSeq === this.recList[i].moveSeq){
				check = {check : false, msg : j + "행의 금액이 이동할 곳이 같습니다."};
				break;
			}
			
			//비정상 값 체크			
			if(common.isNum(this.recList[i].money) === false){
				check = {check : false, msg : j + "행의 금액이 잘못 입력하였습니다."};
				break;
			}j++;
		}
		
		return check;
		
	},
	
	save : function(){
		
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.recList.length; i++){
			if(this.recList[i].purSeq === '0'){			
				this.recList[i].money = "-"+String(Math.abs(Number(this.recList[i].money)));
			}
			
			if(this.recList[i].state === "update"){
				upList.push(this.recList[i]);
			}else if(this.recList[i].state === "delete"){
				delList.push(this.recList[i]);
			}
		}
		
		if(upList.length === 0 && delList.length === 0){
			alert("수정, 삭제할 대상이 없습니다.");
			return;
		}else{
			
			if(upList.length > 0 && delList.length > 0){
				if(!confirm("수정, 삭제 하시겠습니까?")){
					return;
				}
			}else if(upList.length > 0 && delList.length === 0){
				if(!confirm("수정 하시겠습니까?")){
					return;
				}
			}else if(delList.length > 0){
				if(!confirm("삭제할 대상이 있습니다. 삭제 하시겠습니까?")){
					return;
				}
			}
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ledgerRe/updateDeleteRecordList.ajax',
			data: {
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) { 
		    	let msg = "";
		    	if(data.upCnt > 0){
		    		msg += data.upCnt+" 개의 행이 수정";
		    	}
		    	
		    	if(data.upCnt > 0 && data.delCnt > 0){
		    		msg += ", ";
		    	}
		    	
		    	if(data.delCnt > 0){
		    		msg += data.delCnt+ "개의 행이 삭제";
		    	}
		    	msg += " 되었습니다.";
		    	alert(msg);
		    	mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("update, delete error");
		    }
		});	
	},	
	
	cancel : function(mode){		
		this.recList = common.clone(this.recClone);
		if(mode !== "search"){
			this.searchReset();
		}		
		return this;
	},
	
	addClass : function(idx, classNm){
		
		let bind = "";
		classNm === "redLine" ? bind = true : bind = false;		

		$("#date_"+idx).addClass(classNm).prop("readOnly", bind);		
		$("#content_"+idx).addClass(classNm).prop("readOnly", bind);
		$("#position_"+idx).addClass(classNm).prop("readOnly", bind);
		$("#purSeq_"+idx).addClass(classNm).prop("disabled", bind);
		$("#purDtlSeq_"+idx).addClass(classNm).prop("disabled", bind);
		$("#bankSeq_"+idx).addClass(classNm).prop("disabled", bind);
		$("#moveSeq_"+idx).addClass(classNm);
		$("#money_"+idx).addClass(classNm).prop("readOnly", bind);
	},
	
	removeClass : function(idx, classNm){		
		
		$("#date_"+idx).removeClass(classNm);		
		$("#content_"+idx).removeClass(classNm);
		$("#position_"+idx).removeClass(classNm);
		$("#purSeq_"+idx).removeClass(classNm);
		$("#purDtlSeq_"+idx).removeClass(classNm);
		$("#bankSeq_"+idx).removeClass(classNm);
		$("#moveSeq_"+idx).removeClass(classNm);
		$("#money_"+idx).removeClass(classNm);
		
		if(classNm === "redLine"){
			
			$("#date_"+idx).prop("readOnly", false);			
			$("#content_"+idx).prop("readOnly", false);
			$("#position_"+idx).prop("readOnly", false);
			$("#purSeq_"+idx).prop("disabled", false);
			$("#purDtlSeq_"+idx).prop("disabled", false);
			$("#bankSeq_"+idx).prop("disabled", false);			
			$("#money_"+idx).prop("readOnly", false);
		}		
	},
	
	deleteRow : function(idx){
		delete this.recList[idx].bankAccount;
		delete this.recList[idx].amount;
		delete this.recList[idx].bankName;
		delete this.recList[idx].purDetail;
		delete this.recList[idx].purpose;
		delete this.recList[idx].cash;
		for(let j=0; j<this.bankList.length; j++){
			delete this.recList[idx]["bank"+j];
		}	
	},
	
	searchReset : function(){		
		this.search.purSeq = "";
		this.search.bankSeq = "";
		return this;
	}
}

</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">가계부</h1>
	</div>

	<span name="date"></span>
	<div class="space left"></div>
	
	<div class="left width-half">
		<div id="comboChart" class="form-control height-half">
		</div>
	</div>
	
	<div class="right width-half">
		<div id="donutChart" class="form-control height-half">
		</div>
	</div>		


	<!-- 메모 -->
	<div id="ledgerMemo">	
	</div>
	
	<input id="startDate" type="hidden" value="">
	<input id="endDate" type="hidden" value="">

	<div class="space left"></div>

	<span class="article" name="date"></span>
	<div id="ledgerReList">		
	</div>
</div>

