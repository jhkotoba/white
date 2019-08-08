<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>
<script type="text/javascript">
//전역변수
const vals = {};
$(document).ready(function(){
	//초기설정
	fnInit();
	//이벤트 등록
	fnEventInit();	
});

//초기설정
function fnInit(){	
	vals.meansGrid = new wGrid("meansGrid", {
		controller : {
			load : function(){					
				let promise = new Promise(function(resolve, reject){
					let srhParam = {};
					$.post("${contextPath}/ledger/selectBankList.ajax", srhParam, resolve);
				});
				return promise;
			}			
		},
		fields : [
			{ isRemoveButton: true, isHeadAddButton: true, width: "3%", align:"center"},
			{ title:"번호", name:"meansOrder", tag:"text", width: "3%", align:"center"},
			{ title:"사용수단", name:"meansNm", tag:"input", width: "10%", align:"center"},
			{ title:"사용수단상세", name:"meansDtlNm", tag:"input", width: "35%", align:"center"},			
			{ title:"수단정보", name:"meansInfo", tag:"input", width: "20%", align:"center"},
			{ title:"비고", name:"meansRemark", tag:"input", width: "25%", align:"center"},
			{ title:"사용여부", isUseYnButton: true, name:"meansUseYn", width: "4%", align:"center"},			
		],
		option : {isAutoSearch: true, isClone: true, isPaging: false, isScrollY: true, isScrollX: false, bodyHeight:"550px"},		
	});
}

//이벤트 등록
function fnEventInit(){
	
}
</script>
<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="saveBtn" class="btn-gray trs">저장</button>
		<button id="cancelBtn" class="btn-gray trs">취소</button>
	</div>
</div>

<div>
	<div>
		<div class="title-icon"></div>
		<label class="title">사용수단 목록</label>
	</div>
	<div id="meansGrid"></div>
</div>