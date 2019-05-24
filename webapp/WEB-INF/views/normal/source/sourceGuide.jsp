<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function(){
	cfnCmmAjax("/source/selectSourceGuideList").done(fnSourceGuide);
});

function fnSourceGuide(data){
	let fieldList = [
		{title: "번호", 		name: "sourceGuideSeq", width: "5%"}, 
		{title: "구분", 		name: "lang", 			width: "15%"}, 
		{title: "제목", 		name: "title", 			width: "60%"}, 
		{title: "사용자", 	name: "userId", 		width: "10%"},
		{title: "등록날짜", 	name: "editDate",		width: "20%"}
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
		
		if(data.list.length === 0){
			$tr = $("<tr>").append($("<td>").text("Not found"));
			$tb.append($tr);
		}else{
			for(let i=data.list.length-1; i>=0; i--){
				$tr = $("<tr>");
				for(let j=0; j<fieldList.length; j++){
					$td = $("<td>").attr("style", "width:"+fieldList[j].width);				
					if(fieldList[j].itemTemplate === undefined){
						$td.append(data.list[i][fieldList[j].name]);					
					}else{
						$td.append(fieldList[j].itemTemplate(data[i], i));
					}
					$tr.append($td);
				}
				$tb.append($tr);
			}
		}
		return $tb;
	}	
}
</script>

<!-- 조회값 폼 -->
<form id="searchForm" name="searchForm" onsubmit="return false;">
	<input id="langCd" type="hidden" value="">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<!-- 버튼 -->
<div class="button-bar">
	<div id="btns" class="btn-right">
		<button class="btn-gray trs" id="searchBtn">조회</button>
		<button class="btn-gray trs" name="write">글쓰기</button>
	</div>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>
<div id="sourcePager" class="pager"></div>