<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${path}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${path}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	//초기설정
	new Promise(function(resolve, reject){		
		//셀렉트박스 생성
		wcm.createCodes({targetId:"srhType", prtCode:"CODE", first:"ALL"});		
		//그리드 생성
		let codeGrid = new wGrid("codeList", {
			controller : {
				load : function(){					
					let promise = new Promise(function(resolve, reject){
						let sParam = {
							pageIndex : 1,
							pageSize : 20,
							pageCount : 10	
						}
						$.post("${path}/admin/selectCodeDefineList.ajax", sParam, resolve);
					});
					return promise;
				}				
			},
			header : "",
			data : "",
			fields : [
				{ isRemoveButton: true, isHeadAddButton: true, width: "3%", align:"center"},
				{ title:"번호",		name:"codeSeq",	type:"text", width: "3%",	align:"center"},
				{ title:"부모코드",	name:"codePrt",	type:"input", width: "10%",	align:"center"},
				{ title:"코드",		name:"code",	type:"input", width: "10%",	align:"center"},
				{ title:"코드명",		name:"codeNm",	type:"input", align:"center"},
				{ title:"수정자",		name:"modUser",	type:"text", width: "5%",	align:"center"},
				{ title:"수정날짜",	name:"modDate",	type:"text", width: "10%",	align:"center"},
				{ title:"등록자",		name:"regUser",	type:"text", width: "5%",	align:"center"},
				{ title:"등록날짜",	name:"regDate",	type:"text", width: "10%",	align:"center"}	
			],
			option : {
				isAuto : true,
				isClone : true,
				isPaging : true				
			},			
			message : {
				nodata : "조회결과가 없습니다."
			},
			event : {
				
			}
		});
		resolve();
	})	
	.then(fnEvent);	
});
//이벤트 등록
function fnEvent(){
	//조회버튼
	$("#srhBtn").on("click", function(){
		
	});
}
</script>
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
				<col width="*"/>
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
				<td>
					<div class="btn-right">
						<button class="btn-gray trs" id="srhBtn">조회</button>
						<button class="btn-gray trs" id="addBtn">추가</button>
					</div>
				</td>
			</tr>
		</table>
	</div>
</form>

<div id="codeList"></div>