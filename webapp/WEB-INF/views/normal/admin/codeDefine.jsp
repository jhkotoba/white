<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
let values = {};
$(document).ready(function(){
	//초기설정
	new Promise(function(resolve, reject){
		
		wcm.createCodes({targetId:"srhType", prtCode:"CODE", first:"ALL"});
		
		values.grid = new wGrid({
			id : "codeList",
			header : "",
			data : "",			
			fields : [        	
				{ title:"부모코드",	name:"codePrt",	type:"input", width: "10%",	align:"center"},
				{ title:"코드",		name:"code",	type:"input", width: "10%",	align:"center"},
				{ title:"코드명",		name:"codeNm",	type:"input", width: "15%",	align:"center"},
				{ title:"수정자",		name:"modUser",	type:"text", width: "5%",	align:"center"},
				{ title:"수정날짜",	name:"modDate",	type:"text", width: "10%",	align:"center"},
				{ title:"등록자",		name:"regUser",	type:"text", width: "5%",	align:"center"},
				{ title:"등록날짜",	name:"regDate",	type:"text", width: "10%",	align:"center"}	
			],
			option : {
				auto : true,
				xhr : true,
				clone : true,
			},
			xhr : {
				url : "/admin/selectCodeDefineList.ajax",
				async : true,
				type : "post"				
			},
			message : {
				nodata : "조회결과가 없습니다."
			}
		});
		
		
		
		resolve();
	})
	.then(fnInit)
	.then(fnRegEvent);
	
});
//초기설정
function fnInit(){
	values.grid.createGrid();
	
}
//이벤트 등록
function fnRegEvent(){
	//조회버튼
	$("#srhBtn").on("click", function(){
		
	});
}
</script>

<!-- 버튼 -->
<div class="button-bar">
	<div class="btn-right">
		<button class="btn-gray trs" id="srhBtn">조회</button>
		<button class="btn-gray trs" id="addBtn">추가</button>
	</div>
</div>

<form id="srhForm" name="srhForm" onsubmit="return false;">
	<div>
		<div class="title-icon"></div>
		<label class="title">코드 정의</label>
	</div>
	<div class="search-bar">
		<table>
			<colgroup>
				<col width="130px" class="search-th"/>
				<col width="100px">
				<col width="130px" class="search-th"/>
				<col width="250px"/>
			</colgroup>
			<tr>
				<th>검색구분</th>
				<td>
					<select id="srhType" name="srhType" class="select-gray wth100p">
					</select>					
				</td>
				<th>검색명</th>
				<td>
					<input id="srhTxt" name="schTxt" type="text" class="input-gray wth3 wth100p">
				</td>
			</tr>
		</table>
	</div>
</form>

<div id="codeList"></div>