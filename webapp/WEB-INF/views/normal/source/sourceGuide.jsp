<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function(){
	//cfnCmmAjax("/source/selectPurBankList").done(fnSourceGuide);
	let temp = [
		{sourceGuideSeq:1, lang:"java", title:"TITLE", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java1", title:"TITLE1", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java2", title:"TITLE2", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java3", title:"TITLE3", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java4", title:"TITLE4", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java5", title:"TITLE5", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java6", title:"TITLE6", editDate:"11111111", userId:"aaaa1"},
		{sourceGuideSeq:1, lang:"java7", title:"TITLE7", editDate:"11111111", userId:"aaaa1"},
		
	];
	
	fnSourceGuide(temp);
	
});

function fnSourceGuide(data){
	let $sourceList = document.getElementById("sourceList");
	let $table = document.createElement("table");
	let str = "<tr>";	
	
	let fieldList = [
		{title: "번호", 		name: "sourceGuideSeq", width: "10%"}, 
		{title: "구분", 		name: "lang", 			width: "16%"}, 
		{title: "제목", 		name: "title", 			width: "18%"}, 
		{title: "사용자", 	name: "userId", 		width: "11%"},
		{title: "등록날짜", 	name: "editDate",		width: "17%"}
	];
	
	let $header = $("<div>").append(fnCreateHeader());	
	let $tbody = $("<div>").append(fnCreateRow());
	
	$("#sourceList").append($header).append($tbody);
	
	//해더 생성
	function fnCreateHeader(){
		let $tb = $("<table>").addClass("table-header");		
		let $tr = $("<tr>");
		let $th = null;
		
		fieldList.map(function(item, idx){
			$th = $("<th>").html(item.title).attr("style", "width:"+item.width);
			$tr.append($th);
		});
		$tb.append($tr);		
		
		return $tb;
	}
	
	//새로운 행 생성
	function fnCreateRow(){
		let $tb = $("<table>").addClass("table-body");
		let $tr = null;
		let $td = null;
		
		for(let i=data.length-1; i>=0; i--){
			$tr = $("<tr>");
			for(let j=0; j<fieldList.length; j++){
				$td = $("<td>").attr("style", "width:"+fieldList[j].width);				
				if(fieldList[j].itemTemplate === undefined){
					$td.append(fieldList[j].itemTemplate(data[i], i));
				}else{
					$td.append(data[i][fieldList[j].name]);
					$tr.append($td);
				}
			}
			$tb.append($tr);
		}
		return $tb;
	}	
}
</script>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>
<div id="sourcePager" class="pager"></div>