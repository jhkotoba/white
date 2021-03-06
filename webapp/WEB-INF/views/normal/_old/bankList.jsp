<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/ledger/selectMeansList").done(fnGrid);
});

function fnGrid(data){
	
	for(let i=0; i<data.length; i++){
		data[i].state = "select";
	}
	
	let clone = common.clone(data);
	let bankList = data;
	let bankNoIdx = cfnNoIdx(bankList, "meansSeq");
	let cloneNoIdx = cfnNoIdx(clone, "meansSeq");
	
	$("#bankList").jsGrid({
		height: "auto",
		width: "100%",
		
		autoload: true,     
		data: bankList,		
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [
			{ align:"center", width: "3%",
				headerTemplate : function(){
					return $("<button>").attr("id", "bankAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
						bankList.push({
							meansInfo:"",
							meansOdr:  $("#bankList").jsGrid("option", "data").length+1,
							meansSeq:new Date().getTime(),
							meansNm:"",
							meansDtlNm: "",
							meansRmk: "",
							meansUseYn:"N",
							state:"insert"});		
						bankNoIdx = cfnNoIdx(bankList, "meansSeq");
						$("#bankList").jsGrid("refresh");
					});					
				},				
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("meansSeq", item.meansSeq).data("meansOdr", item.bankOrder).on("change", function() {
                    	let idx = bankNoIdx[item.meansSeq];
                    	let cIdx = cloneNoIdx[item.meansSeq];
                			
               			if(isEmpty(item.meansOdr)){
               	    		$("#bankList").jsGrid("deleteItem", item);
               	    		delete bankNoIdx[item.meansSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.meansSeq  === $(e).data("meansSeq")){
                   	   					$(e).addClass("sync-red");               	   					
                   	   					if(String(clone[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   						bankList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.meansSeq === $(e).data("meansSeq")){
                   	   					$(e).removeClass("sync-red");               	   					
                   	   					if($(e).hasClass("sync-blue") || bankList[idx].state === "update"){
                   	   						bankList[idx].state = "update";
                   	   					}else{   						
                   	   						bankList[idx].state = "select";
                   	   					}   					
                   	   				}
                   	   			});
                   	    	}
               	    	}
                	});                    
                    if(item.state === "delete") chk.prop('checked', true);                    	
                    return chk;
                }
			},
			{ title:"순서",	name:"meansOdr",	type:"text", align:"center", width: "3%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "meansOdr", "span");
				}
			},
			{ title:"사용수단",	name:"meansNm",		type:"text", align:"center", width: "12%", 
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "meansNm", "input");
				}
			},
			{ title:"사용수단상세",	name:"meansDtlNm",		type:"text", align:"center", width: "35%", 
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "meansDtlNm", "input");
				}
			},
			{ title:"수단정보",	name:"meansInfo",	type:"text", align:"center", width: "22%",
				itemTemplate: function(value, item){					
					return fnRefreshedSync(item, "meansInfo", "input");
				}
			},
			{ title:"비고",	name:"meansRmk",	type:"text", align:"center", width: "15%",
				itemTemplate: function(value, item){					
					return fnRefreshedSync(item, "meansRmk", "input");
				}
			},
			{ title:"사용여부", name:"meansUseYn", align:"center", width: "5%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "meansUseYn", "button");
				}
			}
		],
		onRefreshed: function() {
			let $gridData = $("#bankList .jsgrid-grid-body tbody");
			$gridData.sortable({
				update: function(e, ui) {
					let items = $.map($gridData.find("tr"), function(row) {
						return $(row).data("JSGridItem");
					});
					
					bankNoIdx = cfnNoIdx(bankList, "meansSeq");
					for(let i=0; i<items.length; i++){
						fnOnSync($("#bankList .ui-sortable tr span")[i], i);
					}
				}
			});			
			
			//수정 sync 체크
			$("input[name='sync']").on("keyup keydown change", function(){	
				fnOnSync(this);
			});
			
			//수정 button sync 체크
			$("button[name='sync']").on("click", function(){			
				if($(this).val() === "Y")	$(this).val("N").text("N");
				else						$(this).val("Y").text("Y");
				
				fnOnSync(this);
			});
		}
	});
	
	//취소
	$("#cancelBtn").on("click", function(){		
		bankList.splice(0, bankList.length);
		for(let i=0; i<clone.length; i++){
			bankList.push(common.clone(clone[i]));
		}
		$("#bankList").jsGrid("refresh");		
	});
	
	//저장(반영)
	$("#saveBtn").on("click", function(){
				
		//유효성 검사
		let isVali = true;
		$("input[name='sync']").each(function(i, e){
			if(isEmpty($(e).val())){
				switch($(e).data("name")){
				case "meansDtlNm" :
				case "meansRmk" :
				case "meansInfo" :
					break;
				default :
					isVali = false;
					wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
				}							
			}
			switch($(e).data("name")){
			case "meansNm":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "meansDtlNm":
				if("" !== $(e).val() && !isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 50){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 50자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "meansInfo":
				if($(e).val().length > 50){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 50자 까지 입력할 수 있습니다."}); return false;
				}
				break;			
			}
			
		});
		
		let applyList = new Array();
		for(let i=0, j=1; i<bankList.length; i++){
			if(bankList[i].state !== "select"){
				applyList.push(bankList[i]);
			}
		}
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		
		}else if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};			
			param.bankList = JSON.stringify(applyList);
			
			cfnCmmAjax("/ledger/applybankList", param).done(function(res){
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");
				}else if(Number(res)===0){
					alert("삭제하려는 권한이 사용중 입니다. 반영이 취소됩니다.");
				}else{
					alert("반영되었습니다.");
				}
				mf.submit('${navUrl}', '${sideUrl}', '${navNm}', '${sideNm}');				
			});
		}
	});
	
	//수정 sync 체크
	function fnOnSync(obj, sortIdx){
		
		let name = $(obj).data("name");
		let idx = bankNoIdx[$(obj).data("meansSeq")];
		let cIdx = cloneNoIdx[$(obj).data("meansSeq")];
		
		if($(obj).hasClass("sync-green")){
			if(isEmpty(sortIdx)) bankList[idx][name] = $(obj).val();
			else bankList[idx][name] = sortIdx+1;			
		}else{			
			
			if(isEmpty(sortIdx)){
				
				bankList[idx][name] = $(obj).val();
				
				if(String(clone[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) bankList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) bankList[idx].state = "update";
				}
			}else{
				
				bankList[idx][name] = sortIdx+1;
				
				if(idx === sortIdx){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) bankList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) bankList[idx].state = "update";
				}
			}			
		}
	}
	
	//새로고침 sync
	function fnRefreshedSync(item, name, tag){
		
		let $el = null;
		switch(tag){
		case "input" :
		default :
			$el = $("<input>").attr("type", "text").addClass("input-gray wth100p").val(item[name]);
			break;
		case "span" :
			$el = $("<span>").val(item[name]).text(item[name]);
			break;
		case "button" :
			$el = $("<button>").addClass("btn-gray trs size-sm").val(item[name]).text(item[name]);
			break;
		}
		$el.attr("name", "sync").data("meansSeq", item.meansSeq).data("name", name);
		/* if(name !== "meansDtlNm"){
			$el.attr("name", "sync");
		} */
		

		if(item.state === "insert") $el.addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[cloneNoIdx[item.meansSeq]][name] === item[name]){
				$el.removeClass("sync-blue");
			}else{
				$el.addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
			$el.addClass("sync-red");
			if(clone[cloneNoIdx[item.meansSeq]][name] !== $el.val()){
				$el.addClass("sync-blue");
			}
		}		
		return $el;
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
		<label class="title">은행 목록</label>
	</div>
	<div id="bankList"></div>
</div>