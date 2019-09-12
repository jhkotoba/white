<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/wGrid/css/wGrid.css" type="text/css"/>
<script type="text/javascript" src="${contextPath}/resources/wGrid/js/wGrid.js"></script>

<script type="text/javascript">
//############## 사용 페이지 전역변수 ################
let meansGrid = null;

$(document).ready(function(){
	fnInit();
});

//############## 초기설정 ################
function fnInit(){
	
	meansGrid = new wGrid("meansGrid", {
		controller : {
			load : function(){					
				let promise = new Promise(function(resolve, reject){					
					$.post("${contextPath}/ledger/selectMeansList.ajax", null, resolve);
				});
				return promise;
			}			
		},
		fields : [
			{ isRemoveButton: true, isHeadAddButton: true, width: "3%", align:"center"},
			{ title:"정렬", name:"meansOrder", tag:"input", width: "4%", align:"right"},
			{ title:"사용수단", name:"meansNm", tag:"input", width: "10%", align:"center"},
			{ title:"사용수단상세", name:"meansDtlNm", tag:"input", width: "34%", align:"center"},			
			{ title:"수단정보", name:"meansInfo", tag:"input", width: "20%", align:"center"},
			{ title:"비고", name:"meansRemark", tag:"input", width: "24%", align:"center"},
			{ title:"사용여부", isUseYnButton: true, name:"meansUseYn", width: "5%", align:"center"},			
		],
		option : {isAutoSearch: true, isClone: true, isPaging: false, isScrollY: true, isScrollX: false, bodyHeight:"550px"},		
	});
	
	fnInitEvent();
}

//############## 이벤트 등록 ################
function fnInitEvent(){
	//저장 버튼
	$("#saveBtn").on("click", function(){
		fnApplyData();		
	});
	
	//취소(초기화) 버튼
	$("#cancelBtn").on("click", function(){
		meansGrid.originalToReset();
	});
}

//############## 적용 로직 ################
function fnApplyData(){
	
	let gList = meansGrid.getData();
	let applyList = meansGrid.getApplyData();
	let isSave = false;
	
	//유효성 검사
	if(applyList.length === 0){
		alert("적용할 데이터가 없습니다.");
		return;
	}else{
		isSave = !applyList.some(function(item){			
			switch(item._state){			
			case "update":				
				for(let i=0; i<gList.length; i++){
					if(item._key !== gList[i]._key){
						if(item.meansOrder == gList[i].meansOrder){
							meansGrid.inputMessage(item._key, "meansOrder", "중복되는 값이 있습니다.");
							return true;
						}
					}	
				}				
			case "insert":
				if(wcm.isEmpty(item.meansNm)){
					meansGrid.inputMessage(item._key, "meansNm", "값이 없습니다.");
					return true;
				}else if(item.meansNm.length > 50){
					meansGrid.inputMessage(item._key, "meansNm", "최대길이 50자 입니다.");
					return true;
				}else if(item.meansDtlNm.length > 50){
					meansGrid.inputMessage(item._key, "meansDtlNm", "최대길이 50자 입니다.");
					return true;
				}else if(item.meansInfo.length > 50){
					meansGrid.inputMessage(item._key, "meansInfo", "최대길이 50자 입니다.");
					return true;
				}else if(item.meansRemark.length > 100){
					meansGrid.inputMessage(item._key, "meansRemark", "최대길이 100자 입니다.");
					return true;
				}else{
					return false;
				}
			}
		});	
	}
	
	if(isSave && confirm("적용하시겠습니까?")){			
		$.post("${contextPath}/ledger/applyMeansList.ajax", 
				{list : JSON.stringify(applyList)}, function(res){
			if(res === -1){
				alert("사용자 정보가 일치하지 않습니다.");					
			}else if(res === -2){
				alert("삭제하려는 정보가 가계부목록에 사용되고 있습니다.");					
			}else{
				alert("저장되었습니다.");
				meansGrid.search();
			}
		});
	}
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