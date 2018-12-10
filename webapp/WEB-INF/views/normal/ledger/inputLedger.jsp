<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectPurBankList").done(inputLedger);
});

function inputLedger(data){
	
	let insertList = new Array();
	
	insertList.push(
		{
			recordDate: isDate.today()+" "+isTime.curTime(),
			position:"",
			content:"",
			purSeq: "",
			purDtlSeq: "",
			bankSeq: "",
			moveSeq: "",
			money: ""
			
		}
	);
	
	let purList = data.purList;
	let purDtlList = data.purDtlList;
	let bankList = data.bankList;
	
	let fieldList = [
		{title : "",		name:"", width : "3%",
			headerTemplate: function(){				
				return $("<button>").attr("id", "add")
					.addClass("btn-gray trs sm")
					.text("+")
					.on("click", function(){
						alert(111);
					});			
			}		
		},
		{title : "날짜*",		name:"recordDate",	width : "12%"},
		{title : "위치",		name:"position", 	width : "12%"},
		{title : "내용*",		name:"content", 	width : "12%"},
		{title : "목적*",		name:"purSeq", 		width : "12%"},
		{title : "상세목적",	name:"purDtlSeq", 	width : "12%"},
		{title : "사용수단*",	name:"bankSeq", 	width : "12%"},
		{title : "이동대상",	name:"moveSeq", 	width : "12%"},
		{title : "수입 지출*",	name:"money", 		width : "12%"}			
	]
	let $header = $("<div>").append(fnCreateHeader(fieldList));	
	
	let $tbody = $("<div>").append(fnCreateRow());	
	$("#ledgerList").append($header);
	$("#ledgerList").append($tbody);
	
	//해더 생성
	function fnCreateHeader(){
		
		let $tb = $("<table>").addClass("table-header");
		let $tr = $("<tr>");
		let $th = null;
		let hdtp = null;	
		
		for(let i=0; i<fieldList.length; i++){			
			$th = $("<th>").attr("style", "width:"+fieldList[i].width);			
			if(isNotEmpty(fieldList[i].headerTemplate)){
				hdtp = fieldList[i].headerTemplate();
				$th.append(hdtp);
			}else{
				$th.text(fieldList[i].title);
			}
			$tb.append($tr.append($th));			
		}
		
		return $tb;		
	}
	
	//새로운 행 생성
	function fnCreateRow(){
		let $tb = $("<table>").addClass("table-body");
		let $tr = $("<tr>");
		let $td = null;
		
		console.log(insertList);
		
		for(let i=0; i<insertList.length; i++){
			
			$tr.append(
				$("<td>").append(
					$("<input>").attr("type", "checkbox")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].recordDate)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].position)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].content)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].purSeq)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].purDtlSeq)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].bankSeq)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].moveSeq)
						.addClass("input-gray wth100p")
				)
			)
			
			$tr.append(
				$("<td>").append(
					$("<input>").val(insertList[i].money)
						.addClass("input-gray wth100p")
				)
			)
		}
		$tb.append($tr);
		return $tb;
	}
}


</script>
	
<div id="searchBar" class="search-bar pull-right">	
	<button id="recAddBtn" type="button" class="btn-gray trs">추가</button>	
	<button id="recInsertBtn" type="button" class="btn-gray trs">저장</button>
</div>
<div id="ledgerList"></div>