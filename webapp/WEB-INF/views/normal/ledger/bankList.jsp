<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/ledger/selectBankList").done(fnGrid);
});

function fnGrid(data){
	
	for(let i=0; i<data.length; i++){
		data[i].state = "select";
	}
	
	let clone = common.clone(data);
	let bankList = data;
	let bankNoIdx = cfnNoIdx(bankList, "bankSeq");
	let cloneNoIdx = cfnNoIdx(clone, "bankSeq");
	
	$("#bankList").jsGrid({
		height: "auto",
		width: "100%",
		
		autoload: true,     
		data: bankList,		
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [
			{ align:"center", width: "5%",
				headerTemplate : function(){
					return $("<button>").attr("id", "bankAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
						bankList.push({bankAccount:"", bankOrder: "", bankSeq:new Date().getTime(), bankName:"", bankUseYn:"N", state:"insert"});		
						bankNoIdx = cfnNoIdx(bankList, "bankSeq");
						$("#bankList").jsGrid("refresh");
					});					
				},				
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("bankSeq", item.bankSeq).data("bankOrder", item.bankOrder).on("change", function() {
                    	let idx = bankNoIdx[item.bankSeq];
                    	let cIdx = cloneNoIdx[item.bankSeq];
                			
               			if(isEmpty(item.bankOrder)){
               	    		$("#bankList").jsGrid("deleteItem", item);
               	    		delete bankNoIdx[item.bankSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.bankSeq  === $(e).data("bankSeq")){
                   	   					$(e).addClass("sync-red");               	   					
                   	   					if(String(clone[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   						bankList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.bankSeq === $(e).data("bankSeq")){
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
			{ title:"순서",	name:"bankOrder",	type:"text", align:"center", width: "5%"},
			{ title:"은행명",	name:"bankName",		type:"text", align:"center", width: "33%", 
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "bankName", "input");
				}
			},
			{ title:"계좌번호",	name:"bankAccount",	type:"text", align:"center", width: "47%",
				itemTemplate: function(value, item){					
					return fnRefreshedSync(item, "bankAccount", "input");
				}
			},
			{ title:"사용여부", name:"bankUseYn", align:"center", width: "5%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "bankUseYn", "button");
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
					
					bankList.splice(0, bankList.length);
					for(let i=0; i<items.length; i++){
						bankList.push(items[i]);
					}
					$("#bankList").jsGrid("refresh");
					bankNoIdx = cfnNoIdx(bankList, "bankSeq");
				}
			});			
			
			//수정 intpu sync 체크
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
	$("#searchBar #cancelBtn").on("click", function(){		
		bankList.splice(0, bankList.length);
		for(let i=0; i<clone.length; i++){
			bankList.push(clone[i]);
		}
		$("#bankList").jsGrid("refresh");		
	});
	
	//저장(반영)
	$("#searchBar #saveBtn").on("click", function(){
		
		for(let i=0, j=1; i<bankList.length; i++){
			if(bankList[i].state !== "delete"){
				bankList[i].bankOrder = (j++);	
			}
		}
		//유효성 검사
		let isVali = true;
		$("input[name='sync']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "bankName":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "bankAccount":
				if(!isOnlyNumHyphen($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "숫자, 하이픈(-)만 입력할 수 있습니다."}); return false;
				}else if($(e).val().length > 50){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 60자 까지 입력할 수 있습니다."}); return false;
				}
				break;			
			}
			
		});
		
		if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};			
			param.bankList = JSON.stringify(bankList);
			
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
	
	function fnOnSync(obj){
		if($(obj).hasClass("sync-green")){
			bankList[bankNoIdx[$(obj).data("bankSeq")]][$(obj).data("name")] = $(obj).val();
		}else{
			let name = $(obj).data("name");
			let idx = bankNoIdx[$(obj).data("bankSeq")];
			let cIdx = cloneNoIdx[$(obj).data("bankSeq")];
			
			bankList[idx][name] = $(obj).val();
			
			if(String(clone[cIdx][name]) === String($(obj).val())){
				$(obj).removeClass("sync-blue");
				if(!$(obj).hasClass("sync-red")) bankList[idx].state = "select";
			}else{
				$(obj).addClass("sync-blue");
				if(!$(obj).hasClass("sync-red")) bankList[idx].state = "update";
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
		case "button" :
			$el = $("<button>").addClass("btn-gray trs size-sm").val(item[name]).text(item[name]);
			break;
		}
		$el.attr("name", "sync").data("bankSeq", item.bankSeq).data("name", name);

		if(item.state === "insert") $el.addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[cloneNoIdx[item.bankSeq]][name] === item[name]){
				$el.removeClass("sync-blue");
			}else{
				$el.addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
			$el.addClass("sync-red");
			if(clone[cloneNoIdx[item.bankSeq]][name] !== $el.val()){
				$el.addClass("sync-blue");
			}
		}		
		return $el;
	}
}
</script>

<div id="searchBar" class="search-bar pull-right">	
	<button id="saveBtn" class="btn-gray trs">저장</button>
	<button id="cancelBtn" class="btn-gray trs">취소</button>
</div>
<div id="bankList"></div>