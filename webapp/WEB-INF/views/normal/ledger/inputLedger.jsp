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
	
	let headerList = [
		{title : "+",		name:"", width : "3%"},
		{title : "날짜*",		name:"", width : "12%"},
		{title : "위치",		name:"", width : "12%"},
		{title : "내용*",		name:"", width : "12%"},
		{title : "목적*",		name:"", width : "12%"},
		{title : "상세목적",	name:"", width : "12%"},
		{title : "사용수단*",	name:"", width : "12%"},
		{title : "이동대상",	name:"", width : "12%"},
		{title : "수입 지출*",	name:"", width : "12%"}			
	]
	let $header = $("<div>").append(fnCreateHeader(headerList));	
	
	let $tbody = $("<div>").append(fnCreateRow());	
	$("#ledgerList").append($header);
	$("#ledgerList").append($tbody);
	
	//해더 생성
	function fnCreateHeader(){
		
		let $tb = $("<table>").addClass("table-header");
		let $tr = $("<tr>");
		
		$tb.append(
			$tr.append(
				$("<th>").append(
					$("<button>").attr("id", "add")
						.addClass("btn-gray trs sm")
						.text(headerList[0].title)
						.on("click", function(){
							alert(111);
						})						
				).attr("style", "width:"+headerList[0].width)
			)
		);		
		for(let i=1; i<headerList.length; i++){
			$tb.append($tr.append($("<th>").text(headerList[i].title).attr("style", "width:"+headerList[i].width)));			
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