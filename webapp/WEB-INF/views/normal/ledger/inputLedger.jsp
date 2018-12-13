<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectPurBankList").done(inputLedger);
});

function inputLedger(data){
	console.log(data);
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
	
	
	
	let fieldList = [
		{title : "",		name:"", width : "3%", align:"center",
			headerTemplate: function(){				
				return $("<button>").attr("id", "add")
					.addClass("btn-gray trs sm")
					.text("+")
					.on("click", function(){
						alert(111);
					});			
			},
			itemTemplate: function(item){
				return $("<input>").attr("type","checkbox");
			}
		},
		{title : "날짜*",		name:"recordDate",	width : "10%", align:"center", button:true,
			itemTemplate: function(item){
				return $("<input>").addClass("input-gray wth80p").val(item.recordDate);
			}
		},
		{title : "위치",		name:"position", 	width : "12%", align:"center", button:true,
			itemTemplate: function(item){
				return $("<input>").addClass("input-gray wth80p");
			}
		},		
		{title : "내용*",		name:"content", 	width : "14%", align:"center", button:true,
			itemTemplate: function(item){
				return $("<input>").addClass("input-gray wth80p");
			}
		},
		{title : "목적*",		name:"purSeq", 		width : "12%", align:"center", button:true,
			itemTemplate: function(item){				
				$select = $("<select>").addClass("select-gray wth80p");
				$option = null;
				for(let i=0; i<data.purList.length; i++){
					$option = $("<option>").val(data.purList[i].purSeq)
						.text(data.purList[i].purpose)
						.data("purType", data.purList[i].purType);
					
					$select.append($option)
				}
				return $select;
			}
		},		
		{title : "상세목적",	name:"purDtlSeq", 	width : "12%", align:"center",
			itemTemplate: function(item){
				
				
				
				return $("<select>").addClass("select-gray wth100p");
			}
		},		
		{title : "사용수단*",	name:"bankSeq", 	width : "12%", align:"center", button:true,
			itemTemplate: function(item){
				
				$select = $("<select>").addClass("select-gray wth80p");
				$option = null;
				for(let i=0; i<data.bankList.length; i++){
					$option = $("<option>").val(data.bankList[i].bankSeq)
						.text(data.bankList[i].bankName);
					
					$select.append($option)
				}
				return $select;
			}
		},		
		{title : "이동대상",	name:"moveSeq", 	width : "12%", align:"center",
			itemTemplate: function(item){
				return $("<select>").addClass("select-gray wth100p");
			}
		},		
		{title : "수입 지출*",	name:"money", 		width : "12%", align:"center",
			itemTemplate: function(item){
				return $("<input>").addClass("input-gray wth100p");
			}
		}		
	]
	
	let $header = $("<div>").append(fnCreateHeader());	
	
	let $tbody = $("<div>").append(fnCreateRow());	
	$("#ledgerList").append($header);
	$("#ledgerList").append($tbody);
	
	//해더 생성
	function fnCreateHeader(){
		
		let $tb = $("<table>").addClass("table-header");
		let $tr = $("<tr>");
		let $th = null;
		
		for(let i=0; i<fieldList.length; i++){			
			$th = $("<th>").attr("style", "width:"+fieldList[i].width);			
			if(isNotEmpty(fieldList[i].headerTemplate)){
				$th.append(fieldList[i].headerTemplate());
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
		let $tr = null;
		let $td = null;
		
		console.log(insertList);
		
		for(let i=0; i<insertList.length; i++){
			$tr = $("<tr>");
			for(let j=0; j<fieldList.length; j++){
				$td = $("<td>").attr("style", "width:"+fieldList[j].width);
				if(isNotEmpty(fieldList[j].itemTemplate)){
					$td.append(fieldList[j].itemTemplate(insertList[i]).attr("style", "text-align:"+fieldList[j].align));
					if(fieldList[j].button === true)$td.append($("<button>").addClass("btn-gray trs").text("↓"));
				}else{
					$td.text(insertList[i][fieldList[j].name]);
				}
				
				//.attr("style", "text-align:"+fieldList[j].align)
				
				$tr.append($td);
			}
			$tb.append($tr);			
		}		
		return $tb;
	}
}


</script>
	
<div id="searchBar" class="search-bar pull-right">	
	<button id="recInsertBtn" type="button" class="btn-gray trs">저장</button>
</div>
<div id="ledgerList"></div>