<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>Insert title here</title>

<script type="text/javascript" src="resources/js/wcommon/jquery/jquery-3.2.0.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	let recList = JSON.parse('${recList}');	
	let bankList = JSON.parse('${bankList}');	
	console.log(recList);
	
	let tag = "<table border=1>"
			+ "<tr>"
			+ "<th>recordSeq</th>"
			+ "<th>recordDate</th>"
			+ "<th>content</th>"
			+ "<th>purpose</th>"
			+ "<th>purDetail</th>"
			+ "<th>bankName</th>"
			+ "<th>money</th>"
			+ "<th>cash</th>"
			+ "<th>amount</th>";
			for(let i=0; i<bankList.length; i++){
				tag += "<th>"+bankList[i].bankName+"("+(bankList[i].bankAccount==="cash" ? "":bankList[i].bankAccount) +")</th>";
			}	
		tag += "<tr>";
	
	for(let i=recList.length-1; i>=0; i--){
		
		//amount += data[i].money;
		
		tag += "<tr>";
		tag += "<td>"+recList[i].recordSeq+"</td>";
		tag += "<td>"+recList[i].recordDate+"</td>";
		tag += "<td>"+recList[i].content+"</td>";
		tag += "<td>"+recList[i].purpose+"</td>";
		tag += "<td>"+recList[i].purDetail+"</td>";
		tag += "<td>"+recList[i].bankName+"</td>";
		tag += "<td>"+recList[i].money+"</td>";
		tag += "<td>"+recList[i].cash+"</td>";
		tag += "<td>"+recList[i].amount+"</td>";
		
		for(let j=0; j<bankList.length; j++){
			tag += "<td>"+recList[i]["bank"+j]+"</td>";
		}		
		tag += "</tr>";		
	}
	
	tag +="</table>";
	$("#ledgerReList").append(tag);
	
});
</script>
</head>
<body>
	<a href="/white/mainInfo.do">메인화면</a><br>
	
	record_money_re 전체조회<br>
	<a href="/white/selectRecordList.do">selectRecordList(전체조회)</a><br><br>
	
	record_money_re 기간조회<br>
	<input id="startDate" type="date" value="">
	<input id="endDate" type="date" value="">
	
	<div id="ledgerReList">		
	</div>		
	
</body>
</html>
